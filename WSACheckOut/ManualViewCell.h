//
//  ManualViewCell.h
//  WSACheckOut
//
//  Created by Timothy England on 1/19/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *manualThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *manualTitle;

@end
