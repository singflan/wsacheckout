//
//  DisturbViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 9/30/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisturbViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportDisturbDescription;
@property (weak, nonatomic) IBOutlet UILabel *reportDisturbDateTime;
@property (weak, nonatomic) IBOutlet UILabel *reportDisturbGPS;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
