//
//  WildlifeViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 1/16/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WildlifeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportWildlifeDescription;
@property (weak, nonatomic) IBOutlet UILabel *reportWildlifeDateTime;
@property (weak, nonatomic) IBOutlet UILabel *reportWildlifeGPS;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
