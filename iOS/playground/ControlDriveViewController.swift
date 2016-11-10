//
//  ControlDriveViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import Foundation


class ControlDriveViewController : RobotControlViewController {

    let ROBOT_SPEED : Float = 50

    @IBOutlet weak var joystick: CircleJoystickView!
    @IBOutlet weak var toggleWiggleBtn: UIButton!

    
    var isWiggling = false
    var isNodding = false
    var wiggleAnimation : WWCommandSetSequence
    var nodAnimation : WWCommandSetSequence
    
    @IBOutlet weak var poseLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        wiggleAnimation = WWCommandSetSequence(fromFileInBundle: "wiggle", fileType: "json")
        nodAnimation = WWCommandSetSequence()
        let lookup = WWCommandSet()
        lookup.setHeadPositionTilt(WWCommandHeadPosition(degree: -20))
        let lookdown = WWCommandSet()
        lookdown.setHeadPositionTilt(WWCommandHeadPosition(degree: 7.5))
        nodAnimation.add(lookup, withDuration: 0.4)
        nodAnimation.add(lookdown, withDuration: 0.4)
        nodAnimation.add(lookup, withDuration: 0.4)
        nodAnimation.add(lookdown, withDuration: 0.4)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        joystick.type = DRIVE_JOYSTICK
        joystick.updateDraggerImage()
        
    }

    @IBAction func toggleWiggle(_ sender: Any) {
        let btnText = isWiggling ? "Start wiggle" : "Stop wiggle"
        for robot in connectedRobots as! [WWRobot] {
            if isWiggling {
                robot.stopCommand(wiggleAnimation)
            }
            else {
                // always start from the beginning of animation
                robot.executeCommand(wiggleAnimation, withOptions: nil)
            }
        }
        
        toggleWiggleBtn.setTitle(btnText, for: .normal)
        isWiggling = !isWiggling
    }
    
    @IBAction func executeNod(_ sender: Any) {
        if !isNodding && !isWiggling {
            for robot in self.connectedRobots as! [WWRobot] {
                robot.executeCommand(nodAnimation, withOptions:nil)
            }
        }
    }
}


extension ControlDriveViewController : JoystickDelegate {
    func onJoystickMoved() {
        let cmd = commandFromJoystick()
        sendCommandSet(toRobots: cmd)
    }
    
    func onJoystickReleased() {
        let stopCmd = WWCommandToolbelt.moveStop()
        sendCommandSet(toRobots: stopCmd)
    }
    
    
    private func commandFromJoystick() -> WWCommandSet {
        let cmdToSend = WWCommandSet()
        
        // use linear angular!
        let joystickPower = self.joystick.power;
        let lin = joystick.getY() * ROBOT_SPEED
        var ang = joystick.getX() * joystickPower * 3.14159 * 2.0
        
        //NSLog(@"sending linear: %5.2f angular: %5.2f", lin, ang);
        
        // fudge factor to be tweaked
        ang *= 0.5;
        if lin < 0 {
            ang *= -1.0;
        }
        
        let linAng = WWCommandBodyLinearAngular(linear: Double(lin), angular: Double(ang))
        cmdToSend.setBodyLinearAngular(linAng)
        return cmdToSend;
    }

}

extension ControlDriveViewController { // : WWRobotObserver {
    override func robot(_ robot: WWRobot!, didFinishCommand sequence: WWCommandSetSequence!) {
        if sequence == wiggleAnimation {
            if isWiggling {
                // continue to wiggle until user stops
                for robot in connectedRobots as! [WWRobot] {
                    robot.executeCommand(wiggleAnimation, withOptions: nil)
                }
            } else {
                // this is a nod sequence
                isNodding = false
            }
        }
    }
    
    override func robot(_ robot: WWRobot!, didStopExecutingCommand sequence: WWCommandSetSequence!, withResults results: [AnyHashable : Any]!) {
        print("wiggle sequence terminated by user.");
        for robot in connectedRobots as! [WWRobot] {
            robot.resetState()
        }
    }
}

extension ControlDriveViewController {
    @IBAction func didChangePoseDistanceValue(_ sender: UISlider) {
        
        self.poseLabel.text = "\(Int(sender.value))";
    }
    
    @IBAction func MoveDashByFixedDistance(_ sender: Any) {
    
        let cmdToSend = WWCommandSet()
        let distance = Double(poseLabel.text ?? "0") ?? 0.0
    
        let bodyPose = WWCommandBodyPose(relativeMeasuredX:distance, y:0.0, radians:0.0, time:2.0)
        cmdToSend.setBodyPose(bodyPose)
        sendCommandSet(toRobots: cmdToSend)
    }
    
}
