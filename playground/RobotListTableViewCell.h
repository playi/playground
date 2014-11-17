//
//  RobotListTableViewCell.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *statusColorView;
@property (weak, nonatomic) IBOutlet UIImageView *robotImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
