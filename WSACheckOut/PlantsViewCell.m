//
//  PlantsViewCell.m
//  WSACheckOut
//
//  Created by Timothy England on 1/28/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "PlantsViewCell.h"

@implementation PlantsViewCell

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
