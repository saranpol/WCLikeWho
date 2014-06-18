//
//  API.m
//  Hormones-iOS
//
//  Created by HLPTH-MACMINI2 on 6/12/2557 BE.
//  Copyright (c) 2557 HLP. All rights reserved.
//

#import "API.h"

static API *instance;

@implementation API

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

@end
