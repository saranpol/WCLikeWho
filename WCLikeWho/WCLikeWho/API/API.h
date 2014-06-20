//
//  API.h
//  Hormones-iOS
//
//  Created by HLPTH-MACMINI2 on 6/12/2557 BE.
//  Copyright (c) 2557 HLP. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGotStar @"kGotStar"

#define kSampleAdUnitID @"ca-app-pub-6262014690363579/1499004043"


// Social
#define FB_APP_ID @"909180682428928"
#define FB_SECRETP_ID @"467ba99e49d9d7fe05770ffb3f62740d"


// Fonts
#define FONT_1 @"ContextRepriseLightSSiLight"
#define FONT_0 @"ContextRepriseLightSSiExtraLight"

@interface API : NSObject {
@public
}

+(API*)getAPI;

- (void)saveDictDataForKey:(id)key data:(NSDictionary*)data;
- (NSDictionary*)loadDictDataForKey:(id)key;
- (BOOL)isTimeToCanClick;
- (void)gotStar;
- (int)canClickTimeRemaining;

@end
