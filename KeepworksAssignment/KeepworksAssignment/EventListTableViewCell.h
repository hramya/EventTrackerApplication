//
//  EventListTableViewCell.h
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 01/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryType;

@end
