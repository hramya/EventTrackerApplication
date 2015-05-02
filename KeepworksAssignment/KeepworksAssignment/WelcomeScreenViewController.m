//
//  WelcomeScreenViewController.m
//  KeepworksAssignment
//
//  Created by Ramya Hebbar on 30/04/15.
//  Copyright (c) 2015 Ramya Hebbar. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "EventListViewController.h"

#import "ImageConstants.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface WelcomeScreenViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation WelcomeScreenViewController

#pragma mark - View lifecycle methods

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self loginButtonClicked:self.loginButton];
    return YES;
}

#pragma mark - Button click implementation

- (IBAction)loginButtonClicked:(id)sender {
    if(self.nameField.text.length > 0) {
        //name entered, proceed to next screen
        EventListViewController * listVC = [[EventListViewController alloc] init];
        listVC.userName = self.nameField.text;
        
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else {
        //no name, show alert
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                         message:NSLocalizedString(@"Enter name to proceed with the application.", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Private methods

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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