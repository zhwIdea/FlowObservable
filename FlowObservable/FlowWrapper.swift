//
//  FlowWrapper.swift
//  QRVPN
//
//  Created by 君正 on 2024/4/15.
//

import UIKit

struct FlowWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol FlowCompatible {
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




