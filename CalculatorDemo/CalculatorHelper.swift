//
//  CalculatorHelper.swift
//  CalculatorDemo
//
//  Created by Alexander Nelzin on 15/10/16.
//  Copyright © 2016 Alexander Nelzin. All rights reserved.
//

import Foundation


enum Operation {
    case Constant(Double)
    case NullaryOperation(() -> Double, String)
    case UnaryOperation((Double) -> Double, (String) -> String)
    case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
    case Equals
}


class CalculatorHelper {

    var decimalDigits: Int

    var result: Double {
        get {
            return accumulator
        }
    }

    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }

    private var accumulator = 0.0

    private var currentPrecedence = Int.max

    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }

    private var operations: Dictionary<String, Operation> = [
            "±": Operation.UnaryOperation({ -$0 }, { "-(" + $0 + ")" }),
            "✕": Operation.BinaryOperation(*, { $0 + " × " + $1 }, 1),
            "÷": Operation.BinaryOperation(/, { $0 + " ÷ " + $1 }, 1),
            "+": Operation.BinaryOperation(+, { $0 + " + " + $1 }, 0),
            "-": Operation.BinaryOperation(-, { $0 + " - " + $1 }, 0),
            "=": Operation.Equals
    ]


    init(decimalDigits: Int) {
        self.decimalDigits = decimalDigits
    }

    func setOperand(operand: Double) {
        accumulator = operand
    }

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .NullaryOperation(let function, let descriptionValue):
                accumulator = function()
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(
                        binaryFunction: function,
                        firstOperand: accumulator
                        )
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
