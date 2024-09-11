
import Foundation

public struct FlowObserveOptions: OptionSet {
    public static let initial = FlowObserveOptions(rawValue: 1 << 0)

    public static let prior = FlowObserveOptions(rawValue: 1 << 1)

    public static let new = FlowObserveOptions(rawValue: 1 << 2)

    public static let `defer` = FlowObserveOptions(rawValue: 1 << 3)

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public var isVaild: Bool {
        self.intersection([.initial, .prior, .new, .defer]) != FlowObserveOptions([])
    }

    public var isCombineVaild: Bool {
        // 合并观察时仅支持 .initial 和 .new
        let validOptions: FlowObserveOptions = [.initial, .new]
        return (self.intersection(validOptions) != FlowObserveOptions([])) && (self.symmetricDifference(validOptions) == FlowObserveOptions([]))
    }
}


public class Change<Value> {
    public let oldValue: Value

    public var newValue: Value

    fileprivate init(oldValue: Value, newValue: Value) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
}


public typealias Subscriber<Value> = (_ value: Value, _ change: Change<Value>, _ option: FlowObserveOptions) -> Void


//MARK: - Observable
@propertyWrapper
public class ObservableWrapper<T, Value> where T: AnyObject {
    private var storage: Value

    public var wrappedValue: Value {
        get { storage }
        set {
            let change = Change<Value>(oldValue: storage, newValue: newValue)
            projectedValue.notify(change: change, option: .prior)
            storage = change.newValue
            projectedValue.notify(change: change, option: .new)
            projectedValue.notify(change: change, option: .defer)
        }
    }

    public init(wrappedValue: Value) {
        storage = wrappedValue
    }

    public private(set) lazy var projectedValue = Scheduler<Value>(initialValue: storage)
}


@propertyWrapper
public class WeakWrapper<T, Value> where T: AnyObject, Value: AnyObject {
    public private(set) weak var weakObj: Value?

    public var wrappedValue: Value? {
        get { weakObj }
        set { weakObj = newValue }
    }

    public init(wrappedValue: Value?) {
        weakObj = wrappedValue
    }
}


//MARK: - SingleObserver
class SingleObserver<Value> {
    private var options: FlowObserveOptions

    private var subscriber: Subscriber<Value>

    init(_ options: FlowObserveOptions, _ subscriber: @escaping Subscriber<Value>) {
        self.options = options
        self.subscriber = subscriber
    }

    func send(value: Value, change: Change<Value>, for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber(value, change, option)
    }
}


//MARK: - Scheduler
public class Scheduler<Value> {
    var lastValue: Value

    init(initialValue: Value) {
        self.lastValue = initialValue
    }

    struct WeakRef<T: AnyObject> {
        weak var observer: T?
    }

    /// Single Observe
    private typealias ObserverObj = SingleObserver<Value>

    private var obcfhServerList = [WeakRef<ObserverObj>]()

    public func observe(options: FlowObserveOptions = [.initial, .new], subscriber: @escaping Subscriber<Value>) -> Observer {
        guard options.isVaild else {
            assertionFailure("invalid observe options")
            return Observer(nil)
        }
        let observerObj = ObserverObj(options, subscriber)
        obcfhServerList.append(WeakRef(observer: observerObj))
        if options.contains(.initial) {
            observerObj.send(value: lastValue, change: Change<Value>(oldValue: lastValue, newValue: lastValue), for: .initial)
        }
        if options == .initial {
            return Observer(nil)
        }
        return Observer(observerObj)
    }

    /// Combine Observe
    private var combineOBList = [WeakRef<AnyObject>]()

    func appendFlowCombineObserver<T: FlowCombineObserverType>(_ observer: T) {
        guard combineOBList.filter({ $0.observer === observer }).count == 0 else {
            return
        }
        combineOBList.append(WeakRef (observer: observer))
    }

    func removeFlowCombineObserver<T: FlowCombineObserverType>(_ observer: T) {
        combineOBList = combineOBList.filter({ $0.observer !== observer })
    }

    private var isNotifying = false

    /// Nofity
    func notify(change: Change<Value>, option: FlowObserveOptions) {
        guard !isNotifying else {
            assertionFailure("There is a cycle of observe.")
            return
        }
        isNotifying = true
        defer {
            isNotifying = false
        }

        obcfhServerList = obcfhServerList.compactMap({ weakRef in
            guard let observer = weakRef.observer else {
                return nil
            }
            if option == .prior {
                observer.send(value: change.newValue, change: change, for: option)
            } else {
                // 确保非 .prior 时, 订阅中对 change 的修改不会被传递
                let sendChange =  Change(oldValue: change.newValue, newValue: change.oldValue)
                observer.send(value: change.newValue, change: sendChange, for: option)
            }
            return weakRef
        })

        lastValue = change.newValue

        // 通知合并观察者
        guard option == .new else { return}
        combineOBList = combineOBList.compactMap({ weakRef in
            guard let observer = weakRef.observer as? FlowCombineObserverType else {
                return nil
            }
            observer.sendValue(for: option)
            return weakRef
        })
    }
}
