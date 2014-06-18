//
//  API.h
//  Hormones-iOS
//
//  Created by HLPTH-MACMINI2 on 6/12/2557 BE.
//  Copyright (c) 2557 HLP. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGotStar @"kGotStar"

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
