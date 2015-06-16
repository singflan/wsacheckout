//
//  PlantsViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 1/28/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlantsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportPlantlifeDescription;
@property (weak, nonatomic) IBOutlet UILabel *reportPlantlifeDateTime;
@property (weak, nonatomic) IBOutlet UILabel *reportPlantlifeGPS;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
