//
//  AirAPI.m
//  Listings
//
//  Created by Himal Sherchan on 8/16/16.
//  Copyright © 2016 Himal Sherchan. All rights reserved.
//

#import "AirAPI.h"

#define CLIENTKEY      @"3092nxybyb0otqw18e8nh5nty"
#define USER_LAT       @"37.773972"
#define USER_LONG      @"-122.431297"
#define CITY           @"San Francisco, CA, US"

@interface AirAPI ()


@end

@implementation AirAPI

- (id)init{
    self = [super init];
    
    if (self)
    {
        [self configureRestKit];
    }
    
    return self;
}

+ (AirAPI*)sharedInstance{
    static AirAPI *_sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AirAPI alloc] init];
    });
    
    
    return _sharedInstance;
}

- (void)configureRestKit{
    
    // Create a baseURL
    NSURL *baseURL = [NSURL URLWithString:@"https://api.airbnb.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Create object mapping for listing
    RKObjectMapping *listingMapping = [RKObjectMapping mappingForClass:[Listings class]];
    [listingMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"room_type": @"roomType",
                                                         @"neighborhood": @"neighborhood"
                                                         }];
    
    // Create object mapping for search results
    RKObjectMapping *searchResultsMapping = [RKObjectMapping mappingForClass:[SearchResult class]];
    
    //Add nested properties
    [searchResultsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"listing"
                                                                                         toKeyPath:@"listing"
                                                                                       withMapping:listingMapping]];
    
    
    // Register object mapping to the response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:searchResultsMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/v2/search_results"
                                                                                           keyPath:@"search_results"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)getListing:(void (^)(NSArray *listings, NSError *error))finishBlock {
    
    //Describe the query parameters
    NSDictionary *queryParams = @{@"client_id" : CLIENTKEY,
                                  @"location"  : CITY,
                                  @"user_lat"  : USER_LAT,
                                  @"user_lng"  : USER_LONG};
    
    //Call the object manager with the appropriate parameters
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/search_results"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                    if (finishBlock)
                                                        {
                                                            finishBlock(mappingResult.array, nil);
                                                        }
                                                  
                                               }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                    if (finishBlock)
                                                        {
                                                          finishBlock(nil, error);
                                                        }
                                                   }];
}
@end
