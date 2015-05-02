//
//  EventGridCollectionViewCell.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "EventGridCollectionViewCell.h"

@implementation EventGridCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.layer.borderWidth = 2.5;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.layer setCornerRadius:10.0];
}

@end
