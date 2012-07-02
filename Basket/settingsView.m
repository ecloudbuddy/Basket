//
//  settingsView.m
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "settingsView.h"


@implementation settingsView
@synthesize purcahseBtnAction;
@synthesize pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    btnRemoveAd.hidden = [[NSUserDefaults standardUserDefaults] boolForKey:isAdRemoved];
}

- (void)viewDidLoad
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    appdelegate=[[UIApplication sharedApplication] delegate];
    appdelegate.isShakeToClear=[userDefault boolForKey:shaketoClear];
    appdelegate.isiCloud=[userDefault boolForKey:iCoudState];
    if (appdelegate.isShakeToClear) {
        [shakeSwitch setOn:YES];
    }
    else
    {
        [shakeSwitch setOn:NO];
    }
    if ([userDefault boolForKey:iCoudState]) {
        [icloudSwitch setOn:YES];
        appdelegate.isiCloud=TRUE;
    }
    else
    {
        appdelegate.isiCloud=FALSE;
        [icloudSwitch setOn:NO];
    }
    itemD=[[ViewController alloc]init];

    pickerView.delegate=self;
    
    pickerView.dataSource=self;
    [super viewDidLoad];
    fontName =[[NSMutableArray alloc]initWithObjects:@"Helvetica",@"HelveticaNeue",@"Optima",@"Marino",@"Papyrus",@"Verdana", nil];
    fontType=[[NSMutableArray alloc]initWithObjects:@"Bold",@"Italic",@"Regular", nil];
    fontSize=[[NSMutableArray alloc]initWithObjects:@"17",@"18",@"20",@"21", nil];
    int a =[userDefault integerForKey:@"component0"];
    int b = [userDefault integerForKey:@"component1"];
    
    [pickerView selectRow:a inComponent:0 animated:NO];
    [pickerView selectRow:b inComponent:1 animated:NO];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return  [fontName count];
    }
//    else if (component == 1){
//         return [fontType count];
//    }
    else if(component==1)
    {
        return [fontSize count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        return [fontName objectAtIndex:row];   
        
    }
//    else if(component == 1){
//        
//         return [fontType objectAtIndex:row];
//        
//    }
    else if(component == 1){
        
        return [fontSize objectAtIndex:row];
        
    }
    return [NSString stringWithFormat:@"%d - %d",component, row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        if (component == 0) {
           appdelegate.mainView.fontName=[fontName objectAtIndex:row];
            [userdefault setInteger:row forKey:@"component0"];
            [userdefault synchronize];
            [userdefault setValue:[fontName objectAtIndex:row] forKey:fontname];
            [userdefault synchronize];
            
        }
//        else if(component==1)
//        {
//            appdelegate.mainView.fontType=[fontType objectAtIndex:row];
//                  }
        else if(component==1)
        {
           appdelegate.mainView.fontSize=[[fontSize objectAtIndex:row] intValue];
            [userdefault setInteger:row forKey:@"component1"];
            [userdefault synchronize];
            [userdefault setInteger:[[fontSize objectAtIndex:row]intValue] forKey:fontsize];
            [userdefault synchronize];
        }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) {
        return 230.0;
    }
//    if (component==1) {
//        return 100.0;
//    }
    if (component==1) {
        return 70.0;
    }
    return 0.0;
}




//- (IBAction)buttoncliked:(id)sender {
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//   
//    UIButton * btn=sender;
//    if (btn.tag==1) {
//        BOOL isiCloud=[userDefault boolForKey:@"isicloud"];
//        if (isiCloud) {
//            UIImage * img=[UIImage imageNamed:@"checkOff.png"];
//            [icloudBtn setImage:img forState:UIControlStateNormal];
//            [userDefault setBool:0 forKey:@"isicloud"];
//            [userDefault synchronize];
//            isiCloud=!isiCloud;
//        }
//        else
//        {
//             UIImage * img=[UIImage imageNamed:@"checkOn.png"];
//            [icloudBtn setImage:img forState:UIControlStateNormal];
//            [userDefault setBool:1 forKey:@"isicloud"];
//            [userDefault synchronize];
//            isiCloud=!isiCloud;
//        }
//    }
//    else if(btn.tag==2)
//    {
//        BOOL isShake=[userDefault boolForKey:@"isshake"];
//        if (isShake) {
//            UIImage * img=[UIImage imageNamed:@"checkOff.png"];
//            [shakeToSortBtn setImage:img forState:UIControlStateNormal];
//            [userDefault setBool:0 forKey:@"isshake"];
//            [userDefault synchronize];
//        }
//        else
//        {
//            UIImage * img=[UIImage imageNamed:@"checkOn.png"];
//            [shakeToSortBtn setImage:img forState:UIControlStateNormal];
//            [userDefault setBool:1 forKey:@"isshake"];
//            [userDefault synchronize];
//        }
//    }
//}

