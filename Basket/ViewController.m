 //
//  ViewController.m
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "itemDetail.h"

#define lineViewTag 1000
#define cellLabelTag 2000

@implementation ViewController
@synthesize table,fontName,fontSize,fontType,notes,query,loaderView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad{ 
    appdelegate=[[UIApplication sharedApplication] delegate];
      NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    if (appdelegate.isiCloudConfigured) {
        [userDefault setBool:YES forKey:iCoudState];
        [userDefault synchronize];
    }
    else
    {
        [userDefault setBool:NO forKey:iCoudState];
        [userDefault synchronize];
        
    }
    
    [userDefault setBool:YES forKey:shaketoClear];
    [userDefault synchronize];
    appdelegate.isiCloud=[userDefault boolForKey:iCoudState];
    appdelegate.mainView=self;
    textfield=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 300, 60)];
    textfield.delegate=self;
    isSwipe=TRUE;

   BOOL isAppRunningFirstTime= [userDefault boolForKey:@"isAppRunningFirstTime"];
    if (!isAppRunningFirstTime) {
        [userDefault setBool:YES forKey:@"isAppRunningFirstTime"];
        [userDefault synchronize];
        [userDefault setValue:@"HelveticaNeue" forKey:fontname];
        [userDefault synchronize];
        [userDefault setInteger:17 forKey:fontsize];
        [userDefault synchronize];
    }
    
    fontName=[userDefault valueForKey:fontname];
    fontSize=[userDefault integerForKey:fontsize];
    isAddBtnPressed=FALSE;
    itemsArr =[[NSMutableArray alloc] init];
    itemsDone=[[NSMutableArray alloc] init];
    itemsNotDone=[[NSMutableArray alloc] init];
    if (appdelegate.isiCloudConfigured) {
        if (appdelegate.isiCloud) {
            [self.view addSubview:loaderView];
            [self loadNotes];
        }
    }
    
    else
    {
         itemsArr=[self getAvailabelItems];
    }
   
    table.delegate=self;
    table.dataSource=self;
    
    ////============== iads=============
  
    appdelegate.isShakeToClear=[userDefault boolForKey:shaketoClear];
    appdelegate.isiCloud=[userDefault boolForKey:iCoudState];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:isAdRemoved])
    {
        adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 460, 320, 50)];
        //adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        bannerIsVisible=NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAds) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];         
    }
    //===============================
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}



-(void)hideAdBanner
{
   
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    // banner is visible and we move it out of the screen, due to connection issue
    //        banner.frame = CGRectOffset(banner.frame, 0, -50);
    adView.center = CGPointMake(adView.center.x, adView.center.y + 100);
//    table.frame=CGRectMake(5, 51, 310, 359);
//    addBtn.frame=CGRectMake(10, 413, 45, 45);
//    clearBtn.frame=CGRectMake(213, 419, 87, 34);
//    bottomLine.frame=CGRectMake(5, 410, 310, 1);
    [UIView commitAnimations];
    
    bannerIsVisible = NO;
}

-(void)removeAds
{
    [self hideAdBanner];
    [adView removeFromSuperview];
    adView = nil;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"error - %@",[error localizedDescription]);
    
    if (bannerIsVisible)
    {
        [self hideAdBanner];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    //NSUInteger row = [indexPath row];
    tableSelection = indexPath;
    tapCount++;
    
    switch (tapCount) {
        case 1: //single tap
           // [self performSelector:@selector(singleTap) withObject: nil afterDelay: .4];
            break;
        case 2: //double tap
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
           // [self performSelector:@selector(doubleTap) withObject: nil];
            //isEdidMode=TRUE;
            [tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table Tap/multiTap

- (void)singleTap {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Single tap detected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];   
    tapCount = 0;
}

- (void)doubleTap {
  //  NSUInteger row = [tableSelection row];
   // companyName = [self.suppliers objectAtIndex:row]; 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"DoubleTap" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles: nil];
    [alert show];
    tapCount = 0;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"laod");
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        //        banner.frame = CGRectOffset(banner.frame, 0, -50);
        banner.center = CGPointMake(banner.center.x, banner.center.y - 100);
//        table.frame=CGRectMake(5, 51, 310, 309);
//        addBtn.frame=CGRectMake(10, 363, 45, 45);
//        clearBtn.frame=CGRectMake(213, 369, 87, 34);
//        bottomLine.frame=CGRectMake(5, 360, 310, 1);
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
    }
}


