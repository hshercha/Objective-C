//
//  AirAPI.h
//  Listings
//
//  Created by Himal Sherchan on 8/16/16.
//  Copyright © 2016 Himal Sherchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Listings.h"
#import "SearchResult.h"

@interface AirAPI : NSObject

+ (AirAPI*)sharedInstance;
- (void)getListing:(void (^)(NSArray *values, NSError *error))finishBlock;

@end
