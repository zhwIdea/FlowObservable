
import Foundation

protocol FlowCombineObserverType: AnyObject{
    func sendValue(for option: FlowObserveOptions)
}


public typealias FlowCombineSubscriber<Value> = (_ value: Value, _ option: FlowObserveOptions) -> Void


public class FlowCombineObserver<CombineValue>: FlowCombineObserverType {

    fileprivate var options = FlowObserveOptions([])

    fileprivate var subscriber: FlowCombineSubscriber<CombineValue> = {_, _ in }

    func sendValue(for option: FlowObserveOptions) {}

    public func combineObserve(options: FlowObserveOptions = [.initial, .new], subscriber: @escaping FlowCombineSubscriber<CombineValue>) -> Observer {
        guard options.isCombineVaild else {
            assertionFailure("invalid combine observe options")
            return Observer(nil)
        }
        self.options = options
        self.subscriber = subscriber
        if options.contains(.initial) {
            sendValue(for: .initial)
        }
        if options == .initial {
            return Observer(nil)
        }
        return Observer(self)
    }
}


/// CombineObserver2
public class CombineObserver2<V1, V2>: FlowCombineObserver<(V1, V2)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue), option)
    }
}


extension Scheduler {
    public static func & <T>(left: Scheduler, right: Scheduler<T>) -> CombineObserver2<Value, T> {
        let observer = CombineObserver2(scd1: left, scd2: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver3
public class CombineObserver3<V1, V2, V3>: FlowCombineObserver<(V1, V2, V3)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue), option)
    }
}


extension CombineObserver2 {
    public static func & <T>(left: CombineObserver2, right: Scheduler<T>) -> CombineObserver3<V1, V2, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        let observer = CombineObserver3(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver4
public class CombineObserver4<V1, V2, V3, V4>: FlowCombineObserver<(V1, V2, V3, V4)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>
    fileprivate let schedulerFlow4: Scheduler<V4>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
        schedulerFlow4 = scd4
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue, schedulerFlow4.lastValue), option)
    }
}


extension CombineObserver3 {
    public static func & <T>(left: CombineObserver3, right: Scheduler<T>) -> CombineObserver4<V1, V2, V3, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        left.schedulerFlow3.removeFlowCombineObserver(left)
        let observer = CombineObserver4(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: left.schedulerFlow3, scd4: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        observer.schedulerFlow4.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver5
public class CombineObserver5<V1, V2, V3, V4, V5>: FlowCombineObserver<(V1, V2, V3, V4, V5)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>
    fileprivate let schedulerFlow4: Scheduler<V4>
    fileprivate let schedulerFlow5: Scheduler<V5>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
        schedulerFlow4 = scd4
        schedulerFlow5 = scd5
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue, schedulerFlow4.lastValue, schedulerFlow5.lastValue), option)
    }
}


extension CombineObserver4 {
    public static func & <T>(left: CombineObserver4, right: Scheduler<T>) -> CombineObserver5<V1, V2, V3, V4, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        left.schedulerFlow3.removeFlowCombineObserver(left)
        left.schedulerFlow4.removeFlowCombineObserver(left)
        let observer = CombineObserver5(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: left.schedulerFlow3, scd4: left.schedulerFlow4, scd5: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        observer.schedulerFlow4.appendFlowCombineObserver(observer)
        observer.schedulerFlow5.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver6
public class CombineObserver6<V1, V2, V3, V4, V5, V6>: FlowCombineObserver<(V1, V2, V3, V4, V5, V6)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>
    fileprivate let schedulerFlow4: Scheduler<V4>
    fileprivate let schedulerFlow5: Scheduler<V5>
    fileprivate let schedulerFlow6: Scheduler<V6>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
        schedulerFlow4 = scd4
        schedulerFlow5 = scd5
        schedulerFlow6 = scd6
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue, schedulerFlow4.lastValue, schedulerFlow5.lastValue, schedulerFlow6.lastValue), option)
    }
}


extension CombineObserver5 {
    public static func & <T>(left: CombineObserver5, right: Scheduler<T>) -> CombineObserver6<V1, V2, V3, V4, V5, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        left.schedulerFlow3.removeFlowCombineObserver(left)
        left.schedulerFlow4.removeFlowCombineObserver(left)
        left.schedulerFlow5.removeFlowCombineObserver(left)
        let observer = CombineObserver6(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: left.schedulerFlow3, scd4: left.schedulerFlow4, scd5: left.schedulerFlow5, scd6: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        observer.schedulerFlow4.appendFlowCombineObserver(observer)
        observer.schedulerFlow5.appendFlowCombineObserver(observer)
        observer.schedulerFlow6.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver7
public class CombineObserver7<V1, V2, V3, V4, V5, V6, V7>: FlowCombineObserver<(V1, V2, V3, V4, V5, V6, V7)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>
    fileprivate let schedulerFlow4: Scheduler<V4>
    fileprivate let schedulerFlow5: Scheduler<V5>
    fileprivate let schedulerFlow6: Scheduler<V6>
    fileprivate let schedulerFlow7: Scheduler<V7>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>, scd7: Scheduler<V7>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
        schedulerFlow4 = scd4
        schedulerFlow5 = scd5
        schedulerFlow6 = scd6
        schedulerFlow7 = scd7
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue, schedulerFlow4.lastValue, schedulerFlow5.lastValue, schedulerFlow6.lastValue, schedulerFlow7.lastValue), option)
    }
}


