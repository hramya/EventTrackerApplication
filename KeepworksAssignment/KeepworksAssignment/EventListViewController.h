//
//  EventListViewController.h
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 30/04/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSString * userName;

@end
