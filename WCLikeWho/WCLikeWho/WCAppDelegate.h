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


@protocol FacebookLoginDelegate <NSObject>
@optional
- (void)facebookLoginSuccess:(FBSession*)session;
- (void)facebookLoginFail:(FBSession*)session errors:(NSError*)errors;
@end


@interface WCAppDelegate : UIResponder <UIApplicationDelegate> {
@public
    
}

+ (WCAppDelegate *)core;
+ (WCViewController *)vc;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WCViewController *viewController;

@property (strong, nonatomic) id<FacebookLoginDelegate> mDelegate;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
