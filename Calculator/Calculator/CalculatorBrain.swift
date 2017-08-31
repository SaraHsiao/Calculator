//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by KaFeiDou on 2017/8/31.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // private (私人的)、accumulator(累加器)
    // 因為 struct 結構體會自動獲得一個初始化，這將初始化所有的變量。類跟結構之間的一個區別。
    // 使用可選？ 創建 Brain 累加器時，沒有積累的結果，所以在此不設置狀態。
    private var accumulator: Double?
    
    private enum Operation {
        //case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    // var dict: [String: Operation]  跟下面一樣
    // var dicr: Dictionary<String, Operation>
    private var operations: Dictionary<String,Operation> = [
        //"π": Operation.constant(Double.pi),
        //"e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        //"cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        /*
         Closures:
         原本需要定義 function
         func multiply (op1: Double, op2: Double) -> Double {
         return op1 * op2
         }
         對應
         "×": Operation.binaryOperation(multiply)
         
         使用閉包後(閉包原本寫法）
         "×": Operation.binaryOperation({ (op1: Double, op2: Double) -> Double in
         return op1 * op2 })
         
         因為 swift 用型推論（上面 enum binaryOperation((Double, Double) -> Double)
         所以改成下面
         "×": Operation.binaryOperation({ (op1, op2) in return op1 * op2 })
         
         swift 也知道返回這事
         "×": Operation.binaryOperation({ (op1, op2) in op1 * op2 })
         
         swift 也會讓你有你想要任何數量的参数。稱為 $0，＄1，$2...，對於有多少，所以我们並不需要一個域
         "×": Operation.binaryOperation({ in op1 * op2 })
         
         當然 in 就不需要了。
         "×": Operation.binaryOperation({ op1 * op2 })
         */
        "x": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "%": Operation.unaryOperation({ $0 / 100}),
        "=": Operation.equals,
        "AC": Operation.clear
    ]
    // performOperation (執行操作)
    mutating func performOperation(_ symbol: String) {
        // 為什麼使用 if let，因為 operations 是字典，賦值给 operation 時，如果沒有字典裡的值，就不能去回報設值，例如 symbol=T，字典里面沒有對應的值。
        if let operation = operations[symbol] {
            switch operation {
                //case .constant(let value):
            //    accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                accumulator = 0
                pendingBinaryOperation = nil
            }
        }
    }
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        var firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // setOperang(設置操作數）
    // 結構體和枚舉是值類型。默認情況下，值類型的屬性不能在它的實例方法中被修改。
    // 如果你確實需要在某個特定的方法中修改結構體或者枚舉的屬性，你可以為這個方法選擇可變(mutating)行為
    // 然後就可以從其方法內部改變它的屬性；並且這個方法做的任何改變都會在方法執行結束時寫回到原始結構中。
    // 方法還可以給它隱含的self屬性賦予一個全新的實例，這個新實例在方法結束時會替換現存實例。
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    // 計算的結果，只讀
    var result: Double? {
        get {
            return accumulator
        }
    }
}
