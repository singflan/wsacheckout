//
//  CulturalViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 4/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CulturalViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportCulturalDescription;
@property (weak, nonatomic) IBOutlet UILabel *reportCulturalDateTime;
@property (weak, nonatomic) IBOutlet UILabel *reportCulturalGPS;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;


@end