//
//  ClosureChain.swift
//  Pods-RDGameKit_Example
//
//  Created by Bryan Hathaway on 3/12/18.
//

import Foundation

public class ClosureChain {

    private struct Chainable {
        let closure: ChainableClosure
        let delay: TimeInterval
    }

    public typealias ChainableClosure = (() -> ())

    private var chainables: [Chainable] = []

    /// Adds a closure to the chain
    @discardableResult
    public func chain(closure: @escaping ChainableClosure) -> ClosureChain {
        chainables.append(Chainable(closure: closure, delay: 0))
        return self
    }

    /// Adds a closure to the chain that will execute after the specified delay
    @discardableResult
    public func chainAfterDelay(_ delay: TimeInterval, closure: @escaping ChainableClosure) -> ClosureChain {
        chainables.append(Chainable(closure: closure, delay: delay))

        return self
    }

    /// Executes all closures currently chained in order. Closures will be executed on the main thread.
    public func resume() {
        DispatchQueue.global(qos: .background).async {
            self.chainables.forEach { chainable in
                if chainable.delay > 0.0 {
                    Thread.sleep(forTimeInterval: chainable.delay)
                }

                DispatchQueue.main.async {
                    chainable.closure()
                }
            }
        }
    }
}
