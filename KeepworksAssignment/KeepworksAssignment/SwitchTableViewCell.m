//
//  SwitchTableViewCell.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "SwitchTableViewCell.h"

@implementation SwitchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchTapped:(id)sender {
    UISwitch * switchButton = sender;
    
    if(self.isIndexRequired) {
        if([self.delegate respondsToSelector:@selector(switchButton:tappedAtIndex:)])
            [self.delegate switchButton:switchButton tappedAtIndex:self.buttonIndex];
    }
    else {
        if([self.delegate respondsToSelector:@selector(switchTapped:)])
            [self.delegate switchTapped:switchButton.isOn];
    }
}

@end
