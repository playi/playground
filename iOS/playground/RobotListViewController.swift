//
//  RobotListViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

//#import "RobotListViewController.h"
//#import "RobotControlPanelViewController.h"
//#import "RobotControlViewController.h"
//#import "RobotListTableViewCell.h"
//
//@interface RobotListViewController ()
//
//@property NSMutableArray *robots;
//
//@end
//
import UIKit

class RobotListViewController : UITableViewController {
    
    var controlPanelViewController : RobotControlPanelViewController?
    var manager : WWRobotManager?
    var robots = [WWRobot]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            clearsSelectionOnViewWillAppear = false
            preferredContentSize = CGSize(width:320.0, height:600.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let panelViewController = splitViewController?.viewControllers.last as? RobotControlPanelViewController {
            controlPanelViewController = panelViewController
        }
   
        let nib = UINib(nibName: "RobotListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RobotListTableViewCell")
        
        // setup robot manager
        let manager : WWRobotManager = WWRobotManager.shared();
//            NSAssert(self.manager, @"unable to instantiate robot manager");
        manager.add(self)
        
        self.manager = manager
        manager.startScanning(forRobots:2.0)
        
        
        self.tableView.rowHeight = 130
        let start = UIColor(red:58/255.0, green:108/255.0, blue:183/255.0, alpha:0.15)
        let stop = UIColor(red: 58/255.0, green:108/255.0, blue:183/255.0, alpha:0.45)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [start.cgColor,stop.cgColor]
        tableView.layer.insertSublayer(gradient, at:0)
    }
    
//    func insertNewObject() {
//        
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
//            let indexPath = tableView.indexPathForSelectedRow
            if let controller = segue.destination as? RobotControlPanelViewController,
                let splitViewController = splitViewController {
                if #available(iOS 8.0, *) {
                    controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
                } else {
                    // Fallback on earlier versions
                }
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    
    
    
//    #pragma mark - Table View
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return robots.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RobotListTableViewCell", for: indexPath) as? RobotListTableViewCell else {
            return UITableViewCell()
        }

        let robot = robots[indexPath.row]
        if robot.isConnected() {
            cell.contentView.backgroundColor = UIColor(red:50/255.0, green:200/255.0, blue:50/255.0, alpha:0.6)
        }
        else {
            cell.contentView.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha:0.6)
        }
    
        // robot info
        var detail = String()
        detail = detail.appendingFormat("uuId: %@\n", robot.uuId )
        detail = detail.appendingFormat("Firmware %@\n", robot.firmwareVersion)
        detail = detail.appendingFormat("Serial: %@\n", robot.serialNumber)
        detail = detail.appendingFormat("RSSI %d dB\n", robot.signalStrength.intValue)
        detail = detail.appendingFormat("Personality color: %d\n", robot.personalityColorIndex)
        cell.infoLabel.text = detail;
    
        // robot name
        cell.nameLabel.text = robot.name;
    
        // image
        switch (robot.robotType) {
            case .ROBOT_DOT:
                cell.robotImageView.image = UIImage(named:"dot.png")
                break;
            case .ROBOT_DASH:
                cell.robotImageView.image = UIImage(named:"dash.png")
    
            default:
                break;
        }
    
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let robot = robots[indexPath.row]
        if robot.isConnected() {
            manager?.disconnect(from: robot)
        }
        else {
            manager?.connect(to: robot)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


extension RobotListViewController : WWRobotManagerObserver {
    func manager(_ manager: WWRobotManager!, didDiscover robot: WWRobot!) {
        if !robots.contains(robot) {
            robots.append(robot)
            tableView.reloadData()
        }
    }

    
    //- (void) manager:(WWRobotManager *)manager didDiscoverRobot:(WWRobot *)robot {
    //    if (![self.robots containsObject:robot]) {
    //        // found new robots, refresh list
    //        [self.robots addObject:robot];
    //        [self.tableView reloadData];
    //    }
    //}
    //
    
   
    func manager(_ manager: WWRobotManager!, didUpdateDiscoveredRobots robot: WWRobot!) {
        tableView.reloadData()
    }
    //- (void) manager:(WWRobotManager *)manager didUpdateDiscoveredRobots:(WWRobot *)robot {
    //    // existing robots have new data, refresh
    //    [self.tableView reloadData];
    //}
    //
    
    func manager(_ manager: WWRobotManager!, didLose robot: WWRobot!) {
        if let index = robots.index(of: robot) {
            robots.remove(at: index)
        }
        tableView.reloadData()
    }
    //- (void) manager:(WWRobotManager *)manager didLoseRobot:(WWRobot *)robot {
    //    // lost connectivity with existing robot, refresh list
    //    [self.robots removeObject:robot];
    //    [self.tableView reloadData];
    //}
    //
    
    func manager(_ manager: WWRobotManager!, didConnect robot: WWRobot!) {
        tableView.reloadData()
        controlPanelViewController?.activeControlVC.refreshConnectedRobots()
    }
    //- (void) manager:(WWRobotManager *)manager didConnectRobot:(WWRobot *)robot {
    //    // connected with robot, refresh
    //    [self.tableView reloadData];
    //    [self.controlPanelViewController.activeControlVC refreshConnectedRobots];
    //}
    //
    func manager(_ manager: WWRobotManager!, didFailToConnect robot: WWRobot!, error: WWError!) {
        
    }
    //- (void) manager:(WWRobotManager *)manager didFailToConnectRobot:(WWRobot *)robot error:(WWError *)error {
    //    NSLog(@"failed to connect to robot: %@, with error: %@", robot.name, error);
    //    [NSNumber numberWithUnsignedInteger:WW_SENSOR_BUTTON_MAIN];
    //}
    //
    
    func manager(_ manager: WWRobotManager!, didDisconnectRobot robot: WWRobot!) {
        tableView.reloadData()
    }
    //- (void) manager:(WWRobotManager *)manager didDisconnectRobot:(WWRobot *)robot {
    //    // disconnected with robot, refresh
    //    [self.tableView reloadData];
    //}
    //

}

//
//- (void)insertNewObject:(id)sender {
////    if (!self.objects) {
////        self.objects = [[NSMutableArray alloc] init];
////    }
////    [self.objects insertObject:[NSDate date] atIndex:0];
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
////    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}
//
//#pragma mark - Segues
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        RobotControlPanelViewController *controller = (RobotControlPanelViewController *)[[segue destinationViewController] topViewController];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
//}
////#pragma mark - RobotManagerDelegate
////@end
