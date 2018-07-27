//
//  ViewController.swift
//  Calculator++
//
//  Created by Douglas Putnam on 6/18/18.
//  Copyright © 2018 Douglas Putnam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    var numberOnScreen: Double = 0.0
    var previousNumber: Double = 0.0
    var calculatedNumber: Double = 0.0
    
    var currentOperator: String = ""
    
    var decimalIsPressed: Bool = false
    var clearScreen: Bool = true
    var isNumber: Bool = false
    var isEquals: Bool = false
    var readyToPerformSameCalculation: Bool = false
    var isOperator: Bool = false
    var isSwitchingOperators: Bool = false
    
    var symbolPressed: String = ""
    var returnString: String = "0"
    
    
    //For secret combonation
    var entryLog: String = ""
    let magicCombo: String = "1174AC"
    
    @IBOutlet weak var screenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set calculator to 0
        screenLabel.text = "0"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func keyPressed(_ sender: UIButton) {
        
        //Initiate check to see if user is switching operators
        if isOperator {
            isSwitchingOperators = true
        }
        
        //Get the symbol that was pressed
        symbolPressed = convertTagToSymbol(tag: sender.tag)
        //print("symbolPressed = \(symbolPressed)")
        
        //Process input if symbol is recognizable
        if symbolPressed != "Error" {
            
            //capture all entries until "AC" is pressed
            entryLog += symbolPressed
            //print(entryLog)
            
            //Complete check to see if user is switching operators
            if isOperator == false || isSwitchingOperators == false {
                isSwitchingOperators = false
                
                //Prep for new calculation when number is pressed immediately after equal sign is pressed
                if isNumber {
                    if isEquals {
                        //print("Number was pressed immediately after equal sign... Reset calc")
                        screenLabel.text = ""
                        calc(input: "AC")
                    } else {
                        isNumber = false
                    }
                }
                
                //Store number on screen
                if let doubleNumber = Double(screenLabel.text!) {
                    numberOnScreen = doubleNumber
                    //print("Number on Screen: \(numberOnScreen)")
                } else {
                    numberOnScreen = 0
                    //print("Set number on screen to 0")
                }
                
                //clear screen if operator was pressed in prior loop
                if clearScreen {
                    screenLabel.text = ""
                    clearScreen = false
                }
                
                //update return string with results
                if let text = screenLabel.text {
                    returnString = text
                } else {
                    returnString = ""
                }
                calc(input: symbolPressed)
                
                //Format results
                returnString = formatText(text: returnString)
                
                //Update UI with formatted results
                screenLabel.text = returnString
                
            } else {
                currentOperator = symbolPressed
            }
            
        } else {
            print("Invalid Symbol Value: \(symbolPressed)")
        }
        
    }
    
    
    //Function to handle logic for calculator
    func calc(input: String) {
        switch input {
        case "0":
            returnString += input
        case "1":
            returnString += input
        case "2":
            returnString += input
        case "3":
            returnString += input
        case "4":
            returnString += input
        case "5":
            returnString += input
        case "6":
            returnString += input
        case "7":
            returnString += input
        case "8":
            returnString += input
        case "9":
            returnString += input
        case ".":
            if decimalIsPressed == false {
                decimalIsPressed = true
                returnString += input
            }
        case "AC":
            if entryLog == magicCombo {
                performSegue(withIdentifier: "goToSecretPage", sender: self)
            }
            entryLog = ""
            returnString = ""
            currentOperator = ""
            numberOnScreen = 0.0
            previousNumber = 0.0
            decimalIsPressed = false
            isNumber = false
            isEquals = false
            clearScreen = true
            readyToPerformSameCalculation = false
            isSwitchingOperators = false
            isOperator = false
        case "+/-":
            returnString = String(-1 * numberOnScreen)
        case "%":
            if currentOperator == "" || readyToPerformSameCalculation {
                returnString = String(numberOnScreen / 100)
                readyToPerformSameCalculation = false
            } else {
                calc(input: "=")
                currentOperator = ""
                numberOnScreen = calculatedNumber
                calc(input: "%")
            }
        ///////////////////
        case "=":
            //perform current operation
            if readyToPerformSameCalculation {
                calculatedNumber = previousNumber
                previousNumber = numberOnScreen
                numberOnScreen = calculatedNumber
            }
            switch currentOperator {
            case "/":
                calculatedNumber = previousNumber / numberOnScreen
            case "*":
                calculatedNumber = previousNumber * numberOnScreen
            case "-":
                calculatedNumber = previousNumber - numberOnScreen
            case "+":
                calculatedNumber = previousNumber + numberOnScreen
            default:
                calculatedNumber = numberOnScreen
            }
            
            //set return string equal to operational result
            returnString = String(calculatedNumber)
            
            //store number on screen as previous number unless
            previousNumber = numberOnScreen
            readyToPerformSameCalculation = true
            
         /////////////////////////////////
        //Operator Symbols / + - *
        default:
            //if user is changing operator, do not run calculations
            if isSwitchingOperators == false {
                
                //complete any pending calculations
                calculatedNumber = 0
                if currentOperator != "" && readyToPerformSameCalculation == false {
                    //print("completing pending calculations")
                    calc(input: "=")
                }
                
                //reset for new operation
                readyToPerformSameCalculation = false
                
                //save current number on screen
                if calculatedNumber != 0 {
                    previousNumber = calculatedNumber
                } else {
                    previousNumber = numberOnScreen
                }
                
                //queue app to get next number on screen
                clearScreen = true
                
                //reset logic
                isEquals = false
                
            }
            
            //update current operator
            currentOperator = input
            decimalIsPressed = false
            
        }
    }
    
    
    //Function to format the output text
    func formatText(text: String) -> String {
        var returnValue: String = text
        //No blank screen
        if returnValue == "" {
            returnValue = "0"
        }
        //No leading zeros except before a decimal
        //No trailing zeros or decimal
        //commas seperating triple digits
        //print("Formatted output text: \(returnValue)")
        return returnValue
    }
    
    
    //Function to convert UIButton tags to recognizable characters
    func convertTagToSymbol(tag: Int) -> String {
        switch tag {
        case 0:
            isOperator = false
            isNumber = true
            return "0"
        case 1:
            isOperator = false
            isNumber = true
            return "1"
        case 2:
            isOperator = false
            isNumber = true
            return "2"
        case 3:
            isOperator = false
            isNumber = true
            return "3"
        case 4:
            isOperator = false
            isNumber = true
            return "4"
        case 5:
            isOperator = false
            isNumber = true
            return "5"
        case 6:
            isOperator = false
            isNumber = true
            return "6"
        case 7:
            isOperator = false
            isNumber = true
            return "7"
        case 8:
            isOperator = false
            isNumber = true
            return "8"
        case 9:
            isOperator = false
            isNumber = true
            return "9"
        case 10:
            isOperator = false
            isNumber = true
            return "."
        case 11:
            isOperator = false
            return "AC"
        case 12:
            isOperator = false
            isEquals = true
            return "+/-"
        case 13:
            isOperator = false
            isEquals = true
            return "%"
        case 14:
            isOperator = true
            decimalIsPressed = false
            return "/"
        case 15:
            isOperator = true
            decimalIsPressed = false
            return "*"
        case 16:
            isOperator = true
            decimalIsPressed = false
            return "-"
        case 17:
            isOperator = true
            decimalIsPressed = false
            return "+"
        case 18:
            isOperator = false
            isEquals = true
            decimalIsPressed = false
            return "="
        default:
            print("Button Tag Error. Unrecognized Tag Value: \(tag)")
            return "Error"
        }
        
    }
  
    
    
    
}

