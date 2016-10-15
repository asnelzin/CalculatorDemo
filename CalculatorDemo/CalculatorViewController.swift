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

    @IBOutlet private weak var history: UILabel!

    private var isTypingFloatingNumber = false
    private var isTypingNumber = false {
        didSet {
            if !isTypingNumber {
                isTypingFloatingNumber = false
            }
        }
    }

    private struct Constants {
        static let DecimalSeparator = NumberFormatter().decimalSeparator!
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
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            isTypingNumber = true
        }
    }

    private var displayValue: Double? {
        get {
            if let text = display.text, value = NSNumberFormatter().numberFromString(text)?.doubleValue {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.maximumFractionDigits = Constants.DecimalDigits
                display.text = formatter.stringFromNumber(value)
                history.text = calculatorHelper.description + (calculatorHelper.isPartialResult ? " …" : " =")
            } else {
                display.text = "0"
                history.text = " "
                isTypingNumber = false
            }
        }
    }

    private var calculatorHelper = CalculatorHelper(decimalDigits: Constants.DecimalDigits)

    @IBAction private func performOperation(sender: UIButton) {
        if isTypingNumber {
            calculatorHelper.setOperand(displayValue!)
            isTypingNumber = false
        } else {
            if let symbol = sender.currentTitle {
                calculatorHelper.performOperation(symbol)
            }
        }

        displayValue = calculatorHelper.result
    }

    @IBAction func backSpace(sender: UIButton) {
        if isTypingNumber {
            if var text = display.text {
                text.remove(at: text.endIndex.predecessor())
                if text.isEmpty {
                    text = "0"
                    isTypingNumber = false
                }
                display.text = text
            }
        }
    }

    @IBAction func clearEverything(sender: UIButton) {
        calculatorHelper = CalculatorHelper(decimalDigits: Constants.DecimalDigits)
        displayValue = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
