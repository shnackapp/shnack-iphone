//
//  AccountTableViewController.m
//  Shnack
//
//  Created by Spencer Neste on 9/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "AccountTableViewController.h"
#import "KeychainItemWrapper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginContainerViewController.h"
#import "LoginViewController.h"



@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [gestureRecognizer setCancelsTouchesInView:NO];//so we can still select cells

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    NSLog(@"width: %f", headerView.bounds.size.width);
    NSLog(@"height: %f", headerView.bounds.size.height);
    [headerView setBackgroundColor:[UIColor redColor]];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
    
    NSString *tok = [keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *pass = [[NSString alloc] initWithData:[keychain objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
    NSString *acct = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerView.bounds.size.width/2-(30), 32, headerView.bounds.size.width, 64)];//check if this is right!!!
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, 50, 30)];
    addButton.titleLabel.text = @"Cancel";
    addButton.titleLabel.textColor = [UIColor whiteColor];
    addButton.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    //[headerView addSubview:addButton];
    //[headerView addSubview:cancelButton];

    
    self.emailLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.phoneLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.name.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.logoutLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];

    
    self.email.delegate = self;
    self.phone.delegate = self;
    self.password.delegate = self;
    self.name.delegate = self;
    
    // Do any additional setup after loading the view.
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.phone setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.name setBorderStyle:UITextBorderStyleNone];
    
    self.email.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.name.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.email.text = acct;
    self.password.text = pass;
    
    
    
    




    
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = NSLocalizedString(@"Account", @"");
    [label sizeToFit];
    
    

    [headerView addSubview:label];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.scrollEnabled = NO;
    
    
    
    
    
       // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)cancel
{
    NSLog(@"canceled");
}
- (void) hideKeyboard {
    [self.name resignFirstResponder];
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.phone resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0)
    {
        return 4;

    }
    else return 1;
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    if(section == 0)
    {
        return 28.0f;
    }
 return 64.0f;
}

- (BOOL)textField:(UITextField *) textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (textField==self.phone){
        // All digits entered
        if (range.location == 14) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen and parentheses
        if (range.length == 0 && range.location == 3 &&![[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"(%@)-%@", textField.text,string];
            return NO;
        }
        if (range.length == 0 && range.location == 4 &&[[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"%@)-%@", textField.text,string];
            return NO;
        }
        
        // Auto-add 2nd hyphen
        if (range.length == 0 && range.location == 9) {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen and parentheses when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 10 || range.location == 1)){
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        if (range.length == 1 && range.location == 6){
            range.location=range.location-2;
            range.length = 3;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if (indexPath.section ==1)
            {
                
            NSLog(@"selected log out");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm", @"Confirm") message:NSLocalizedString(@"Are you sure you want to log out?", @"Are you sure you want to log out?") delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            
            [alert show];
            }
            
            break;
        }
        default:
            break;
            
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        NSLog(@"NO");
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"YES");
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
        
        [keychainItem resetKeychainItem];
        [self performSegueWithIdentifier:@"log_out" sender:self];
        

    }
}








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"log_out"])
    {
//        LoginContainerViewController *lcvc = [[LoginContainerViewController alloc] init];
//        LoginViewController *lvc = [[LoginViewController alloc] init];
//        
//        lvc.email.text = @"";
//        lvc.password.text = @"";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
