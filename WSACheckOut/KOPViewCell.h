//
//  KOPViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 9/3/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KOPViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kopListNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kopListDateTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView* iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *kopListGPSCoordinates;

@end
