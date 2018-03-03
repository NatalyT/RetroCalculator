//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Nataly Tatarintseva on 2/8/18.
//  Copyright © 2018 Nataly Tatarintseva. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValString = ""
    var rightValString = ""
    var result = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        //runningNumber += "\(sender.tag)"
        //outputLbl.text = runningNumber
        
        if runningNumber == "" && sender.tag == 0 && leftValString == "" {
            runningNumber = ""
            outputLbl.text = "0"
        } else if runningNumber == "" && sender.tag == 0 && rightValString == "" {
            runningNumber = ""
            outputLbl.text = "0"
        } else {
            runningNumber += "\(sender.tag)"
            outputLbl.text = runningNumber
        }
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        playSound()
        outputLbl.text = "0"
        runningNumber = ""
        leftValString = ""
        rightValString = ""
        result = ""
        currentOperation = Operation.Empty
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValString = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValString)! * Double(rightValString)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValString)! / Double(rightValString)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValString)! - Double(rightValString)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValString)! + Double(rightValString)!)"
                }
                leftValString = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            // This is the first time an operator has been pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
}

