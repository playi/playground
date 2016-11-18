//
//  ControlHeadViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class ControlHeadViewController: RobotControlViewController {
    
    @IBAction func onMiddleBtnTouch(_ sender: Any) {
        updateRobotHead(pan: 0, tilt: 0)
    }
    @IBAction func onTopBtnTouch(_ sender: Any) {
        updateRobotHead(pan: 0, tilt: -15)
    }
    @IBAction func onButtomBtnTouch(_ sender: Any) {
        updateRobotHead(pan: 0, tilt: 10)
    }
    @IBAction func onLeftBtnTouch(_ sender: Any) {
        updateRobotHead(pan: 90, tilt: 0)
    }
    @IBAction func onRightBtnTouch(_ sender: Any) {
        updateRobotHead(pan: -90, tilt: 0)
    }
    
    private func updateRobotHead(pan panDegree:Float, tilt tiltDegree: Float) {
        let command = WWCommandSet()
        let tilt = WWCommandHeadPosition(degree: Double(tiltDegree))
        let pan = WWCommandHeadPosition(degree: Double(panDegree))
        command.setHeadPositionTilt(tilt, pan: pan)
        sendCommandSet(toRobots: command)
    }
}
