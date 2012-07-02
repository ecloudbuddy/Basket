//
//  ViewController.h
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "settingsView.h"
#import "Note.h"
#import <iAd/iAD.h>

@class itemDetail;
@class settingsView;
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,ADBannerViewDelegate>
{
    BOOL isAddBtnPressed;
    settingsView * settingView;
    AppDelegate *appdelegate;
    NSMutableArray *itemsArr;
    NSMutableArray *itemsNotDone;
    NSMutableArray *itemsDone;
    BOOL isSwipe;
    UIAlertView * alertForItemName;
    UITextField * itemName;
    NSString * fontName;
    NSString * fontType;
    int fontSize;
    BOOL isDeviceShaked;
    int count;
    UITextField * textfield;
    BOOL isAlertShown;
    
    IBOutlet UIView *loaderView;
    IBOutlet UIView *bottomLine;
    IBOutlet UIButton *clearBtn;
    IBOutlet UIButton *addBtn;
    ADBannerView *adView;
    BOOL bannerIsVisible;
    int tapCount;
    NSIndexPath *tableSelection;
    BOOL isEdidMode;
}
@property (strong, nonatomic) IBOutlet UIView *loaderView;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet NSString * fontName;
@property (nonatomic, retain) IBOutlet NSString * fontType;
@property int fontSize;
@property (strong) NSMutableArray * notes;
@property (strong) NSMetadataQuery *query;

-(NSMutableArray *)getAvailabelItems;
- (IBAction)settingsBtnAction:(id)sender;
- (IBAction)addItemtoDb:(id)sender;
- (IBAction)clearRows:(id)sender;
-(void)checkBtnAction:(id)sender;
- (void)loadNotes;
- (void)addNote ;
- (void)loadData:(NSMetadataQuery *)query1;
-(void)fuctionForRearangingiCloud;
-(void)updateItemiCloud:(Note *)item;

@end