-(NSMutableArray *)getAvailabelItems{
    [itemsDone removeAllObjects];
    [itemsNotDone removeAllObjects];
    NSLog(@"aray %@",itemsNotDone);
    NSMutableArray *returnArray =[[NSMutableArray alloc] init];
    NSString *SqlStr = [NSString stringWithString:@"SELECT * From items;"];
	sqlite3_stmt *ReturnStatement = [appdelegate getStatement:SqlStr];
   	while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
	{
        itemDetail * itmDetail=[[itemDetail alloc]init];
        itmDetail.itemName= [NSString stringWithUTF8String:(const char *) sqlite3_column_text(ReturnStatement, 1)];
        NSLog(@"name %@",itmDetail.itemName);
         itmDetail.itemId=[[NSString stringWithUTF8String:(const char *) sqlite3_column_text(ReturnStatement, 0)] intValue];
        itmDetail.status=[[NSString stringWithUTF8String:(const char *) sqlite3_column_text(ReturnStatement, 3)] boolValue];
        
        // itmDetail.date=[NSString stringWithUTF8String:(const char *) sqlite3_column_text(ReturnStatement, 3)];
        //itmDetail.sync_iCloud=[[NSString stringWithUTF8String:(const char *) sqlite3_column_text(ReturnStatement, 4)] boolValue];
        
        [returnArray addObject:itmDetail];
    }
    NSLog(@"%d",[returnArray count]);   
    for (int i=0; i<[returnArray count]; i++) {
        itemDetail * itmDetail=[[itemDetail alloc]init];
        itmDetail=[returnArray objectAtIndex:i];
        NSLog(@"status %d",itmDetail.status);
        if (itmDetail.status) {
            
            [itemsDone addObject:itmDetail];
            NSLog(@"itemsnotdone %@",itemsDone);
        }
        else{
            [itemsNotDone addObject:itmDetail];
        }
    }
    NSLog(@"array done %@",itemsDone);
    itemsArr=returnArray;
    count=[returnArray count];
    
    if (isAddBtnPressed) {
        count=count+1;
    }
    [table reloadData];
    return returnArray;
}

