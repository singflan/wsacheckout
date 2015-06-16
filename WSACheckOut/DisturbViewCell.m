//
//  DisturbViewCell.m
//  WSACheckOut
//
//  Created by Timothy England on 9/30/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "DisturbViewCell.h"

@implementation DisturbViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor cloudsColor];
    
}

@end
