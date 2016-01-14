//
//  ViewShare.m
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import "ViewShare.h"
#import "API.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "UIView+Circle.h"

@implementation ViewShare
@synthesize mLabelName;
@synthesize mLabelWCWhoLike;
@synthesize mLabelYouLike;
@synthesize mBtnClose;
@synthesize mBtnFBShare;
@synthesize mBtnNormalShare;
@synthesize mViewContent;
@synthesize mLoadingIndicatorImage;
@synthesize mLoadingIndicatorName;
@synthesize mImageStar;
@synthesize mImgUser;
@synthesize mImgBG;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    API *a = [API getAPI];
    
    [mLabelName setFont:[UIFont fontWithName:FONT_1 size:mLabelName.font.pointSize]];
    [mLabelWCWhoLike setFont:[UIFont fontWithName:FONT_1 size:mLabelWCWhoLike.font.pointSize]];
    [mLabelYouLike setFont:[UIFont fontWithName:FONT_1 size:mLabelYouLike.font.pointSize]];
    
    [mBtnNormalShare.titleLabel setFont:[UIFont fontWithName:FONT_1 size:mBtnNormalShare.titleLabel.font.pointSize]];
    [mBtnFBShare.titleLabel setFont:[UIFont fontWithName:FONT_1 size:mBtnFBShare.titleLabel.font.pointSize]];
    [mBtnClose.titleLabel setFont:[UIFont fontWithName:FONT_1 size:mBtnClose.titleLabel.font.pointSize]];
    
    [mLabelYouLike setText:@"You Look Like"];
    
    [a requestStarSilentlyWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = (NSDictionary*)responseObject;
        [self updateUIWithData:data];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self updateUIWithData:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please check your internet connection."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    [mImgUser setImage:a.mUserImage];
    [mImgUser setCircle];
    [mImgBG setCircle];
    
    
}


- (void)updateUIWithData:(NSDictionary*)data {
    [mLoadingIndicatorName setHidden:YES];
    if (data) {
        NSString *starName = [data objectForKey:@"name"];
        NSString *strUrl = [data objectForKey:@"url"];
        //strUrl = @"https://world-cup-brazil.appspot.com/images/reborn-chimpanzee.jpg";
        
        
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"http"
                                             withString:@"https"];

        NSURL *url = [NSURL URLWithString:strUrl];
        [mLabelName setText:starName];
        
        [mImageStar sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [mLoadingIndicatorImage setHidden:YES];
        }];
        
//        [mLoadingIndicatorImage setHidden:YES];
//        [mImageStar sd_setImageWithURL:url];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)shareFacebook {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Sharing..";
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //[params setObject:@"your custom message" forKey:@"message"];
    [params setObject:UIImagePNGRepresentation([self saveImage]) forKey:@"picture"];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         [hud hide:YES];
         if (error)
         {
             //showing an alert for failure
             NSLog(@"%@", error);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Shared the photo fail\nPlease try again."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             
         }
         else
         {
             //showing an alert for success
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"Success";
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 // Do something...
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                             message:@"Shared the photo successfully."
//                                                            delegate:self
//                                                   cancelButtonTitle:@"OK"
//                                                   otherButtonTitles:nil];
//             [alert show];

         }
     }];
    
    
}


- (UIImage*)saveImage {
    UIImage* image;
    UIGraphicsBeginImageContextWithOptions(mViewContent.bounds.size, self.view.opaque, 0.0);
    [mViewContent.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (IBAction)clickBack:(id)sender {
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickNormalShare:(id)sender {
    UIImage *image = [self saveImage];
    
    NSArray* dataToShare = @[image];  // ...or whatever pieces of data you want to share.
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{
        
    }];
}

- (IBAction)clickFacebookShare:(id)sender {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [self shareFacebook];
    } else {
        WCAppDelegate *core = [WCAppDelegate core];
        core.mDelegate = self;
        [core openSessionWithAllowLoginUI:YES];
    }
    
    
}

- (void)facebookLoginSuccess:(FBSession*)session {
    [self shareFacebook];
}

- (void)facebookLoginFail:(FBSession*)session errors:(NSError*)errors {

}


@end
