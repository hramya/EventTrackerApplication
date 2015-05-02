//
//  SwitchTableViewCell.h
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>

@optional

-(void)switchTapped:(BOOL)isSwitchOn;
-(void)switchButton:(UISwitch *)switchButton tappedAtIndex:(NSUInteger)buttonIndex;

@end

@interface SwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (nonatomic, assign) id<SwitchCellDelegate> delegate;
@property (nonatomic) NSUInteger buttonIndex;
@property (nonatomic) BOOL isIndexRequired;

@end