//
//  WCAppDelegate.h
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class WCViewController;

@interface WCAppDelegate : UIResponder <UIApplicationDelegate> {
@public
    
}

+ (WCAppDelegate *)core;
+ (WCViewController *)vc;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WCViewController *viewController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
