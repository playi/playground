//
//  RobotControlPanelViewController.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class RobotControlPanelViewController: UIViewController {

    @IBOutlet weak var controlsSelector: UISegmentedControl!
    @IBOutlet weak var controlsView: UIView!
    var activeControlVC: RobotControlViewController?
    
    var controlsVC = [RobotControlViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let sb = UIStoryboard(name: "Main", bundle: nil)
        if
            let lights = sb.instantiateViewController(withIdentifier: ControlLightsViewController.nameOfClass) as? RobotControlViewController,
                let eyeRing = sb.instantiateViewController(withIdentifier: ControlEyeRingViewController.nameOfClass) as? RobotControlViewController,
                let drive = sb.instantiateViewController(withIdentifier: ControlDriveViewController.nameOfClass) as? RobotControlViewController,
                let head = sb.instantiateViewController(withIdentifier: ControlHeadViewController.nameOfClass) as? RobotControlViewController,
                let sound = sb.instantiateViewController(withIdentifier: ControlSoundViewController.nameOfClass) as? RobotControlViewController,
                let sensor = sb.instantiateViewController(withIdentifier: ControlSensorsViewController.nameOfClass) as? RobotControlViewController {
            
            controlsVC = [lights, eyeRing, drive, head, sound, sensor]
            presentRobotControlsVC(vc: controlsVC.first!)
        }
    }
    
    @IBAction func switchControls(_ control: UISegmentedControl) {
        let newVC = controlsVC[control.selectedSegmentIndex]
        presentRobotControlsVC(vc: newVC)
    }
    

    private func presentRobotControlsVC(vc newVC: RobotControlViewController) {
        if activeControlVC != newVC {
            if let previousVC = activeControlVC {
                previousVC.view.removeFromSuperview()
                previousVC.removeFromParentViewController()
            }
            
            activeControlVC = newVC;
            addChildViewController(newVC)
            controlsView.addSubview(newVC.view)
            newVC.didMove(toParentViewController: self)
        }
    }
    
}
