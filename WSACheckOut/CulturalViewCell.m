//
//  CulturalViewCell.m
//  WSACheckOut
//
//  Created by Timothy England on 4/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "CulturalViewCell.h"

@implementation CulturalViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor cloudsColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
