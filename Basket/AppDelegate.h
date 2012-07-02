//
//  AppDelegate.h
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

#import "InAppPurchaseManager.h"

#define isAdRemoved @"isAdRemoved"
#define shaketoClear @"shakeToClear"
#define iCoudState @"iCloudState"
#define isFirstTime @"isfirsttime"
#define fontname @"fontname"
#define fontsize @"fontsize"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *m_pDatabaseName,*m_pDatabasePath;
    ViewController * mainView;
    BOOL isShakeToClear;
    BOOL isiCloud;
    BOOL isiCloudConfigured;
}

@property (strong, nonatomic) UIWindow *window;
@property BOOL isShakeToClear; 
@property BOOL isiCloud;
@property BOOL isiCloudConfigured;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) ViewController * mainView;



- (void)checkAndCreateDatabase;
- (void) copyDatabaseIfNeeded;
- (void) genrateDB;
- (NSString *) getDBPath ;
- (sqlite3_stmt *) getStatement:(NSString *) SQLStrValue;
-(BOOL)InsUpdateDelData:(NSString*)SqlStr;
@end