-(void)fuctionForRearangingiCloud
{
    [itemsDone removeAllObjects];
    [itemsNotDone removeAllObjects];
    for (int i=0; i<[itemsArr count]; i++) {
        itemDetail * itmDetail=[[itemDetail alloc]init];
        itmDetail=[itemsArr objectAtIndex:i];
        NSLog(@"status %@",itmDetail.itemName);
        NSLog(@"status %d",itmDetail.status);
        if (itmDetail.status) {
            
            [itemsDone addObject:itmDetail];
            NSLog(@"itemsnotdone %@",itemsDone);
        }
        else{
            [itemsNotDone addObject:itmDetail];
        }
        if (i==[itemsArr count]-1) {
            [loaderView removeFromSuperview];
        }
    }
    if ([itemsArr count]==0) {
        [loaderView removeFromSuperview];
    }
    count=[itemsArr count];
    if (isAddBtnPressed) {
        count=count+1;
    }
    
    [table reloadData];
    
}
#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     NSString * strFont=[NSString stringWithFormat:@"%@",fontName];
    if ([itemsArr count]==0&& (isAddBtnPressed==FALSE)) {
        static NSString * cellIdentifier1=@"cell1";
        UITableViewCell * cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        cell.textLabel.text=@"Pull down or press + button to add new item.";
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.font=[UIFont fontWithName:strFont size:13];
        
        return cell;
    }
    static NSString * cellIdentifier=@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView * cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
           cellView.backgroundColor=[UIColor grayColor];
        cellView.tag=lineViewTag;
        [cell.contentView addSubview:cellView];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 290,44)];
        cellLabel.tag=cellLabelTag;
        cellLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:cellLabel];
        
    }
   
    UIView *view =[cell.contentView viewWithTag:lineViewTag];
    CGSize  size;
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:cellLabelTag];
    
    
    NSLog(@"items count %d",[itemsNotDone count]);
    
  
        if (indexPath.row <[itemsNotDone count]) {
            
            itemDetail * itm=[[itemDetail alloc]init];
            itm=[itemsNotDone objectAtIndex:indexPath.row];
            NSLog(@"%@ ",itm.itemName);
            label.text=itm.itemName;
            label.textColor=[UIColor blackColor];
            view.frame=CGRectMake(0, 0, 0, 0);
           textfield.frame=CGRectMake(0, 0, 0,0);
            
           UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 25, 25)];
            btn.tag=indexPath.row;
            UIImage * img=[UIImage imageNamed:@"checkOn.png"];
            [btn setImage:img forState:UIControlStateNormal];
            [btn addTarget:self 
                    action:@selector(checkBtnAction:)
          forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:btn];  
        }
        else
        {
            itemDetail * itm=[[itemDetail alloc]init];
            int a = indexPath.row;
            NSLog(@"row %d",a);
            NSLog(@"count = %d",count);
            if (isAddBtnPressed) {
                if (indexPath.row== count-1) {
                    view.frame=CGRectMake(0, 0, 0, 0);
                    textfield.frame= CGRectMake(40, 10, 300, 44);
                    textfield.returnKeyType=UIReturnKeyDone;
                    [cell.contentView addSubview:textfield];
                    textfield.font=[UIFont fontWithName:strFont size:fontSize];
                    label.text=itm.itemName;
                    label.textColor=[UIColor blackColor];
                    [textfield becomeFirstResponder];
                    [textfield setPlaceholder:@"Add An Item."];
                    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 25, 25)];
                    btn.tag=indexPath.row;
                    UIImage * img=[UIImage imageNamed:@"checkOn.png"];
                    [btn setImage:img forState:UIControlStateNormal];
                    [btn addTarget:self 
                            action:@selector(checkBtnAction:)
                  forControlEvents:UIControlEventTouchDown];
                    [cell.contentView addSubview:btn];
                }  
                
            }
            else
            {
                if ([itemsDone count]>0) {
                    itm=[itemsDone objectAtIndex:indexPath.row-[itemsNotDone count]];
                    size=[itm.itemName sizeWithFont:[UIFont fontWithName:strFont size:fontSize]];
                    NSLog(@"width = %f",size.width);
                    
                    label.text=itm.itemName;
                    label.textColor=[UIColor grayColor];
                    NSLog(@"nameeeee %@",itm.itemName);
                    textfield.frame=CGRectMake(0, 0, 0, 0);
                    view.frame=CGRectMake(40,22,size.width, 1);
                    [cell.contentView bringSubviewToFront:view];
                    
                    UIButton *  btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 25, 25)];
                    btn.tag=indexPath.row;
                    UIImage * img=[UIImage imageNamed:@"checkOff.png"];
                    [btn setImage:img forState:UIControlStateNormal];
                    
                    [btn addTarget:self 
                            action:@selector(checkBtnAction:)
                  forControlEvents:UIControlEventTouchDown];
                    
                    [cell.contentView addSubview:btn];
                }
                
            }
        }
    isSwipe=FALSE;  
    NSLog(@"font  %@",strFont);
  label.font=[UIFont fontWithName:strFont size:fontSize];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{ 
    if (isSwipe==FALSE) {
        isSwipe=TRUE;
        return NO; 
    }
    else
    {  
        // isDeviceShaked=FALSE;
        int a;
        itemDetail * item;
        NSLog(@"row %d",indexPath.row);
        NSLog(@"notdone count  %d",[itemsNotDone count]);
        if ([itemsArr count]<=0) {
            return NO; 
        }
        if (indexPath.row>=[itemsNotDone count]) {
            if ([itemsDone count]>0) {
                a =indexPath.row-[itemsNotDone count];
                item=[[itemDetail alloc]init];
                item= [itemsDone objectAtIndex:a];
                a=item.itemId;
                
                ///////////////////////// FOR ICLOUD UPDATION===================
                if(appdelegate.isiCloud)
                {
                    NSString *fileName=fileName = [NSString stringWithFormat:@"%@,1",item.itemName];
                    NSLog(@"item name %@",item.itemName);
                    textfield.text=NULL;
                    // NSString *fileName = [NSString stringWithString:@"janbazali"];
                    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
                    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                                URLByAppendingPathComponent:fileName];
                    
                    NSURL* fileURL = ubiquitousPackage;
                    Note * note = [[Note alloc] initWithFileURL:ubiquitousPackage];
                    note.itemName=fileName;
                    note.status=1;
                    NSLog(@"path %@", fileURL);
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        NSError * error1=nil;
                        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                        [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                                              error:&error1 byAccessor:^(NSURL* writingURL) {
                                                                  NSError  *error =nil;
                                                                  NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                                  BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
                                                                  NSLog(@"%@",[error localizedDescription]);
                                                                  if (itemremoved) {
                                                                      NSLog(@"item deleted:(");
                                                                      [self updateItemiCloud:note];
                                                                  }
                                                                  if (!itemremoved) {
                                                                      NSLog(@"unable to revove item :(");
                                                                  }
                                                              }];
                        NSLog(@"%@",[error1 localizedDescription]);
                    });
                }
                //===================== ICLOUD UPDATION END=========================
                
                
                
                NSString *SqlStr = [NSString stringWithFormat:@"update items set status = %d where itemsid = %d;",0,a]; 
                NSLog(@"udate query %@",SqlStr);
                BOOL ReturnStatement = [appdelegate InsUpdateDelData:SqlStr];
                
                if (ReturnStatement)
                {
                    if(!appdelegate.isiCloud)
                    {
                        [self getAvailabelItems];
                        [table reloadData];
                        NSLog(@"status set");
                    }
                }
            }
            
            return NO;
        }
        else
        {
            if (indexPath.row<[itemsNotDone count]) {
                a =indexPath.row;
                NSLog(@"a= %d",a);
                item=[[itemDetail alloc]init];
                item= [itemsNotDone objectAtIndex:a];
                a=item.itemId;
                
            }
            else if([itemsNotDone count]>0)
            {
                a=indexPath.row-[itemsNotDone count];
                NSLog(@"a= %d",a);
                item=[[itemDetail alloc]init];
                item= [itemsNotDone objectAtIndex:a];
                a=item.itemId;
            }
            //============================== icloud updation===============
            if(appdelegate.isiCloud)
            {
                NSString *fileName=fileName = [NSString stringWithFormat:@"%@,0",item.itemName];
                NSLog(@"item name %@",item.itemName);
                textfield.text=NULL;
                // NSString *fileName = [NSString stringWithString:@"janbazali"];
                NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
                NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                            URLByAppendingPathComponent:fileName];
                
                NSURL* fileURL = ubiquitousPackage;
                Note * note = [[Note alloc] initWithFileURL:ubiquitousPackage];
                note.itemName=fileName;
                note.status=1;
                NSLog(@"path %@", fileURL);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    NSError * error1=nil;
                    NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                    [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                                          error:&error1 byAccessor:^(NSURL* writingURL) {
                                                              NSError  *error =nil;
                                                              NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                              BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
                                                              NSLog(@"%@",[error localizedDescription]);
                                                              if (itemremoved) {
                                                                  NSLog(@"item deleted:(");
                                                                  [self updateItemiCloud:note];
                                                              }
                                                              if (!itemremoved) {
                                                                  NSLog(@"unable to revove item :(");
                                                              }
                                                          }];
                    NSLog(@"%@",[error1 localizedDescription]);
                });
            }
            //========================================================================
            
            NSString *SqlStr = [NSString stringWithFormat:@"update items set status = %d where itemsid = %d;",1,a]; 
            NSLog(@"udate query %@",SqlStr);
            BOOL ReturnStatement = [appdelegate InsUpdateDelData:SqlStr];
            
            if (ReturnStatement)
            {
                if(!appdelegate.isiCloud)
                {
                    [self getAvailabelItems];
                    [table reloadData];
                    NSLog(@"status set");
                }
            }
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([itemsArr count]==0) {
        return 1;
    }
    return count;
}

