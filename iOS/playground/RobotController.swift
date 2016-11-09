//
//  RobotController.swift
//  playground
//
//  Created by Jelle Alten on 09-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit


enum RobotType : Int {
    case unknown = 1000
    case dash = 1001
    case dot = 1002
}


enum ScanPeriod {
    case immediate
    case pause(Float)
}


class RobotManager {
    private var originalManager : WWRobotManager {
        return WWRobotManager.shared()
    }

    static let sharedInstance = RobotManager()
    var allConnectedRobots : [Robot] {
        return robotList(originalManager.allConnectedRobots)
    }
    
    private func robotList(_ array : [Any]) -> [Robot] {
        guard let robotArray = array as? [WWRobot] else {
            return [Robot]()
        }
        return robotArray.map { (object) -> Robot in
            return Robot(robotInterface: object)
        }
    }

    private init() {}
    
    func startScanningForRobots(scanPeriod : ScanPeriod) {
        switch scanPeriod {
        case .immediate:
            originalManager.startScanning(forRobots: 0)
        case .pause(let duration):
            originalManager.startScanning(forRobots: duration)
        }
    }

    
}
class RobotEvent{
    init(event:WWEvent) {
        // TODO: event conversion
    }
}
class SensorSet {
}
class CommandSetSequence {
}
class CommandSet {
    private let originalCommandSet : WWCommandSet
    var wwCommandSet : WWCommandSet {
        return self.originalCommandSet
    }
    init() {
        originalCommandSet = WWCommandSet()
    }
}

protocol RobotObserver {

    func robot(_ robot: Robot, eventsTriggered events: [RobotEvent])
    func robot(_ robot: Robot, didReceiveRobotState state:SensorSet)
    func robot(_ robot: Robot, didStopExecutingCommandSequence sequence:CommandSetSequence,
        withResults results:[String:String])
    func robot(_ robot: Robot, didFinishCommandSequence sequence:CommandSetSequence)

}

class Robot : NSObject {
    private let robotInterface : WWRobot
    var observers = [RobotObserver]()
    var robotType: RobotType {
        let type = robotInterface.robotType.rawValue as Int
        guard let robotType = RobotType(rawValue: type) else {
            return RobotType.unknown
        }
        return robotType
    }
    var name : String {
        return robotInterface.name as String
    }
    var uuid : NSUUID {
        guard let uuid = NSUUID(uuidString: robotInterface.uuId) else {
            return NSUUID()
        }
        return uuid
    }
    private override init() {
        robotInterface = WWRobot()
    }
    
    init(robotInterface : WWRobot) {
        self.robotInterface = robotInterface
    }

    func reset() {
        robotInterface.resetState()
    }
    
    func add(observer:RobotObserver) {
        robotInterface.add(self)
        observers.append(observer)
    }
    
    func send(command cmd:CommandSet) {
        robotInterface.send(cmd.wwCommandSet)
    }
}

extension Robot: WWRobotObserver {
    func robot(_ robot: WWRobot!, eventsTriggered events: [Any]!) {
        // TODO
//        let robotEvents = eventsList(events: events)
//        for observer in observers {
//            observer.robot(robot:self, eventsTriggered:events)
//        }
    }
    
    func robot(_ robot: WWRobot!, didReceiveRobotState state: WWSensorSet!) {
        // TODO
    }
    func robot(_ robot: WWRobot!, didFinishCommand sequence: WWCommandSetSequence!) {
        // TODO
    }
    func robot(_ robot: WWRobot!, didStopExecutingCommand sequence: WWCommandSetSequence!, withResults results: [AnyHashable : Any]!) {
        // TODO
    }

    private func eventsList(events: [Any]) -> [RobotEvent] {
        guard let eventArray = events as? [WWEvent] else {
            return [RobotEvent]()
        }
        return eventArray.map({ (event) -> RobotEvent in
            return RobotEvent(event: event)
        })
        
    }
}


