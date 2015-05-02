//
//  EventListViewController.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 30/04/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailsViewController.h"
#import "UsersEventsTableViewController.h"

#import "ApplicationConstants.h"
#import "ImageConstants.h"

#import "EventListTableViewCell.h"
#import "EventGridCollectionViewCell.h"

#define IPAD_INSET 25

typedef enum
{
    kEventName,
    kEventLocation,
    kEventEntryType,
    kEventThumbnailImage,
    kEventFullImage
}
kEventArrayConstants;

@interface EventListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * eventsListArray;
@property(nonatomic, strong) NSString * screenMode;
@property (nonatomic, strong) UIBarButtonItem * toggleButton;

@end

@implementation EventListViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.userName forKey:LOGGED_USER];
    [userDefaults synchronize];
    
    //initialize data
    [self populateData];
    
    self.eventsListArray = [userDefaults valueForKey:ALL_EVENTS];
    
    self.screenMode = LIST_MODE;
    
    self.toggleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:GRID_ICON]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(toggleButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = self.toggleButton;
    self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@", self.userName];
    
    // set dynamic row heights
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:82];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    //register cells for table and collection view
    UINib * nib = [UINib nibWithNibName:@"EventListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"EventListTableViewCellIdentifier"];
    
    nib = [UINib nibWithNibName:@"EventGridCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"EventGridCollectionViewCellIdentifier"];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self displayBasedOnMode];
    
    //adding gesture recognizers to show screen upon swipe
    UISwipeGestureRecognizer * leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(showTrackedEventsForUser)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipe gesture methods

-(void)showTrackedEventsForUser {
    UsersEventsTableViewController * usersEventScreen = [[UsersEventsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:usersEventScreen animated:YES];
}

#pragma mark - Button click methods

-(void)toggleButtonClicked:(id)sender {
    if([self.screenMode isEqualToString:LIST_MODE]) {
        //toggle to grid
        self.toggleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LIST_ICON]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(toggleButtonClicked:)];
        
        self.navigationItem.rightBarButtonItem = self.toggleButton;
        
        self.screenMode = GRID_MODE;
        [self displayBasedOnMode];
    }
    else {
        //toggle to list
        self.toggleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:GRID_ICON]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(toggleButtonClicked:)];
        
        self.navigationItem.rightBarButtonItem = self.toggleButton;
        
        self.screenMode = LIST_MODE;
        [self displayBasedOnMode];
    }
}

#pragma mark - Collection view datasource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.eventsListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EventGridCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"EventGridCollectionViewCellIdentifier"
                                                                                        forIndexPath:indexPath];
    
    NSArray * currentEvent = self.eventsListArray[indexPath.row];
    
    cell.eventName.text = currentEvent[kEventName];
    cell.eventThumbnailImage.image = [UIImage imageNamed:currentEvent[kEventThumbnailImage]];
    
    return cell;
}

#pragma mark - Collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailsViewController * detailsViewController = [[EventDetailsViewController alloc] init];
    detailsViewController.currentEventArray = self.eventsListArray[indexPath.row];
    detailsViewController.isPresentedModally = NO;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - Collection view flow layout delegate implementation

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat inset;
    inset = IPAD_INSET;
    
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return IPAD_INSET;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return IPAD_INSET;
}

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"EventListTableViewCellIdentifier";
    EventListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSArray * currentEvent = self.eventsListArray[indexPath.row];
    cell.eventName.text = currentEvent[kEventName];
    cell.eventLocation.text = currentEvent[kEventLocation];
    cell.thumbnailImage.image = [UIImage imageNamed:currentEvent[kEventThumbnailImage]];
    [self setLabelPropertiesFor:cell.eventEntryType forText:currentEvent[kEventEntryType]];
    
    return cell;
}

#pragma mark - Tableview delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailsViewController * detailsViewController = [[EventDetailsViewController alloc] init];
    detailsViewController.currentEventArray = self.eventsListArray[indexPath.row];
    detailsViewController.isPresentedModally = NO;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - Private methods

-(void)populateData {
    //inserting initial data
    
    NSArray * event1 = @[NSLocalizedString(@"Metallica Concert", nil),
                         NSLocalizedString(@"Palace Grounds", nil),
                         NSLocalizedString(@"Paid", nil),
                         METALLICA,
                         METALLICA_FULL];
    
    NSArray * event2 = @[NSLocalizedString(@"Saree Exhibition", nil),
                         NSLocalizedString(@"Malleshwaram Grounds", nil),
                         NSLocalizedString(@"Free", nil),
                         SAREE,
                         SAREE_FULL];
    
    NSArray * event3 = @[NSLocalizedString(@"Wine Tasting", nil),
                         NSLocalizedString(@"Links Brewery", nil),
                         NSLocalizedString(@"Paid", nil),
                         WINE,
                         WINE_FULL];
    
    NSArray * event4 = @[NSLocalizedString(@"Startups Meet", nil),
                         NSLocalizedString(@"Kanteerava Indoor Stadium", nil),
                         NSLocalizedString(@"Paid", nil),
                         STARTUP,
                         STARTUP_FULL];
    
    NSArray * event5 = @[NSLocalizedString(@"Summer Noon Party", nil),
                         NSLocalizedString(@"Kumara Park", nil),
                         NSLocalizedString(@"Paid", nil),
                         SUMMER,
                         SUMMER_FULL];
    
    NSArray * event6 = @[NSLocalizedString(@"Rock and Roll Nights", nil),
                         NSLocalizedString(@"Sarjapur Road", nil),
                         NSLocalizedString(@"Paid", nil),
                         ROCK,
                         ROCK_FULL];
    
    NSArray * event7 = @[NSLocalizedString(@"Barbecue Fridays", nil),
                         NSLocalizedString(@"Whitefield", nil),
                         NSLocalizedString(@"Paid", nil),
                         BARBECUE,
                         BARBECUE_FULL];
    
    NSArray * event8 = @[NSLocalizedString(@"Summer Workshop", nil),
                         NSLocalizedString(@"Indiranagar", nil),
                         NSLocalizedString(@"Free", nil),
                         WORKSHOP,
                         WORKSHOP_FULL];
    
    NSArray * event9 = @[NSLocalizedString(@"Impressions & Expressions", nil),
                         NSLocalizedString(@"MG Road", nil),
                         NSLocalizedString(@"Free", nil),
                         IMPRESSIONS,
                         IMPRESSIONS_FULL];
    
    NSArray * event10 = @[NSLocalizedString(@"Italian carnival", nil),
                          NSLocalizedString(@"Electronic City", nil),
                          NSLocalizedString(@"Free", nil),
                          ITALIAN,
                          ITALIAN_FULL];
    
    NSArray * allDataArray = @[event1,
                               event2,
                               event3,
                               event4,
                               event5,
                               event6,
                               event7,
                               event8,
                               event9,
                               event10];
    
    //saving all events
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:allDataArray forKey:ALL_EVENTS];
    [userDefaults synchronize];
}

-(void)displayBasedOnMode {
    if([self.screenMode isEqualToString:LIST_MODE]) {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
    }
    else {
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
}

-(void)setLabelPropertiesFor:(UILabel *)label forText:(NSString *)labelText {
    label.text = labelText;
    
    if([labelText isEqualToString:@"Free"])
        label.backgroundColor = [UIColor blueColor];
    else
        label.backgroundColor = [UIColor redColor];
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