#pragma mark - button Action

- (IBAction)settingsBtnAction:(id)sender {
    //isDeviceShaked=FALSE;
    settingView = [[settingsView alloc]initWithNibName:@"settingsView" bundle:[NSBundle mainBundle]]; //  [self.view addSubview:settingView.vieS];
    [self presentModalViewController:settingView animated:YES];
}
- (IBAction)addItemtoDb:(id)sender {
    if ([itemsArr count]>=2) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([itemsArr count]-2) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    isAddBtnPressed=1;
    textfield.enabled=TRUE;
    count=[itemsArr count];
    if (isAddBtnPressed) {//////////// uncoment for icloud...
        count=count+1;
    }
    [table reloadData];
}

- (IBAction)clearRows:(id)sender {
    //isDeviceShaked=FALSE;
    
  
    
    
    //============== ICLOUD CLEAR ITEMS==================
    if(appdelegate.isiCloud)
    {
       __block int counter=0;
    for (int i=0; i<[itemsDone count]; i++) {
        itemDetail * item;
        item=[[itemDetail alloc]init];
        item= [itemsDone objectAtIndex:i];

        NSString *fileName=fileName = [NSString stringWithFormat:@"%@,1",item.itemName];
        NSLog(@"item name %@",item.itemName);
        textfield.text=NULL;
        // NSString *fileName = [NSString stringWithString:@"janbazali"];
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                    URLByAppendingPathComponent:fileName];
        
        NSURL* fileURL = ubiquitousPackage;
        Note * note = [[Note alloc] initWithFileURL:ubiquitousPackage];
        note.itemName=item.itemName;
        note.status=1;
        NSLog(@"path %@", fileURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSError * error1=nil;
            NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                                  error:&error1 byAccessor:^(NSURL* writingURL) {
                                                      NSError  *error =nil;
                                                      NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                      BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
                                                      NSLog(@"%@",[error localizedDescription]);
                                                      if (itemremoved) {
//                                                          counter++;
//                                                          
//                                                          if (counter==[itemsDone count]) {
//                                                              UIAlertView * aler=[[UIAlertView alloc] initWithTitle:@"" message:@"Cleared successfully!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                                                              [aler show];
//                                                              counter=0;
//                                                          }  
                                                      }
                                                      if (!itemremoved) {
                                                          NSLog(@"unable to revove item :(");
                                                      }
                                                  }];
            NSLog(@"%@",[error1 localizedDescription]);
        });
    }
    }
 ////////////////// ICLOUD CLEAR ITEMS END=============================   
    
    
    NSString *SqlStr = [NSString stringWithFormat:@"delete from items where status = %d;",1];
	BOOL ReturnStatement1 = [appdelegate InsUpdateDelData:SqlStr];
    NSLog(@"%@",SqlStr);
    if (ReturnStatement1) {
        NSLog(@"deleted ");
        
        if ([itemsDone count]>0) {
            UIAlertView * ScreenAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cleared successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [ScreenAlert show]; 
            
            if(!appdelegate.isiCloud)
            {
                [self getAvailabelItems];
                [table reloadData];
            }
        }
        else
        {
            
            UIAlertView * ScreenAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Item selected!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [ScreenAlert show]; 
            
        }
        
    }  
}


