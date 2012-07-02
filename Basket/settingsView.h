//
//  settingsView.h
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface settingsView : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,MFMailComposeViewControllerDelegate>
{
    AppDelegate * appdelegate;
    NSMutableArray *fontName;
    NSMutableArray *fontType;
    NSMutableArray *fontSize;
    NSString * fontN;
    NSString * fontT;
    int fontS;
    ViewController * itemD;
    
    IBOutlet UISwitch *shakeSwitch;
    IBOutlet UIButton *btnRemoveAd;
    IBOutlet UIView *loadingView;
    IBOutlet UISwitch *icloudSwitch;
    IBOutlet UIView *removeAidsView;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)buttoncliked:(id)sender;
- (IBAction)shaketoClearSwitchAction:(id)sender;
- (IBAction)icloudSwitchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *purcahseBtnAction;
- (IBAction)purchaseBtnAction:(id)sender;
- (IBAction)restoreBtnAction:(id)sender;
- (IBAction)cancelRemoveAidsBtnAction:(id)sender;

- (IBAction)rateBtnAction:(id)sender;
- (IBAction)removeAdsBtnAction:(id)sender;
- (IBAction)openMail:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end
