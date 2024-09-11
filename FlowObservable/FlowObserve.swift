

import Foundation


public typealias FlowObserve = FlowObserved & FlowObserving

public protocol FlowObserved: AnyObject {
    public typealias FlowObservable<Value>  = ObservableWrapper<Self, Value>

    public typealias Weak<Value: AnyObject>  = WeakWrapper<Self, Value>
}

public typealias ObserverTable = FlowUnionObserver

 protocol FlowObserving: FlowCompatible, AnyObject {}


extension FlowObserving {
    fileprivate var observerTable: ObserverTable {
        if let table = objc_getAssociatedObject(self, &observerTableKey) as? ObserverTable {
            return table
        } else {
            let table = ObserverTable()
            objc_setAssociatedObject(self, &observerTableKey, table, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return table
        }
    }

    fileprivate func cleanObserverTable() {
        observerTable.removeAll()
    }
}
private var observerTableKey: UInt8 = 0


extension FlowWrapper where Base: FlowObserving {
    var observerTable: ObserverTable {
        base.observerTable
    }

    func cleanObserverTable() {
        base.cleanObserverTable()
    }
}


extension ObserverType {
    func held(by table: ObserverTable) {
        table += self
    }
}
