//
//  ControlSensorsViewController.m
//  playground
//
//  Created by Kevin Liang on 11/18/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlSensorsViewController.h"

@interface ControlSensorsViewController ()

@property (nonatomic, strong) NSTimer *refreshDataTimer;

- (void) refreshSensorData:(NSTimer *)timer;

@end

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation ControlSensorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataTableView.rowHeight = 200;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.refreshDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshSensorData:) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.refreshDataTimer invalidate];
}

- (void) refreshSensorData:(NSTimer *)timer {
    [self.dataTableView reloadData];
}

# pragma mark - table view
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectedRobots.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
    
    WWRobot *robot = (WWRobot *)self.connectedRobots[indexPath.row];
    WWSensorSet *sensorData = robot.history.currentState;
    
    NSMutableString *detail = [NSMutableString stringWithCapacity:2000];
    [detail appendFormat:@"Name: %@\n", robot.name];
    
    //buttons
    WWSensorButton *SButtonMain = (WWSensorButton *)[sensorData sensorForIndex:WW_SENSOR_BUTTON_MAIN];
    WWSensorButton *SButtonOne = (WWSensorButton *)[sensorData sensorForIndex:WW_SENSOR_BUTTON_1];
    WWSensorButton *SButtonTwo = (WWSensorButton *)[sensorData sensorForIndex:WW_SENSOR_BUTTON_2];
    WWSensorButton *SButtonThree = (WWSensorButton *)[sensorData sensorForIndex:WW_SENSOR_BUTTON_3];
    [detail appendFormat:@"Btn Main: %@, ", SButtonMain.isPressed? @"true": @"false"];
    [detail appendFormat:@"Btn 1: %@, ", SButtonOne.isPressed? @"true": @"false"];
    [detail appendFormat:@"Btn 2: %@, ", SButtonTwo.isPressed? @"true": @"false"];
    [detail appendFormat:@"Btn 3: %@", SButtonThree.isPressed? @"true": @"false"];
    [detail appendFormat:@"\n"];
    
    //accelerometer
    WWSensorAccelerometer *SAcc = (WWSensorAccelerometer *)[sensorData sensorForIndex:WW_SENSOR_ACCELEROMETER];
    [detail appendString:@"Accel: "];
    [detail appendFormat:@"X: %3.2f, ", SAcc ? SAcc.x : NAN];
    [detail appendFormat:@"Y: %3.2f, ", SAcc ? SAcc.y : NAN];
    [detail appendFormat:@"Z: %3.2f", SAcc ? SAcc.z : NAN];
    [detail appendFormat:@"\n"];
    
    WWSensorMicrophone *SMic = (WWSensorMicrophone *)[sensorData sensorForIndex:WW_SENSOR_MICROPHONE];
    [detail appendFormat:@"Microphone: "];
    [detail appendFormat:@"Amplitude: %03f, ", SMic ? SMic.amplitude : NAN];
    [detail appendFormat:@"Angle: %3.2f degrees", RADIANS_TO_DEGREES(SMic ? SMic.triangulationAngle : NAN)];
    [detail appendFormat:@"\n"];
    
    if (robot.robotType == WW_ROBOT_DASH) {
        //distance sensors
        WWSensorDistance *SDistFLF = (WWSensorDistance *)[sensorData sensorForIndex:WW_SENSOR_DISTANCE_FRONT_RIGHT_FACING];
        WWSensorDistance *SDistFRF = (WWSensorDistance *)[sensorData sensorForIndex:WW_SENSOR_DISTANCE_FRONT_LEFT_FACING];
        WWSensorDistance *SDistRRF = (WWSensorDistance *)[sensorData sensorForIndex:WW_SENSOR_DISTANCE_BACK];
        [detail appendFormat:@"Distance: "];
        [detail appendFormat:@"Left-Facing: %2.2f, ", SDistFLF ? SDistFLF.reflectance : NAN];
        [detail appendFormat:@"Dist Right-Facing: %2.2f, ", SDistFRF ? SDistFRF.reflectance : NAN];
        [detail appendFormat:@"Dist Tail: %2.2f", SDistRRF ? SDistRRF.reflectance : NAN];
        [detail appendFormat:@"\n"];
        
        //gyro
        WWSensorGyroscope *SGyro = (WWSensorGyroscope *)[sensorData sensorForIndex:WW_SENSOR_GYROSCOPE];
        [detail appendString:@"Gyro: "];
        [detail appendFormat:@"yaw: %3.2f, ", SGyro ? SGyro.yaw : NAN];
        [detail appendFormat:@"pitch: %3.2f, ", SGyro ? SGyro.pitch : NAN];
        [detail appendFormat:@"roll: %3.2f", SGyro ? SGyro.roll : NAN];
        [detail appendFormat:@"\n"];
        
        //head
        WWSensorHeadPosition *SMotorServoHeadPan = (WWSensorHeadPosition *)[sensorData sensorForIndex:WW_SENSOR_HEAD_POSITION_PAN];
        WWSensorHeadPosition *SMotorServoHeadTilt = (WWSensorHeadPosition *)[sensorData sensorForIndex:WW_SENSOR_HEAD_POSITION_TILT];
        [detail appendString:@"Head: "];
        [detail appendFormat:@"Pan: %3.2f degrees, ", RADIANS_TO_DEGREES(SMotorServoHeadPan ? SMotorServoHeadPan.radians : NAN)];
        [detail appendFormat:@"Tilt: %3.2f degrees", RADIANS_TO_DEGREES(SMotorServoHeadTilt ? SMotorServoHeadTilt.radians : NAN)];
        [detail appendFormat:@"\n"];
        
        //encoder
        WWSensorEncoder *SEncoderLW = (WWSensorEncoder *)[sensorData sensorForIndex:WW_SENSOR_ENCODER_LEFT_WHEEL];
        WWSensorEncoder *SEncoderRW = (WWSensorEncoder *)[sensorData sensorForIndex:WW_SENSOR_ENCODER_RIGHT_WHEEL];
        [detail appendString:@"Encoder: "];
        [detail appendFormat:@"Left: %4.2f cm, ", SEncoderLW? SEncoderLW.distance: NAN];
        [detail appendFormat:@"Right: %4.2f cm", SEncoderLW? SEncoderRW.distance: NAN];
        [detail appendFormat:@"\n"];
    }
    
    cell.textLabel.text = detail;
    //[cell.textLabel sizeToFit];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
