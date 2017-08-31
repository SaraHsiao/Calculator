//
//  ViewController.swift
//  Calculator
//
//  Created by KaFeiDou on 2017/8/31.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    /*
     計算機屏幕顯示
     !: 一般都用強制解包，這邊為什麼用！
     因為屏幕剛顯示的時候，系統需要一點時間來關聯控件和代碼。
     所以剛加載的時候，它是缺省值的。關聯之後就是有值的，一直有值的。
     */
    @IBOutlet weak var display: UILabel! // ！: 會隱式解包這個display（隱式解析可選類型）
    
    // 一開始的時候用戶肯定沒有在輸入
    var userIsTheMiddleOfTyping: Bool = false
    
    // 數字鍵（0～9和 . ）
    @IBAction func touchDight(_ sender: UIButton) {
        // 宣告常量 digit，按鈕上顯示的當前標題。
        let digit = sender.currentTitle!
        if userIsTheMiddleOfTyping {
            // 宣告常量textCurrentInDisplay賦值display.text(標籤顯示文字），每次按下某個數字，就把它加到顯示屏最後。比如現在是56，按下2，就是562，按下8，就是5268。
            let textCurrentlyInDisplay = display.text!
            // 因為.text{get, set}，所以可以賦值
            // 限制 display 長度
            // 這邊用到數位邏輯觀念， A +-*/ B (1、0）
            if textCurrentlyInDisplay.characters.count <= 10 {
                if digit != "." || textCurrentlyInDisplay.range(of:".") == nil {
                    if textCurrentlyInDisplay == "0" {
                        if digit == "." {
                            display.text = "0." // 0
                        } else {
                            display.text = digit
                        }
                    } else {
                        display.text = textCurrentlyInDisplay + digit
                    }
                }
            }
        } else {
            if digit == "." {
                display.text = "0." // 0
            }else{
                display.text = digit
            }
            userIsTheMiddleOfTyping = true // 改成 true，可以輸入下個數字
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            // 判斷結果為 xxx.0 轉換成Int型態去掉 0
            if String(newValue).hasSuffix(".0") {
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    // ==> private var brain: CalculatorBrain = CalculatorBrain()
    private var brain = CalculatorBrain()
    
    // 運算符
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsTheMiddleOfTyping  {
            brain.setOperand(displayValue)
            userIsTheMiddleOfTyping = false
        }
        // 宣告數學符號，按鈕上顯示的當前標題，前面有 if let，sender.currentTitle就不需要強制解析
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        // displayValue = brain.result (Double != Double?), so 使用if let。
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

