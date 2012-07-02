//
//  AppDelegate.m
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "ViewController.h"
#define TESTING 1
@implementation AppDelegate

@synthesize window = _window;
sqlite3 *database=nil;

@synthesize viewController = _viewController;
@synthesize mainView,isShakeToClear,isiCloud,isiCloudConfigured;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"271a6e9b4e6695313f97bfd68f8e6884_ODc5NzIyMDEyLTA1LTE0IDE0OjAyOjI0LjgzOTM3MQ"];

#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
//    InAppPurchaseManager *inAppPurchase = [InAppPurchaseManager sharedInstance];
//    [inAppPurchase purchaseProduct];
    NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setBool:TRUE forKey:isFirstTime];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    ///// to check the configuration of icloud =============
    NSURL *ubiq = [[NSFileManager defaultManager] 
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"running" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [alert show];
        NSLog(@"iCloud access at %@", ubiq);
        isiCloudConfigured=YES;
        // TODO: Load document... 
    } else {
        isiCloudConfigured=NO;
        isiCloud=NO;
        NSLog(@"No iCloud access");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"iCloud Error" message:@"Check whether iCloud is configured in you device?" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    ///////===========================
    [self copyDatabaseIfNeeded];
    [self genrateDB];
    [self checkAndCreateDatabase];
    [Crashlytics startWithAPIKey:@"1a2cad58c7886509368013aa0a5c9bfaa08ce5d1"];
    application.applicationSupportsShakeToEdit=YES;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
//    NSString *fileName = [NSString stringWithFormat:@"%@",@"Aasd,1"];
//    // NSString *fileName = [NSString stringWithString:@"janbazali"];
//    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] 
//                                URLByAppendingPathComponent:fileName];
//    
//    NSURL* fileURL = ubiquitousPackage;
//    NSLog(@"path %@", fileURL);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSError * error1=nil;
//        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
//        [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
//                                              error:&error1 byAccessor:^(NSURL* writingURL) {
//                                                  NSError  *error =nil;
//                                                  NSFileManager* fileManager = [[NSFileManager alloc] init];
//                                                  BOOL itemremoved = [fileManager removeItemAtURL:writingURL error:&error];
//                                                  NSLog(@"%@",[error localizedDescription]);
//                                                  if (itemremoved) {
//                                                      NSLog(@"item deleted:(");
//                                                  }
//                                                  if (!itemremoved) {
//                                                      NSLog(@"unable to revove item :(");
//                                                  }
//                                              }];
//        NSLog(@"%@",[error1 localizedDescription]);
//    });
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//=================== database===================

- (void)checkAndCreateDatabase
{
    //Check if the SQL database is available on the Iphone, if not the copy it over
    BOOL the_bSuccess;
    m_pDatabaseName = @"basket.sqlite";
	
    //Get the path to documents directory and append the database name
    NSArray *the_pDocumentPaths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *the_pDocumentsDir2 = [the_pDocumentPaths2 objectAtIndex:0];
    m_pDatabasePath = [the_pDocumentsDir2 stringByAppendingPathComponent:m_pDatabaseName];
	//[Street_vendorCommons setDataBasePath:m_pDatabasePath];
	//[MypetBlobCommos setdatabasepath:m_pDatabaseName];
    //Crete filemaker object and we will use to check if the database is available on the user’s iPhone, if not the copy it over
    NSFileManager *the_pFileManager = [NSFileManager defaultManager];
	
    //Check if the database is already exists in the user’s filesystem i.e documents directory of the application
	
    the_bSuccess = [the_pFileManager fileExistsAtPath:m_pDatabasePath];
	
    //If database is already exist then return without doing anything
    if(the_bSuccess) return;
	
    //If not then proceed to copy the database from the application to user’s filesystem
    //Get the path to the database in the application package
    NSString *the_pDatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"StreetVendorTycoon.sql"];
	
    //Copy the database from the package to the user’s filesystem
    //    NSData *strte=[NSData  dataWithContentsOfFile:@"Icon.png"];
    [the_pFileManager copyItemAtPath:the_pDatabasePathFromApp toPath:m_pDatabasePath error:nil];
}

- (void) copyDatabaseIfNeeded {
	
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
	
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"basket.sqlite"];       
        //        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AnwaltTestDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }   
}
- (void) genrateDB
{
	
    NSString *dbFilePath = [self getDBPath];
    NSLog(@"%@",dbFilePath);
    if(sqlite3_open([dbFilePath UTF8String],&database) == SQLITE_OK)
    {
        NSLog(@"CONNECTION SUCCESSFUL\n\n");
    }
    else
    {
        NSLog(@"CONNECTION FAILURE");
    }
	
}

- (NSString *) getDBPath {
	
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //NSLog(@"%@",documentsDir);
    //    return [documentsDir stringByAppendingPathComponent:@"AnwaltTestDB.sqlite"];
    return [documentsDir stringByAppendingPathComponent:@"basket.sqlite"];
}

- (NSString *) getDBPathForSql {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"basket.sqlite"];
}

- (sqlite3_stmt *) getStatement:(NSString *) SQLStrValue
{
    if([SQLStrValue isEqualToString:@""])
        return NO;

    sqlite3_stmt * OperationStatement;
    sqlite3_stmt * ReturnStatement = nil;
	
	
    const char *sql = [SQLStrValue cStringUsingEncoding: NSUTF8StringEncoding];
	
    if (sqlite3_prepare_v2(database, sql, -1, &OperationStatement, NULL) == SQLITE_OK)
    {   
        ReturnStatement = OperationStatement;
    }
    return ReturnStatement;
}

-(BOOL)InsUpdateDelData:(NSString*)SqlStr
{
    if([SqlStr isEqual:@""])
        return NO;
	
    BOOL RetrunValue;
    RetrunValue = NO;
    const char *sql = [SqlStr cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK)
    {   
        RetrunValue = YES;
    }
	
    if(RetrunValue == YES)
    {
        if(sqlite3_step(stmt) != SQLITE_DONE)
            NSLog(@"This should be real error checking!");
        sqlite3_finalize(stmt);
    }
    return RetrunValue;
}

@end
