//
//  EventDetailsViewController.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "UsersEventsTableViewController.h"

#import "SwitchTableViewCell.h"

#import "ApplicationConstants.h"

@interface EventDetailsViewController ()
<SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;

@property (nonatomic, strong) NSMutableArray * loggedUserEvents;

@end

typedef enum
{
    kEventName,
    kEventLocation,
    kEventEntryType,
    kEventThumbnailImage,
    kEventFullImage
}
kEventArrayConstants;

@implementation EventDetailsViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.currentEventArray[kEventName], NSLocalizedString(@"Details", nil)];
    
    self.fullImageView.image = [UIImage imageNamed:self.currentEventArray[kEventFullImage]];
    
    //register for cell
    UINib * nib = [UINib nibWithNibName:@"SwitchTableViewCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"SwitchTableViewCellIdentifier"];
    
    if(!self.isPresentedModally) {
        //adding gesture recognizers to show screen upon swipe
        UISwipeGestureRecognizer * leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(showTrackedEventsForUser)];
        [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:leftSwipeRecognizer];
    }
    else {
        //add button to dismiss
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(doneButtonClicked)];
        self.navigationItem.leftBarButtonItem = doneButton;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
    NSArray * loggedUserEvents = [userDefaults valueForKey:currentUser];
    
    self.loggedUserEvents = [NSMutableArray array];
    
    if(loggedUserEvents.count > 0) {
        [self.loggedUserEvents addObjectsFromArray:loggedUserEvents];
    }
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    //before view disappears, save all changes
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
    [userDefaults setObject:self.loggedUserEvents forKey:currentUser];
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button click method

-(void)doneButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Swipe gesture methods

-(void)showTrackedEventsForUser {
    UsersEventsTableViewController * usersEventScreen = [[UsersEventsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:usersEventScreen animated:YES];
}

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            return 50.0;
            
        default:
            return 44.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
        case 0://event name
        {
            cell.textLabel.text = self.currentEventArray[kEventName];
            cell.detailTextLabel.text = NSLocalizedString(@"Event Name", nil);
        }
            break;
            
        case 1://event location
        {
            cell.textLabel.text = self.currentEventArray[kEventLocation];
            cell.detailTextLabel.text = NSLocalizedString(@"Location", nil);
        }
            break;
            
        case 2://event entry
        {
            NSString * type = self.currentEventArray[kEventEntryType];
            cell.textLabel.text = type;
            
            if([type isEqualToString:@"Free"])
                cell.textLabel.textColor = [UIColor blueColor];
            else
                cell.textLabel.textColor = [UIColor redColor];
            
            cell.detailTextLabel.text = NSLocalizedString(@"Entry Type", nil);
        }
            break;
            
        case 3://track event
        {
            static NSString * switchCellID = @"SwitchTableViewCellIdentifier";
            SwitchTableViewCell * switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellID forIndexPath:indexPath];
            
            if(!switchCell)
                switchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellID];
            
            switchCell.delegate = self;
            switchCell.isIndexRequired = NO;
            
            if([self.loggedUserEvents containsObject:self.currentEventArray])
                [switchCell.switchButton setOn:YES];
            else
                [switchCell.switchButton setOn:NO];
            
            return switchCell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Switch cell delegate implementation

-(void)switchTapped:(BOOL)isSwitchOn {
    if(isSwitchOn) {
        //event tracking started - add to array
        if( ! [self.loggedUserEvents containsObject:self.currentEventArray])
            [self.loggedUserEvents addObject:self.currentEventArray];
    }
    else {
        //event tracking ended - remove from array
        if([self.loggedUserEvents containsObject:self.currentEventArray])
            [self.loggedUserEvents removeObject:self.currentEventArray];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
