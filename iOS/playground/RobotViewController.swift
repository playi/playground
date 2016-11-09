//
//  RobotViewController.swift
//  playground
//
//  Created by Jelle Alten on 09-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class RobotViewController: UIViewController {
    var connectedRobots = [Robot]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshConnectedRobots()
    }
    
    func refreshConnectedRobots() {
        connectedRobots = RobotManager.sharedInstance.allConnectedRobots
        for robot in connectedRobots {
            robot.add(observer:self)
        }
    }
    
    func sendCommandSetToRobots(cmd: CommandSet) {
        for robot in connectedRobots {
            robot.send(command: cmd)
        }
    }


}

extension RobotViewController : RobotObserver {
    func robot(_ robot: Robot, eventsTriggered events:[RobotEvent]) {
        
    }
    func robot(_ robot: Robot, didReceiveRobotState state:SensorSet) {
        
    }
    func robot(_ robot: Robot, didStopExecutingCommandSequence sequence:CommandSetSequence,
               withResults results:[String:String]) {
        
    }
    func robot(_ robot: Robot, didFinishCommandSequence sequence:CommandSetSequence) {
        
    }
}


