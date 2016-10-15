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
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(
                    pending!.descriptionOperand,
                    pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "" // TODO
                )
            }
        }
    }
    
    private var accumulator = 0.0
    
    private var currentPrecedence = Int.max
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    private var descriptionAccumulator = "0" {
        didSet {
            if pending == nil {
                currentPrecedence = Int.max
            }
        }
    }
    
    private var operations: Dictionary<String,Operation> = [
        "±" : Operation.UnaryOperation({ -$0 }, { "-(" + $0 + ")"}),
        "×" : Operation.BinaryOperation(*, { $0 + " × " + $1 }, 1),
        "÷" : Operation.BinaryOperation(/, { $0 + " ÷ " + $1 }, 1),
        "+" : Operation.BinaryOperation(+, { $0 + " + " + $1 }, 0),
        "-" : Operation.BinaryOperation(-, { $0 + " - " + $1 }, 0),
        "=" : Operation.Equals
    ]
    
    
    init(decimalDigits:Int) {
        self.decimalDigits = decimalDigits
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalDigits
        descriptionAccumulator = formatter.string(from: NSNumber(value: operand))!
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .NullaryOperation(let function, let descriptionValue):
                accumulator = function()
                descriptionAccumulator = descriptionValue
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                if currentPrecedence < precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator,
                                                     descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
}