-(void)checkBtnAction:(id)sender
{
    UIButton * btn=sender;
    int a;
    itemDetail * item;
    NSLog(@"row %d",btn.tag);
    NSLog(@"notdone count  %d",[itemsNotDone count]);
    if ([itemsArr count]<=0) {
        
    }
    else
    {
        if (btn.tag>=[itemsNotDone count]) {
            if ([itemsDone count]>0) {
                a =btn.tag-[itemsNotDone count];
                item=[[itemDetail alloc]init];
                item= [itemsDone objectAtIndex:a];
                a=item.itemId;
                
                ///////////////////////// FOR ICLOUD UPDATION===================
                if(appdelegate.isiCloud)
                {
                NSString *fileName=fileName = [NSString stringWithFormat:@"%@,1",item.itemName];
                NSLog(@"item name %@",item.itemName);
                textfield.text=NULL;
                // NSString *fileName = [NSString stringWithString:@"janbazali"];
                NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
                NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                            URLByAppendingPathComponent:fileName];
                
                NSURL* fileURL = ubiquitousPackage;
                Note * note = [[Note alloc] initWithFileURL:ubiquitousPackage];
                note.itemName=fileName;
                note.status=1;
                NSLog(@"path %@", fileURL);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    NSError * error1=nil;
                    NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                    [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                                          error:&error1 byAccessor:^(NSURL* writingURL) {
                                                              NSError  *error =nil;
                                                              NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                              BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
                                                              NSLog(@"%@",[error localizedDescription]);
                                                              if (itemremoved) {
                                                                  NSLog(@"item deleted:(");
                                                                  [self updateItemiCloud:note];
                                                              }
                                                              if (!itemremoved) {
                                                                  NSLog(@"unable to revove item :(");
                                                              }
                                                          }];
                    NSLog(@"%@",[error1 localizedDescription]);
                });
                }
               //===================== ICLOUD UPDATION END========================= 
             
                
                NSString *SqlStr = [NSString stringWithFormat:@"update items set status = %d where itemsid = %d;",0,a]; 
                NSLog(@"udate query %@",SqlStr);
                BOOL ReturnStatement = [appdelegate InsUpdateDelData:SqlStr];
                
                if (ReturnStatement)
                {
                    if(!appdelegate.isiCloud)
                    {
                        [self getAvailabelItems];
                        [table reloadData];
                        NSLog(@"status set");
                    }
                }
            }
            
        }
        else
        {
            if (btn.tag<[itemsNotDone count]) {
                a =btn.tag;
                NSLog(@"a= %d",a);
                item=[[itemDetail alloc]init];
                item= [itemsNotDone objectAtIndex:a];
                a=item.itemId;
               // BOOL checkStatus= item.status;
                //============================== icloud updation===============
                if(appdelegate.isiCloud)
                {
                NSString *fileName=fileName = [NSString stringWithFormat:@"%@,0",item.itemName];
                NSLog(@"item name %@",item.itemName);
                textfield.text=NULL;
                // NSString *fileName = [NSString stringWithString:@"janbazali"];
                NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
                NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                            URLByAppendingPathComponent:fileName];
               
                NSURL* fileURL = ubiquitousPackage;
                Note * note = [[Note alloc] initWithFileURL:ubiquitousPackage];
                note.itemName=fileName;
                note.status=1;
                 NSLog(@"path %@", fileURL);

                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                            NSError * error1=nil;
                            NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                            [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                                                  error:&error1 byAccessor:^(NSURL* writingURL) {
                                                                      NSError  *error =nil;
                                                                      NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                                     BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
                                                                      NSLog(@"%@",[error localizedDescription]);
                                                                      if (itemremoved) {
                                                                          NSLog(@"item deleted:(");
                                                                          [self updateItemiCloud:note];
                                                                      }
                                                                      if (!itemremoved) {
                                                                          NSLog(@"unable to revove item :(");
                                                                      }
                                                                  }];
                            NSLog(@"%@",[error1 localizedDescription]);
                        });
                }