extension CombineObserver6 {
    public static func & <T>(left: CombineObserver6, right: Scheduler<T>) -> CombineObserver7<V1, V2, V3, V4, V5, V6, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        left.schedulerFlow3.removeFlowCombineObserver(left)
        left.schedulerFlow4.removeFlowCombineObserver(left)
        left.schedulerFlow5.removeFlowCombineObserver(left)
        left.schedulerFlow6.removeFlowCombineObserver(left)
        let observer = CombineObserver7(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: left.schedulerFlow3, scd4: left.schedulerFlow4, scd5: left.schedulerFlow5, scd6: left.schedulerFlow6, scd7: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        observer.schedulerFlow4.appendFlowCombineObserver(observer)
        observer.schedulerFlow5.appendFlowCombineObserver(observer)
        observer.schedulerFlow6.appendFlowCombineObserver(observer)
        observer.schedulerFlow7.appendFlowCombineObserver(observer)
        return observer
    }
}


/// CombineObserver8
public class CombineObserver8<V1, V2, V3, V4, V5, V6, V7, V8>: FlowCombineObserver<(V1, V2, V3, V4, V5, V6, V7, V8)> {
    fileprivate let schedulerFlow1: Scheduler<V1>
    fileprivate let schedulerFlow2: Scheduler<V2>
    fileprivate let schedulerFlow3: Scheduler<V3>
    fileprivate let schedulerFlow4: Scheduler<V4>
    fileprivate let schedulerFlow5: Scheduler<V5>
    fileprivate let schedulerFlow6: Scheduler<V6>
    fileprivate let schedulerFlow7: Scheduler<V7>
    fileprivate let schedulerFlow8: Scheduler<V8>

    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>, scd7: Scheduler<V7>, scd8: Scheduler<V8>) {
        schedulerFlow1 = scd1
        schedulerFlow2 = scd2
        schedulerFlow3 = scd3
        schedulerFlow4 = scd4
        schedulerFlow5 = scd5
        schedulerFlow6 = scd6
        schedulerFlow7 = scd7
        schedulerFlow8 = scd8
    }

    override func sendValue(for option: FlowObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((schedulerFlow1.lastValue, schedulerFlow2.lastValue, schedulerFlow3.lastValue, schedulerFlow4.lastValue, schedulerFlow5.lastValue, schedulerFlow6.lastValue, schedulerFlow7.lastValue, schedulerFlow8.lastValue), option)
    }
}


extension CombineObserver7 {
    public static func & <T>(left: CombineObserver7, right: Scheduler<T>) -> CombineObserver8<V1, V2, V3, V4, V5, V6, V7, T> {
        left.schedulerFlow1.removeFlowCombineObserver(left)
        left.schedulerFlow2.removeFlowCombineObserver(left)
        left.schedulerFlow3.removeFlowCombineObserver(left)
        left.schedulerFlow4.removeFlowCombineObserver(left)
        left.schedulerFlow5.removeFlowCombineObserver(left)
        left.schedulerFlow6.removeFlowCombineObserver(left)
        left.schedulerFlow7.removeFlowCombineObserver(left)
        let observer = CombineObserver8(scd1: left.schedulerFlow1, scd2: left.schedulerFlow2, scd3: left.schedulerFlow3, scd4: left.schedulerFlow4, scd5: left.schedulerFlow5, scd6: left.schedulerFlow6, scd7: left.schedulerFlow7, scd8: right)
        observer.schedulerFlow1.appendFlowCombineObserver(observer)
        observer.schedulerFlow2.appendFlowCombineObserver(observer)
        observer.schedulerFlow3.appendFlowCombineObserver(observer)
        observer.schedulerFlow4.appendFlowCombineObserver(observer)
        observer.schedulerFlow5.appendFlowCombineObserver(observer)
        observer.schedulerFlow6.appendFlowCombineObserver(observer)
        observer.schedulerFlow7.appendFlowCombineObserver(observer)
        observer.schedulerFlow8.appendFlowCombineObserver(observer)
        return observer
    }
}


extension CombineObserver8 {
    public static func & <T>(left: CombineObserver8, right: Scheduler<T>) -> CombineObserver8 {
        assertionFailure("The count of combined observers exceeds the maximum limit.")
        return left
    }
}
