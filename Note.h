//
//  Note.h
//  Basket
//
//  Created by Mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : UIDocument
{
}
@property (nonatomic, retain) NSString * itemName;
@property BOOL status;
@end