//========================================================================
                
            }
            else if([itemsNotDone count]>0)
            {
                a=btn.tag-[itemsNotDone count];
                NSLog(@"a= %d",a);
                item=[[itemDetail alloc]init];
                item= [itemsNotDone objectAtIndex:a];
                a=item.itemId;
            }
            NSString *SqlStr = [NSString stringWithFormat:@"update items set status = %d where itemsid = %d;",1,a]; 
            NSLog(@"udate query %@",SqlStr);
            BOOL ReturnStatement = [appdelegate InsUpdateDelData:SqlStr];
            
            if (ReturnStatement)
            {
                if(!appdelegate.isiCloud)
                {
                    [self getAvailabelItems];
                    [table reloadData];
                    NSLog(@"status set");
                }
            }
        }  
    }  
}



#pragma mark -  Delegate Methods textfield & scroll view


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([[textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] ==0)
    {
        isAddBtnPressed=FALSE;
        count=[itemsArr count];
        [table reloadData];
        return 0;
    }
    else
    {
        isAddBtnPressed=FALSE;
        NSLog(@"%@",textfield.text);
        NSString *SqlStr = [NSString stringWithFormat:@"INSERT into items (itemName,status) values ('%@',%d);",textfield.text,0];
        BOOL ReturnStatement = [appdelegate InsUpdateDelData:SqlStr];
        if (ReturnStatement) {
            NSLog(@"inserted  ");
            textfield.enabled=FALSE;
            itemDetail * item =[[itemDetail alloc]init];
            item.itemName=textField.text;
            NSLog(@"%@",item.itemName);
            item.status=0;
            [itemsNotDone addObject:item];
            NSLog(@"items not done %@",itemsNotDone);
            if(!appdelegate.isiCloud)
            {
                textField.text=NULL;////////// remove for iclouds
                [self getAvailabelItems];
                [table reloadData];
            }
            if(appdelegate.isiCloud)
            {
                [self addNote];
            }
        }
    } 
    return YES;
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (appdelegate.isShakeToClear) {
        if ([itemsDone count]>0) {
             [self clearRows:nil];
//            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Device Shaked" message:@"Do you want to clear item?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
//            [alert show];
            
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"There are no completed items to clear." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Device Shaked" message:@"Switch ON 'shake to clear' in settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
   
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (appdelegate.isiCloud) {
        [self loadNotes];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-70) {
       // if ([itemsArr count]==0) {
            [self addItemtoDb:nil];
       // }
    }
}
#pragma mark - Extra

- (void)viewDidUnload{
    [self setTable:nil];
    addBtn = nil;
    clearBtn = nil;
    bottomLine = nil;
    loaderView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)reloadData
{
//    [self performSelector:@selector(loadNotes) withObject:nil afterDelay:0.5];
    [self performSelectorOnMainThread:@selector(loadNotes) withObject:nil waitUntilDone:NO];
}

#pragma mark - icloud
-(void)updateItemiCloud:(Note *)item
{
    
    NSString *Name = [NSString stringWithFormat:@"%@",item.itemName];
    NSArray * arr=[[NSArray alloc]init];
    arr=[Name componentsSeparatedByString:@","];
    NSString *fileName;
    int a=[[arr objectAtIndex:1] intValue];
    if (a==1) {
        fileName = [NSString stringWithFormat:@"%@,0",[arr objectAtIndex:0]];
    }
    else if (a==0) {
        fileName = [NSString stringWithFormat:@"%@,1",[arr objectAtIndex:0]];
    }
   
    textfield.text=NULL;
    // NSString *fileName = [NSString stringWithString:@"janbazali"];
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                URLByAppendingPathComponent:fileName];
    NSLog(@"path updating: %@",ubiquitousPackage);
    Note *doc = [[Note alloc] initWithFileURL:ubiquitousPackage];
    doc.itemName=fileName;
   
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (success) {
            [doc closeWithCompletionHandler:^(BOOL success){
                if(success)
                    NSLog(@"close");
                else
                    NSLog(@"not closed");
            }];
            [self performSelectorOnMainThread:@selector(loadNotes) withObject:nil waitUntilDone:NO];
            //[self loadNotes];
//           [self performSelector:@selector(loadNotes) withObject:nil afterDelay:4.0];
            // [self.view addSubview:loaderView];  
        }
    }];
}

