//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Нельзин Александр on 19/09/16.
//  Copyright © 2016 Alexander Nelzin. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var operationsTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        operationsTextView.textContainerInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 5)
        
        resultTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
    }
}


