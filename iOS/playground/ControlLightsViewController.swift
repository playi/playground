//
//  ControlLightsViewController1.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class ControlLightsViewController: RobotControlViewController {
    
    @IBOutlet weak var leftEarRSlider: UISlider!
    @IBOutlet weak var leftEarGSlider: UISlider!
    @IBOutlet weak var leftEarBSlider: UISlider!
    
    @IBOutlet weak var chestRSlider: UISlider!
    @IBOutlet weak var chestGSlider: UISlider!
    @IBOutlet weak var chestBSlider: UISlider!
    
    @IBOutlet weak var rightEarRSlider: UISlider!
    @IBOutlet weak var rightEarGSlider: UISlider!
    @IBOutlet weak var rightEarBSlider: UISlider!
    
    @IBOutlet weak var mainButtonMonoSlider: UISlider!
    
    @IBOutlet weak var backMonoSlider: UISlider!
    
    @IBOutlet weak var lightShowButton: UIButton!
    
    private var lightShowInProgress = false
    private var lightShowTimer = Timer()
    private var lightShowValueState : UInt = 0
    
    
    @IBAction func setRGBLights(_ sender: UISlider) {
        setRGBLights()
    }
    
    @IBAction func setRGBLights() {
    
        let cmd = WWCommandSet()
        cmd.setLeftEarLight(WWCommandLightRGB(red: Double(leftEarRSlider.value), green: Double(leftEarGSlider.value), blue: Double(leftEarBSlider.value)))
        cmd.setRightEarLight(WWCommandLightRGB(red: Double(rightEarRSlider.value), green: Double(rightEarGSlider.value), blue: Double(rightEarBSlider.value)))
        
        cmd.setChestLight(WWCommandLightRGB(red: Double(chestRSlider.value), green: Double(chestGSlider.value), blue: Double(chestBSlider.value)))
        
        cmd.setChestLight(WWCommandLightRGB(red: Double(chestRSlider.value), green: Double(chestGSlider.value), blue: Double(chestBSlider.value)))
        
        cmd.setEyeLight(WWCommandLightRGB(red: Double(chestRSlider.value), green: Double(chestGSlider.value), blue: Double(chestBSlider.value)))
        
        cmd.setMainButtonLight(WWCommandLightMono(brightness: Double(mainButtonMonoSlider.value)))

        cmd.setTailLight(WWCommandLightMono(brightness: Double(backMonoSlider.value)))
        sendCommandSet(toRobots:cmd)
    }
    @IBAction func toggleLightShow(_ sender: UIButton) {
        if lightShowInProgress {
            lightShowInProgress = false
            lightShowTimer.invalidate()
            lightShowButton.setTitle("Start light show", for:.normal)
        }
        else {
            lightShowInProgress = true
            lightShowTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.lightShowTimerValues(timer:)), userInfo: nil, repeats: true)
            lightShowTimer.fire()
            lightShowButton.setTitle("Stop light show", for:.normal)
        }
        
    }
    
    @objc func lightShowTimerValues(timer: Timer) {
        
        var r, g, b, mono : Float
        
        lightShowValueState = (lightShowValueState+1) % 4; // rotate
        switch (lightShowValueState) {
        case 0:
            r = 1.0; g = 0; b = 0; mono = 1.0;
            break;
        case 1:
            r = 0; g = 1.0; b = 0; mono = 0.5;
            break;
        case 2:
            r = 0; g = 0; b = 1.0; mono = 0;
            break;
        case 3:
            r = 0.5; g = 0.5; b = 0.5; mono = 0.75;
            break;
        default:
            r = 0; g = 0; b = 0; mono = 0;
            break;
        }
        
        leftEarRSlider.value = r;
        leftEarGSlider.value = g;
        leftEarBSlider.value = b;
        rightEarRSlider.value = r;
        rightEarGSlider.value = g;
        rightEarBSlider.value = b;
        chestRSlider.value = r;
        chestGSlider.value = g;
        chestBSlider.value = b;
        mainButtonMonoSlider.value = mono;
        backMonoSlider.value = mono;
        
        setRGBLights()
    }

}