- (void)addNote {
    
   NSString *fileName = [NSString stringWithFormat:@"%@,0",textfield.text];
    textfield.text=NULL;
   // NSString *fileName = [NSString stringWithString:@"janbazali"];
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
                                URLByAppendingPathComponent:fileName];
    
    Note *doc = [[Note alloc] initWithFileURL:ubiquitousPackage];
    NSLog(@"path adding: %@",ubiquitousPackage);
    doc.itemName=fileName;
  
    NSLog(@"status %d",doc.status);
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (success) {
            [doc closeWithCompletionHandler:^(BOOL success){
                if(success)
                    NSLog(@"close");
                else
                    NSLog(@"not closed");
            }];
            [self loadNotes];
            
            //[self.notes addObject:doc];
            ///[self.tableView reloadData]; reload you tableeeeeee......
            
        }  
    }];
}


- (void)loadNotes {
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    if (ubiq) {
        if (self.query) {
            self.query=nil;
        }
        self.query = [[NSMetadataQuery alloc] init];
        [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        NSPredicate *pred = [NSPredicate predicateWithFormat: @"%K like '*'", NSMetadataItemFSNameKey];
        [self.query setPredicate:pred];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(queryDidFinishGathering:) 
                                                     name:NSMetadataQueryDidFinishGatheringNotification 
                                                   object:self.query];
        
        [self.query startQuery];
        
    } else {
       
        NSLog(@"No iCloud access");
        
    }
    
}
- (void)loadData:(NSMetadataQuery *)query1 {
    
    [self.notes removeAllObjects];
    [itemsArr removeAllObjects];
    if ([[query1 results] count]==0) {
        [loaderView removeFromSuperview];
        [table reloadData];
    }
    __block int index = 0;
    
    for (NSMetadataItem *item in [query1 results]) {
        
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc] initWithFileURL:url];
        
        [doc openWithCompletionHandler:^(BOOL success) {
            index++;
            if (success) {

               // [doc enableEditing];
                
                [self.notes addObject:doc];
                NSLog(@"notes %@",notes);
                NSString * str=[NSString stringWithFormat:doc.itemName];
                NSArray * arr=[[NSArray alloc]init];
                arr=[str componentsSeparatedByString:@","];
                
                itemDetail * item=[[itemDetail alloc]init];
                item.itemName=[arr objectAtIndex:0];
                int sta=[[arr objectAtIndex:1] intValue];
                item.status=sta;
                
//                itemDetail * item=[[itemDetail alloc]init];
//                item.itemName=doc.itemName;
                
                [itemsArr addObject:item];
                NSLog(@"array %@",itemsArr);
                [doc closeWithCompletionHandler:^(BOOL success){
                    if(success)
                        NSLog(@"close");
                    else
                        NSLog(@"not closed");
                }];
            } 
            
            else {
                NSLog(@"failed to open from iCloud");
            }
            
            if(index == [[query1 results] count])
                [self fuctionForRearangingiCloud]; 
            
        }]
      ;  
    }
    NSLog(@"after for looop");
    
} 
- (void)queryDidFinishGathering:(NSNotification *)notification {
    
    NSMetadataQuery *query2 = [notification object];
    [query2 disableUpdates];
    [query2 stopQuery];
    
    [self loadData:query2];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query2];
    
    self.query = nil;
    
} 

@end
