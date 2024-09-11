
import UIKit

public struct FlowWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol FlowCompatible {
}

extension FlowCompatible {
   public var flowWra: FlowWrapper<Self> {
        get { FlowWrapper(self) }
        set {}
    }

    static var flowWra: FlowWrapper<Self>.Type {
        get { FlowWrapper<Self>.self}
        set {}
    }
}




