//
//  UsersEventsTableViewController.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 02/05/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "UsersEventsTableViewController.h"
#import "EventDetailsViewController.h"

#import "SwitchTableViewCell.h"

#import "ApplicationConstants.h"

@interface UsersEventsTableViewController ()
<SwitchCellDelegate>

typedef enum
{
    kEventName,
    kEventLocation,
    kEventEntryType,
    kEventThumbnailImage,
    kEventFullImage
}
kEventArrayConstants;

@property (nonatomic, strong) NSMutableArray * usersEventsArray;

@end

@implementation UsersEventsTableViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //register for cell
    UINib * nib = [UINib nibWithNibName:@"SwitchTableViewCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"SwitchTableViewCellIdentifier"];

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Tracked events for", nil), currentUser];

    self.navigationItem.hidesBackButton = YES;
    
    UISwipeGestureRecognizer * rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(dismissScreen)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
    NSArray * loggedUserEvents = [userDefaults valueForKey:currentUser];
    
    self.usersEventsArray = [NSMutableArray array];
    
    if(loggedUserEvents.count > 0) {
        [self.usersEventsArray addObjectsFromArray:loggedUserEvents];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    //before view disappears, save all changes
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
    [userDefaults setObject:self.usersEventsArray forKey:currentUser];
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipe gesture recognizer methods

-(void)dismissScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.usersEventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * switchCellID = @"SwitchTableViewCellIdentifier";
    SwitchTableViewCell * switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellID forIndexPath:indexPath];
    
    if(!switchCell)
        switchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellID];
    
    switchCell.delegate = self;
    
    [switchCell.switchButton setOn:YES];
    
    switchCell.isIndexRequired = YES;
    switchCell.buttonIndex = indexPath.row;
    
    NSArray * currentEvent = self.usersEventsArray[indexPath.row];
    switchCell.eventNameLabel.text = [NSString stringWithFormat:@"%@, %@", currentEvent[kEventName], currentEvent[kEventLocation]];
    
    return switchCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self moveDataFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

#pragma mark - Table view delegate 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailsViewController * eventDetails = [[EventDetailsViewController alloc] init];
    eventDetails.currentEventArray = self.usersEventsArray[indexPath.row];
    eventDetails.isPresentedModally = YES;
    
    UINavigationController * wrapper = [[UINavigationController alloc] initWithRootViewController:eventDetails];
    [wrapper setModalPresentationStyle:UIModalPresentationFormSheet];
    [wrapper setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController presentViewController:wrapper animated:YES completion:nil];
}

#pragma mark - Switch cell delegate implementation

-(void)switchButton:(UISwitch *)switchButton tappedAtIndex:(NSUInteger)buttonIndex {
    BOOL isSwitchOn = switchButton.isOn;
    
    if(!isSwitchOn) {
        //user has stopped tracking event - remove from list
        
        NSArray * eventToBeRemoved = self.usersEventsArray[buttonIndex];
        [self.usersEventsArray removeObject:eventToBeRemoved];
        
        //update
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * currentUser = [userDefaults valueForKey:LOGGED_USER];
        [userDefaults setObject:self.usersEventsArray forKey:currentUser];
        [userDefaults synchronize];
        
        [self.tableView reloadData];
    }
}

#pragma mark - Private methods

-(void) moveDataFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    NSInteger difference = toIndex - fromIndex;
    
    if(difference > 1) {
        //multiple rows affected - rearrange datasource
        //check for direction of shift
        if(fromIndex < toIndex) {
            //downward
            while(fromIndex+1 < toIndex+1) {
                [self moveDataFromIndex:fromIndex toIndex:fromIndex+1];
                fromIndex++;
            }
        }
        else if(fromIndex > toIndex) {
            //upward
            while(fromIndex-1 > toIndex-1) {
                [self moveDataFromIndex:fromIndex toIndex:fromIndex-1];
                fromIndex--;
            }
        }
    }
    else {
        //2 rows affected - swap
        
        NSArray * arrayAtToIndex = self.usersEventsArray[toIndex];
        NSArray * arrayAtFromIndex = self.usersEventsArray[fromIndex];
        
        [self.usersEventsArray replaceObjectAtIndex:fromIndex withObject:arrayAtToIndex];
        [self.usersEventsArray replaceObjectAtIndex:toIndex withObject:arrayAtFromIndex];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support conditional rearranging of the table view.

*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end