- (IBAction)shaketoClearSwitchAction:(id)sender {
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([sender isOn]) {
        [userDefault setBool:TRUE forKey:shaketoClear];
        [userDefault synchronize];
        appdelegate.isShakeToClear=TRUE;
    }
    else {
        [userDefault setBool:FALSE forKey:shaketoClear];
        [userDefault synchronize];
        appdelegate.isShakeToClear=FALSE;
    }
}

- (IBAction)icloudSwitchAction:(id)sender {
     NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([sender isOn]) {
        if (appdelegate.isiCloudConfigured) {
            [userDefault setBool:TRUE forKey:iCoudState];
             appdelegate.isiCloud=TRUE;
            [userDefault synchronize];
        }
        
       
       // appdelegate.isShakeToClear=TRUE;
    }
    else {
        appdelegate.isiCloud=FALSE;
        [userDefault setBool:FALSE forKey:iCoudState];
        [userDefault synchronize];
        //appdelegate.isShakeToClear=FALSE;
    }
}



- (IBAction)purchaseBtnAction:(id)sender {
    [removeAidsView removeFromSuperview];
    [self.view addSubview:loadingView];
    
    [self performSelector:@selector(startPayment) withObject:nil afterDelay:0.1];
}

- (IBAction)restoreBtnAction:(id)sender {
    [removeAidsView removeFromSuperview];
    [self.view addSubview:loadingView];
    InAppPurchaseManager *inAppPurchase = [InAppPurchaseManager sharedInstance];
    [inAppPurchase restorePurchase];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successAd) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedAd) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionCancelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canceledAd) name:kInAppPurchaseManagerTransactionCancelNotification object:nil];
    
}

- (IBAction)cancelRemoveAidsBtnAction:(id)sender {
    [removeAidsView removeFromSuperview];
}

- (IBAction)rateBtnAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Basket" 
                                                    message:@"This will work when Basket is on the App Store." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
  
    [alert show];
}

- (IBAction)removeAdsBtnAction:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove ad's" 
//                                                    message:@"Comming soooooon!!!." 
//                                                   delegate:nil 
//                                          cancelButtonTitle:@"OK" 
//                                          otherButtonTitles: nil];
//    [alert show];
    [self.view addSubview:removeAidsView];
    
    
}

-(void)startPayment
{
    InAppPurchaseManager *inAppPurchase = [InAppPurchaseManager sharedInstance];
    [inAppPurchase purchaseProduct];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successAd) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedAd) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionCancelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canceledAd) name:kInAppPurchaseManagerTransactionCancelNotification object:nil];
}

-(void)successAd
{
    //message
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Ads Removed Successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setBool:YES forKey:isAdRemoved];
    [userdefault synchronize];
    btnRemoveAd.hidden = YES;
    [loadingView removeFromSuperview];
}

-(void)failedAd
{
     [loadingView removeFromSuperview];
    
}
-(void)canceledAd
{
     [loadingView removeFromSuperview];
    
}

- (IBAction)backBtnAction:(id)sender {
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    appdelegate.isiCloud=[userDefault boolForKey:iCoudState];
    [appdelegate.mainView.table reloadData];
   
    if (appdelegate.isiCloud) {
       
        [appdelegate.mainView loadNotes];   
    }
    else
    {
        [appdelegate.mainView getAvailabelItems ];
        [appdelegate.mainView.table reloadData];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}
#pragma mark - Open the mail interface

- (IBAction)openMail:(id)sender 
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Basket Support."];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"paul@allendunahoo.com", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        // mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES]; 
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" 
                                                        message:@"Your device doesn't support the composer sheet" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}



#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload{
    [self setPickerView:nil];
//    icloudBtn = nil;
//    shakeToSortBtn = nil;
    btnRemoveAd = nil;
    shakeSwitch = nil;
   
    icloudSwitch = nil;
    removeAidsView = nil;
    [self setPurcahseBtnAction:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
