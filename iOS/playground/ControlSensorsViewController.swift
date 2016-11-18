//
//  ControlSensorsViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

// Declare radiansToDegrees function
func radiansToDegrees (radians: Double)->Double {
    return radians * 180 / M_PI
}

class ControlSensorsViewController: RobotControlViewController {
    
    private var refreshDataTimer = Timer()

    @IBOutlet weak var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTableView.rowHeight = 200;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDataTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.refreshSensorData(timer:)), userInfo: nil, repeats: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshDataTimer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshSensorData(timer : Timer)  {
        dataTableView.reloadData()
    }

}

extension ControlSensorsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedRobots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        let robot = connectedRobots[indexPath.row]
        let sensorData  = robot.history.currentState() as WWSensorSet
        
        var detail = String()
        detail.append("Name: \(robot.name)\n")
   
        if let button = sensorData.sensor(forIndex: .SENSOR_BUTTON_MAIN) as? WWSensorButton {
            detail.append("Btn Main: \(button.isPressed ? "true" : "false"), ")
        }
        if let button = sensorData.sensor(forIndex: .SENSOR_BUTTON_1) as? WWSensorButton {
            detail.append("Btn 1: \(button.isPressed ? "true" : "false"), ")
        }
        if let button = sensorData.sensor(forIndex: .SENSOR_BUTTON_2) as? WWSensorButton {
            detail.append("Btn 2: \(button.isPressed ? "true" : "false"), ")
        }
        if let button = sensorData.sensor(forIndex: .SENSOR_BUTTON_3) as? WWSensorButton {
            detail.append("Btn 3: \(button.isPressed ? "true" : "false")")
        }
        detail.append("\n")
        
        let sAcc = sensorData.sensor(forIndex: .SENSOR_ACCELEROMETER) as? WWSensorAccelerometer
        //accelerometer
        detail.append("Accel: ")
        if let sAcc = sAcc {
            detail = detail.appendingFormat("X: %3.2f, ", sAcc.x)
            detail = detail.appendingFormat("Y: %3.2f, ", sAcc.y)
            detail = detail.appendingFormat("Z: %3.2f", sAcc.z)
        }
        detail.append("\n")
        
        let sMic = sensorData.sensor(forIndex: .SENSOR_MICROPHONE) as? WWSensorMicrophone
        detail.append("Microphone: ")
        if let sMic = sMic {
            detail = detail.appendingFormat("Amplitude: %03f, ", sMic.amplitude)
            detail = detail.appendingFormat("Angle: %3.2f degrees", radiansToDegrees(radians: sMic.triangulationAngle))
        }
        detail.append("\n")
        
        if (robot.robotType == .ROBOT_DASH) {
            //distance sensors
            let sDistFLF = sensorData.sensor(forIndex: .SENSOR_DISTANCE_FRONT_RIGHT_FACING) as? WWSensorDistance
            let sDistFRF = sensorData.sensor(forIndex: .SENSOR_DISTANCE_FRONT_LEFT_FACING) as? WWSensorDistance
            let sDistRRF = sensorData.sensor(forIndex: .SENSOR_DISTANCE_BACK) as? WWSensorDistance
            detail.append("Distance: ")
            if let sDistFLF = sDistFLF, let sDistFRF = sDistFRF, let sDistRRF = sDistRRF {
                detail = detail.appendingFormat("Left-Facing: %2.2f, ", sDistFLF.reflectance)
                detail = detail.appendingFormat("Dist Right-Facing: %2.2f, ", sDistFRF.reflectance)
                detail = detail.appendingFormat("Dist Tail: %2.2f", sDistRRF.reflectance)
            }
            detail.append("\n")
            
            //gyro
            detail.append("Gyro: ")
            if let sGyro = sensorData.sensor(forIndex: .SENSOR_GYROSCOPE) as? WWSensorGyroscope {
                detail = detail.appendingFormat("yaw: %3.2f, ", sGyro.yaw)
                detail = detail.appendingFormat("pitch: %3.2f, ", sGyro.pitch)
                detail = detail.appendingFormat("roll: %3.2f", sGyro.roll)
            }
            detail.append("\n")
            
            //head
            detail.append("Head: ")
            if let sMotorServoHeadPan =  sensorData.sensor(forIndex: .SENSOR_HEAD_POSITION_PAN) as? WWSensorHeadPosition,
                let sMotorServoHeadTilt = sensorData.sensor(forIndex: .SENSOR_HEAD_POSITION_TILT) as? WWSensorHeadPosition {
                detail = detail.appendingFormat("Pan: %3.2f degrees, ", radiansToDegrees(radians:sMotorServoHeadPan.radians))
                detail = detail.appendingFormat("Tilt: %3.2f degrees", radiansToDegrees(radians:sMotorServoHeadTilt.radians))
            }
            detail.append("\n")
            
            //encoder
            detail.append("Encoder: ")
            if let sEncoderLW = sensorData.sensor(forIndex: .SENSOR_ENCODER_LEFT_WHEEL) as? WWSensorEncoder,
                let sEncoderRW = sensorData.sensor(forIndex: .SENSOR_ENCODER_RIGHT_WHEEL) as? WWSensorEncoder {

                detail = detail.appendingFormat("Left: %4.2f cm, ", sEncoderLW.distance)
                detail = detail.appendingFormat("Right: %4.2f cm", sEncoderRW.distance)
            }
            detail.append("\n")
        }
    
        cell.textLabel?.text = detail;
        //[cell.textLabel sizeToFit)
        return cell;
    }

}
