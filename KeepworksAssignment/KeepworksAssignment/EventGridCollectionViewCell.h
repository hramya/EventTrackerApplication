//
//  EventGridCollectionViewCell.h
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventGridCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIImageView *eventThumbnailImage;

@end
