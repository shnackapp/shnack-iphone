//
//  AccountTableViewController.m
//  Shnack
//
//  Created by Spencer Neste on 9/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "AccountTableViewController.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "SignUpNavController.h"
#import "MBProgressHUD.h"
#import "RootViewController.h"
#import "NSObject_Constants.h"

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
    headerView.backgroundColor = RED_COLOR;
  
  KeychainItemWrapper *password = [[KeychainItemWrapper alloc] initWithIdentifier:@"password" accessGroup:nil];
  [password setObject:@"password" forKey: (__bridge id)kSecAttrService];
  [password setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *email = [[KeychainItemWrapper alloc] initWithIdentifier:@"email" accessGroup:nil];
  [email setObject:@"email" forKey: (__bridge id)kSecAttrService];
  [email setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *name = [[KeychainItemWrapper alloc] initWithIdentifier:@"name" accessGroup:nil];
  [name setObject:@"name" forKey: (__bridge id)kSecAttrService];
  [name setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *phone = [[KeychainItemWrapper alloc] initWithIdentifier:@"phone" accessGroup:nil];
  [phone setObject:@"phone" forKey: (__bridge id)kSecAttrService];
  [phone setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *token = [[KeychainItemWrapper alloc] initWithIdentifier:@"token" accessGroup:nil];
  [token setObject:@"token" forKey: (__bridge id)kSecAttrService];
  [token setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerView.bounds.size.width/2-(30), 32, headerView.bounds.size.width, 64)];//check if this is right!!!
  
  UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.bounds.size.width-60, 20, 60, headerView.bounds.size.height-20)];
  
  saveButton.titleLabel.text = @"Save";
  saveButton.titleLabel.textColor = [UIColor whiteColor];
  saveButton.backgroundColor = RED_COLOR;
  
  [headerView addSubview:saveButton];
  [saveButton addTarget:self action:@selector(save_info) forControlEvents:UIControlEventTouchUpInside];
  
    self.emailLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.phoneLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.name.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.logoutLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.logoutLabel.textColor = RED_COLOR;

    
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
        
    NSLog(@"uses_keychain: %d", uses_keychain ? YES:NO);
    NSLog(@"uses_fb: %d", uses_facebook ? YES:NO);

  
    if(uses_facebook)
    {
      self.email.text =[[fb_user_info valueForKey:@"result"] valueForKey:@"email"];
      self.name.text = [[fb_user_info valueForKey:@"result"] valueForKey:@"name"];
      //from update
      self.phone.text = [shnack_user_info objectForKey:@"phone_number"];
      self.password.text = [shnack_user_info objectForKey:@"password"];

      
      
    
    }
    else if(uses_keychain)
    {
      //change this to all keychain
      self.email.text =[email objectForKey:(__bridge id)(kSecValueData)];
      self.name.text = [name objectForKey:(__bridge id)(kSecValueData)];
      self.phone.text = [phone objectForKey:(__bridge id)(kSecValueData)];
      self.password.text = [password objectForKey:(__bridge id)(kSecValueData)];
    }
    else//get new sign up info or login info from server
    {
      
        self.email.text = [shnack_user_info objectForKey:@"email"];
        self.phone.text = [shnack_user_info objectForKey:@"phone_number"];
        self.password.text = [shnack_user_info objectForKey:@"password"];
        self.name.text =[shnack_user_info objectForKey:@"name"] ;
    }
    
    
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


-(void)save_info
{
  NSLog(@"saving");
  
  if([self.password.text length] == 0 || [self.phone.text length] == 0)
  {
    [self showMessage:@"It looks like you left some fields blank! Please make sure you have the correct credentials and phone number" withTitle:@""];

  }
  else
  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Updating";

  [shnack_user_info setObject:self.email.text forKey:@"email"];
  [shnack_user_info setObject:self.phone.text forKey:@"phone_number"];
  [shnack_user_info setObject:self.name.text forKey:@"name"];
  [shnack_user_info setObject:self.password.text forKey:@"password"];
    
    

  [self performSegueWithIdentifier:@"update" sender:self];
  }
  
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
    else return 64.0f;
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
      KeychainItemWrapper *password = [[KeychainItemWrapper alloc] initWithIdentifier:@"password" accessGroup:nil];
      KeychainItemWrapper *email = [[KeychainItemWrapper alloc] initWithIdentifier:@"email" accessGroup:nil];
      KeychainItemWrapper *name = [[KeychainItemWrapper alloc] initWithIdentifier:@"name" accessGroup:nil];
      KeychainItemWrapper *phone = [[KeychainItemWrapper alloc] initWithIdentifier:@"phone" accessGroup:nil];
      KeychainItemWrapper *token = [[KeychainItemWrapper alloc] initWithIdentifier:@"token" accessGroup:nil];
     

        if(uses_keychain)
        {
          NSLog(@"should present new vc RESET KEYCHAIN");
          [password resetKeychainItem];
          [email resetKeychainItem];
          [name resetKeychainItem];
          [phone resetKeychainItem];

          uses_keychain = NO;
          //[self showMessage:@"You're now logged out" withTitle:@""];
          [self performSegueWithIdentifier:@"log_out_keychain" sender:self];
          //update server with log out time

        }
        else if (FBSessionStateOpen)
        {
            uses_facebook = NO;
          NSLog(@"CLOSE FACEBOOK SESSION");
            [FBSession.activeSession closeAndClearTokenInformation];
            //[self showMessage:@"You're now logged out" withTitle:@""];

          [self performSegueWithIdentifier:@"log_out_keychain" sender:self];
        }
        else
        {
            
        }
    }
}


- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
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
    if([segue.identifier isEqualToString:@"log_out"] || [segue.identifier isEqualToString:@"log_out_keychain"])
    {
        self.email.text = @"";
        self.name.text = @"";
        self.phone.text = @"";
        self.password.text = @"";
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
