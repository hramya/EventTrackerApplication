//
//  EventDetailsViewController.h
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * currentEventArray;
@property (nonatomic) BOOL isPresentedModally;

@end
