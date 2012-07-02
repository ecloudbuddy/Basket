//
//  Note.m
//  Basket
//
//  Created by Mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@implementation Note
@synthesize itemName, status;

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([contents length] > 0) {
        self.itemName = [[NSString alloc] initWithBytes:[contents bytes] 
                                                    length:[contents length] 
                                                  encoding:NSUTF8StringEncoding];
        
    } else {
        self.itemName = @"Empty"; // When the note is created we assign some default content
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" 
                                                        object:self];        
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError 
{
    
    if ([self.itemName length] == 0) {
        self.itemName = @"Empty";
    }
    
    return [NSData dataWithBytes:[self.itemName UTF8String] 
                          length:[self.itemName length]];
    
}

@end
