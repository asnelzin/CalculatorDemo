//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Alexander Nelzin on 19/09/16.
//  Copyright © 2016 Alexander Nelzin. All rights reserved.
//

import Foundation
import UIKit


class CalculatorViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!

    private var displayValue: Double? {
        get {
            if let text = display.text {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.decimalSeparator = Constants.DecimalSeparator
                formatter.maximumFractionDigits = Constants.DecimalDigits
                if let value = formatter.number(from: text)?.doubleValue {
                    return value
                }
            }
            return nil
        }
        set {
            if let value = newValue {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.decimalSeparator = Constants.DecimalSeparator
                formatter.maximumFractionDigits = Constants.DecimalDigits
                display.text = formatter.string(from: NSNumber(value: value))
            } else {
                display.text = "0"
                isTypingNumber = false
            }
        }
    }

    private var calculatorHelper = CalculatorHelper(decimalDigits: Constants.DecimalDigits)

    private var isTypingFloatingNumber = false
    private var isTypingNumber = false {
        didSet {
            if !isTypingNumber {
                isTypingFloatingNumber = false
            }
        }
    }

    private struct Constants {
        static let DecimalSeparator = "."
        static let DecimalDigits = 6
    }

    @IBAction private func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!

        if digit == Constants.DecimalSeparator {
            if isTypingFloatingNumber {
                return
            }
            if !isTypingNumber {
                digit = "0" + Constants.DecimalSeparator
            }
            isTypingFloatingNumber = true
        }

        if isTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            isTypingNumber = true
        }
    }

    @IBAction private func performOperation(sender: UIButton) {
        if isTypingNumber {
            calculatorHelper.setOperand(operand: displayValue!)
            isTypingNumber = false
        }

        if let symbol = sender.currentTitle {
            calculatorHelper.performOperation(symbol: symbol)
        }

        displayValue = calculatorHelper.result
    }

    @IBAction func clearEverything(sender: UIButton) {
        calculatorHelper = CalculatorHelper(decimalDigits: Constants.DecimalDigits)
        displayValue = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
