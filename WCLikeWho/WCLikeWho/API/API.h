//
//  API.h
//  Hormones-iOS
//
//  Created by HLPTH-MACMINI2 on 6/12/2557 BE.
//  Copyright (c) 2557 HLP. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGotStar @"kGotStar"

#define kSampleAdUnitID @"ca-app-pub-6262014690363579/4900978847"
#define kSampleAdUnitIDInterstitial @"ca-app-pub-6262014690363579/4924170040"

// Social
#define FB_APP_ID @"909180682428928"
#define FB_SECRETP_ID @"467ba99e49d9d7fe05770ffb3f62740d"


// Fonts
#define FONT_1 @"ContextRepriseLightSSiLight"
#define FONT_0 @"ContextRepriseLightSSiExtraLight"

enum tagname {
    USER_IS_MALE,
    USER_IS_FEMALE,
};

@class AFHTTPRequestOperation;
@class AFHTTPRequestOperationManager;

@interface API : NSObject {
@public
    //int mUserGender;
}

+(API*)getAPI;

@property (nonatomic) int mUserGender;

@property (nonatomic, strong) AFHTTPRequestOperationManager *mRequest;
@property (nonatomic, strong) NSDictionary *mData;
@property (nonatomic, strong) UIImage *mUserImage;

- (void)saveDictDataForKey:(id)key data:(NSDictionary*)data;
- (NSDictionary*)loadDictDataForKey:(id)key;
- (BOOL)isTimeToCanClick;
- (void)gotStar;
- (int)canClickTimeRemaining;

- (void)requestStarSilentlyWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
