//
//  ControlSoundViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class ControlSoundViewController: RobotControlViewController {

    private var _volume: Double = (WW_VOLUME_MAX - WW_VOLUME_MUTE) / 2.0
    var volume: Double {
        set {
            _volume = newValue
            volumeSlider.value = Float(newValue)
        }
        get {
            return _volume
        }
    }
    var mainButtonTouchUp: WWEvent
    var headPanPositionChanged: WWEvent

    @IBOutlet weak var volumeSlider: UISlider!

    required init?(coder aDecoder: NSCoder) {

        let buttonNumber = NSNumber(value:1000)
        mainButtonTouchUp =  WWEventToolbelt.button(onUp: buttonNumber)
        headPanPositionChanged = WWEvent(shouldAlert: { (event, history) -> Bool in
            guard let history = history, let state = history.currentState(),
                let currHeadPan = state.sensor(forIndex:.SENSOR_HEAD_POSITION_PAN) as? WWSensorHeadPosition,
                let pastHeadPanSensor = history.pastState(atTimeAgo:0.3).sensor(forIndex:.SENSOR_HEAD_POSITION_PAN),
                let prevHeadPan300ms = pastHeadPanSensor as? WWSensorHeadPosition  else {
                    return false
            }
            let diff = currHeadPan.radians - prevHeadPan300ms.radians
            return fabs(diff) > 0.05 // allow for some errors

        }, identifier: "head")

        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        volumeSlider.value =  Float(volume)

        for robot in connectedRobots {
            robot.add(mainButtonTouchUp)
            robot.add(headPanPositionChanged)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for robot in connectedRobots {
            robot.removeAllEvents()
        }
    }

    @IBAction func playSoundPressed(_ sender: Any) {
        let speakerCommand = WWCommandSet()
        if let speaker = WWCommandSpeaker(defaultSound:WW_SOUNDFILE_HI) {
            speaker.volume = Float(volume)
            speakerCommand.setSound(speaker)
            sendCommandSet(toRobots: speakerCommand)
        }
    }
}

// MARK: WWRobotObserver
extension ControlSoundViewController {
    func robot(_ robot: WWRobot!, eventsTriggered events: [Any]!) {
        guard let wwEvents = events as? [WWEvent] else {
            return
        }
        for event in wwEvents as [WWEvent] {
            if mainButtonTouchUp == event {
                self.volume = (volume == WW_VOLUME_MUTE) ? WW_VOLUME_MAX: WW_VOLUME_MUTE
            } else if event.hasIdentifier("head") {
                if let sensor = robot.history.currentState().sensor(forIndex:.SENSOR_HEAD_POSITION_PAN),
                    let headPan = sensor as? WWSensorHeadPosition {
                    volume = headPan.radians / -2.0
                }
            }
        }
    }
}
