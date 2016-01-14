//
//  API.m
//  Hormones-iOS
//
//  Created by HLPTH-MACMINI2 on 6/12/2557 BE.
//  Copyright (c) 2557 HLP. All rights reserved.
//

#import "API.h"
#import "AFNetworking.h"

static API *instance;

@implementation API
@synthesize mRequest;
@synthesize mData;
@synthesize mUserImage;
- (instancetype)init
{
    self = [super init];
    if (self) {
        // init
    }
    return self;
}

+(API*)getAPI {
    if (!instance)
        instance = [API new];
    return instance;
}

- (void)saveDictDataForKey:(id)key data:(NSDictionary*)data {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *save_data = [NSKeyedArchiver archivedDataWithRootObject:data];
	[prefs setObject:save_data forKey:key];
	[prefs setObject:[NSDate date] forKey:[key stringByAppendingString:@"Date"]];
	[prefs synchronize];
}


- (NSDictionary*)loadDictDataForKey:(id)key {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *save_data = [prefs objectForKey:key];
	if (save_data){
		NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:save_data];
		return data;
	}
	return nil;
}

- (void)gotStar {
    NSDate *now = [NSDate date];
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    [saveDict setObject:now forKey:@"date"];
    [self saveDictDataForKey:kGotStar data:saveDict];
}


#define kFiftyMin 15
#define kTimeForNextClick kFiftyMin * 60

- (BOOL)isTimeToCanClick {
    NSDictionary *lastGotStarDateDict = [self loadDictDataForKey:kGotStar];
    if (lastGotStarDateDict) {
        NSDate *lastGotStarDate = [lastGotStarDateDict objectForKey:@"date"];
        NSDate *now = [NSDate date];
        NSTimeInterval diff = [now timeIntervalSinceDate:lastGotStarDate];
        if (diff < kTimeForNextClick)
            return NO;
        
    }
    
	return YES;
}

- (int)canClickTimeRemaining {
    NSDictionary *lastGotStarDateDict = [self loadDictDataForKey:kGotStar];
    NSDate *lastGotStarDate = [lastGotStarDateDict objectForKey:@"date"];
    NSDate *datePlusFiftyMinute = [lastGotStarDate dateByAddingTimeInterval:kTimeForNextClick];
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [datePlusFiftyMinute timeIntervalSinceDate:now];
    return (diff / 60) + 1;
}




- (void)requestStarSilentlyWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    if (mData) {
        if (success)
            success(nil, mData);
    } else {
        if (mRequest) {
            [[mRequest operationQueue] cancelAllOperations];
            mRequest = nil;
        }
        self.mRequest = [AFHTTPRequestOperationManager manager];
        [mRequest GET:@"http://world-cup-brazil.appspot.com/get_star" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            mData = (NSDictionary*)responseObject;
            if (success)
                success(nil, mData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure)
                failure(operation, error);
        }];
    }
}



@end
