
import UIKit

//MARK: - Observer
public class Observer {
    var singleObserver: AnyObject?

    init(_ singleObserver: AnyObject?) {
        self.singleObserver = singleObserver
    }

    public static func bind<T: AnyObject, Value>(_ object: T, _ keyPath: WritableKeyPath<T, Value>, _ scheduler: Scheduler<Value>) -> Observer {
        scheduler.observe {[weak object] value, change, option in
            object?[keyPath: keyPath] = value
        }
    }
}


//MARK: - FlowUnionObserver
public class FlowUnionObserver {
    public init() {}

    private var obFlowServerList: [ObserverType]? = []

    public var count: Int { obFlowServerList?.count ?? 0 }

    public func removeObserve(observer: ObserverType) -> ObserverType? {
        guard let index = obFlowServerList?.firstIndex(where: {$0 === observer }) else {
            return nil
        }
        return obFlowServerList?.remove(at: index)
    }

    public func removeAll() {
        obFlowServerList?.removeAll()
    }
}


extension FlowUnionObserver {
    public static func += (left: FlowUnionObserver, right: ObserverType) {
        left.obFlowServerList?.append(right)
    }
}


//MARK: - DistinctObserver
public class DistinctObserver<T> {
    public init() {}

    private var observerMap: [PartialKeyPath<T>: ObserverType]? = [:]

    public var count: Int { observerMap?.count ?? 0 }

    public func removeObserve<Value>(keyPath: KeyPath<T, Value>) -> ObserverType? {
        observerMap?.removeValue(forKey: keyPath)
    }

    public func removeObserve(observer: ObserverType) -> ObserverType? {
        guard let index = observerMap?.firstIndex(where: {$0.value === observer }) else {
            return nil
        }
        return observerMap?.remove(at: index).value
    }

    public func removeAll() {
        observerMap?.removeAll()
    }
}


extension DistinctObserver {
    public subscript<Value>(keyPath: KeyPath<T, Value>) -> ObserverType? {
        get { observerMap?[keyPath]}
        set { observerMap?[keyPath] = newValue }
    }
}


//MARK: - ObserverType
public protocol ObserverType: AnyObject {
    func invalidate()
}


extension Observer: ObserverType {
    public func invalidate() {
        singleObserver = nil
    }
}


extension FlowUnionObserver: ObserverType {
    public func invalidate() {
        obFlowServerList?.forEach { $0.invalidate() }
        obFlowServerList = nil
    }
}


extension DistinctObserver: ObserverType {
    public func invalidate() {
        observerMap?.values.forEach { $0.invalidate() }
        observerMap = nil
    }
}
