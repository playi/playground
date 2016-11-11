//
//  ControlEyeRingViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import Foundation
import UIKit

class ControlEyeRingViewController : RobotControlViewController {
    
    @IBOutlet weak var eye0Switch: UISwitch!
    @IBOutlet weak var eye1Switch: UISwitch!
    @IBOutlet weak var eye2Switch: UISwitch!
    @IBOutlet weak var eye3Switch: UISwitch!
    @IBOutlet weak var eye4Switch: UISwitch!
    @IBOutlet weak var eye5Switch: UISwitch!
    @IBOutlet weak var eye6Switch: UISwitch!
    @IBOutlet weak var eye7Switch: UISwitch!
    @IBOutlet weak var eye8Switch: UISwitch!
    @IBOutlet weak var eye9Switch: UISwitch!
    @IBOutlet weak var eye10Switch: UISwitch!
    @IBOutlet weak var eye11Switch: UISwitch!
    
    @IBOutlet weak var eyeBrightnessSlider: UISlider!
    @IBOutlet weak var eyeShowButton: UIButton!
    
    private var eyeShowInProgress = false
    private var eyeShowTimer = Timer()
    private var eyeShowValueState : UInt = 0

    @IBAction func setEyeRing(_ sender: Any) {
        setEyeRing()
    }
    
    @IBAction func setEyeRing() {
        
        let eyeBitmap = [eye0Switch.isOn,
                         eye1Switch.isOn,
                         eye2Switch.isOn,
                         eye3Switch.isOn,
                         eye4Switch.isOn,
                         eye5Switch.isOn,
                         eye6Switch.isOn,
                         eye7Switch.isOn,
                         eye8Switch.isOn,
                         eye9Switch.isOn,
                         eye10Switch.isOn,
                         eye11Switch.isOn]
        let cmd = WWCommandSet()
        let eyeRing = WWCommandEyeRing(bitmap: eyeBitmap)
        eyeRing?.brightness = Double(eyeBrightnessSlider.value)
        cmd.setEyeRing(eyeRing)
        sendCommandSet(toRobots: cmd)
    }

    
    @IBAction func toggleEyeShow(_ sender: UIButton) {
        if eyeShowInProgress {
            eyeShowInProgress = false
            eyeShowTimer.invalidate()
            eyeShowButton.setTitle("Start eye show", for:.normal)
        }
        else {
            eyeShowInProgress = true
            eyeShowTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(eyeShowTimerValues(timer:)), userInfo: nil, repeats: true)
            eyeShowTimer.fire()
            eyeShowButton.setTitle("Stop eye show", for:.normal)
        }
        
    }
    
    @objc func eyeShowTimerValues(timer: Timer) {
        
        eyeShowValueState = (eyeShowValueState+1) % 12; // rotate
        
        eye0Switch.isOn = ((0 + eyeShowValueState) % 2) == 0
        eye1Switch.isOn = ((1 + eyeShowValueState) % 2) == 0
        eye2Switch.isOn = ((2 + eyeShowValueState) % 2) == 0
        eye3Switch.isOn = ((3 + eyeShowValueState) % 2) == 0
        eye4Switch.isOn = ((4 + eyeShowValueState) % 2) == 0
        eye5Switch.isOn = ((5 + eyeShowValueState) % 2) == 0
        eye6Switch.isOn = ((6 + eyeShowValueState) % 2) == 0
        eye7Switch.isOn = ((7 + eyeShowValueState) % 2) == 0
        eye8Switch.isOn = ((8 + eyeShowValueState) % 2) == 0
        eye9Switch.isOn = ((9 + eyeShowValueState) % 2) == 0
        eye10Switch.isOn = ((10 + eyeShowValueState) % 2) == 0
        eye11Switch.isOn = ((11 + eyeShowValueState) % 2) == 0
        
        let newValue = Double(eyeShowValueState) / 11.0
        eyeBrightnessSlider.value = Float(newValue)
        setEyeRing()
    }

    
    @IBAction func runEyeAnimation(_ sender: Any) {
        let cmd = WWCommandSet()
        let eye = WWCommandEyeRing(animation: WW_EYEANIM_FULL_BLINK)
        cmd.setEyeRing(eye)
        sendCommandSet(toRobots: cmd)

    }

    
}
