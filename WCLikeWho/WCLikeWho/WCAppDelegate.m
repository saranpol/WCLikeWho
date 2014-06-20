//
//  WCAppDelegate.m
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import "WCAppDelegate.h"
#import "WCViewController.h"

@implementation WCAppDelegate
@synthesize mDelegate;

+ (WCAppDelegate *)core {
    return (WCAppDelegate *) [UIApplication sharedApplication].delegate;
}

+ (WCViewController *)vc {
    return (WCViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
    }
    
    
    return YES;
}




- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {

    NSArray *permissions = [NSArray arrayWithObjects:@"email", @"user_likes", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:status
                                                                 error:error];
                                             
                                         }];
}


- (BOOL)activeSessionHasPermissions:(NSArray *)permissions
{
    __block BOOL hasPermissions = YES;
    for (NSString *permission in permissions)
    {
        NSInteger index = [[FBSession activeSession].permissions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:permission])
            {
                *stop = YES;
            }
            return *stop;
        }];
        
        if (index == NSNotFound)
        {
            hasPermissions = NO;
        }
    }
    return hasPermissions;
}


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        // NSLog(@"Session opened");
        // Show the user the logged-in UI
        // [self userLoggedIn];
        
        NSLog(@"FBSessionStateOpen");
        
        
        // Check for publish permissions
        [FBRequestConnection startWithGraphPath:@"/me/permissions"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error){
                                      NSDictionary *permissions= [(NSArray *)[result data] objectAtIndex:0];
                                      if (![permissions objectForKey:@"publish_actions"]){
                                          // Publish permissions not found, ask for publish_actions
                                         
                                          [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                                                defaultAudience:FBSessionDefaultAudienceFriends
                                                                              completionHandler:^(FBSession *session, NSError *error) {
                                                                                  __block NSString *alertText;
                                                                                  __block NSString *alertTitle;
                                                                                  if (!error) {
                                                                                      if ([FBSession.activeSession.permissions
                                                                                           indexOfObject:@"publish_actions"] == NSNotFound){
                                                                                          // Permission not granted, tell the user we will not publish
                                                                                          alertTitle = @"Permission not granted";
                                                                                          alertText = @"Your action will not be published to Facebook.";
                                                                                          [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                                                                      message:alertText
                                                                                                                     delegate:self
                                                                                                            cancelButtonTitle:@"OK!"
                                                                                                            otherButtonTitles:nil] show];
                                                                                      } else {
                                                                                          // Permission granted, publish the OG story
                                                                                          [mDelegate facebookLoginSuccess:session];
                                                                                      }
                                                                                      
                                                                                  } else {
                                                                                      // There was an error, handle it
                                                                                      // See https://developers.facebook.com/docs/ios/errors/
                                                                                  }
                                                                              }];
                                          
                                      } else {
                                          // Publish permissions found, publish the OG story
                                          
                                      }
                                      
                                  } else {
                                      // There was an error, handle it
                                      // See https://developers.facebook.com/docs/ios/errors/
                                  }
                              }];
        
        
        
//        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
//            // permission does not exist
//            NSLog(@"not have publish_actions");
//            
//            NSArray *publishPermission = [NSArray arrayWithObjects:@"publish_actions", nil];
//            [session requestNewPublishPermissions:publishPermission
//                                  defaultAudience:FBSessionDefaultAudienceEveryone
//                                completionHandler:^(FBSession *session, NSError *error) {
//                                    if (!error) {
//                                        NSLog(@" requestNewPublishPermissions !!!!");
//                                        [mDelegate facebookLoginSuccess:session];
//                                    } else {
//                                        NSLog(@"%@", [error localizedFailureReason]);
//                                        [FBSession.activeSession closeAndClearTokenInformation];
//                                    }
//                                }];
//
//            
//            
////            [mDelegate facebookLoginSuccess:session];
////            NSArray *publishPermission = [NSArray arrayWithObjects:@"publish_actions", nil];
////            [[FBSession activeSession] requestNewPublishPermissions:publishPermission
////                                  defaultAudience:FBSessionDefaultAudienceEveryone
////                                completionHandler:^(FBSession *session, NSError *error) {
////                                    if (!error) {
////                                        //[self sessionStateChanged:session state:FBSessionStateOpen error:error];
////                                    }
////                                }];
//        } else {
//            [mDelegate facebookLoginSuccess:session];
//            self.mDelegate = nil;
//        }
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        [mDelegate facebookLoginFail:session errors:error];
        self.mDelegate = nil;        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    
    // Note this handler block should be the exact same as the handler passed to any open calls.
//    [FBSession.activeSession setStateChangeHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         
//         // Retrieve the app delegate
//         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//         [self sessionStateChanged:session state:state error:error];
//     }];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
