//
//  itemDetail.h
//  Basket
//
//  Created by Mac on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface itemDetail : NSObject
{
    int itemId;
    NSString * itemName;
    NSDate * date;
    BOOL  status;
    BOOL sync_iCloud;
}
@property int itemId;
@property(nonatomic , retain) NSString * itemName;
@property BOOL status;
@property BOOL sync_iCloud;
@property(copy, nonatomic) NSDate *date;

@end
