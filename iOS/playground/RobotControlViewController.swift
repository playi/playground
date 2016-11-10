//
//  RobotControlViewController.swift
//  playground
//
//

protocol RobotControlViewController_P {
    func refreshConnectedRobots()
    func sendCommandSet(toRobots:WWCommandSet)
}

class RobotControlViewController : UIViewController {
    var connectedRobots = [WWRobot]()
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        refreshConnectedRobots()
    }
    
    func refreshConnectedRobots() {
        if let robots = WWRobotManager.shared().allConnectedRobots as? [WWRobot] {
            connectedRobots = robots
            for robot in connectedRobots {
                robot.add(self)
            }
        }
    }
    
    func sendCommandSet(toRobots cmd:WWCommandSet) {
        for robot in connectedRobots {
            robot.send(cmd)
        }
    }
}

extension RobotControlViewController : WWRobotObserver {
}

