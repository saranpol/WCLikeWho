//
//  WCViewController.m
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import "WCViewController.h"
#import "WCAppDelegate.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import "API.h"

@interface WCViewController ()

@end

@implementation WCViewController
@synthesize mAdBanner;
@synthesize mViewAdParent;
@synthesize mLabelGender;
@synthesize mButtonDone;
@synthesize mImgUser;
@synthesize mLabelYourPhoto;

- (void)viewDidAppear:(BOOL)animated {
    API *a = [API getAPI];
    if (a.mData)
        a.mData = nil;
    [a requestStarSilentlyWithSuccess:nil failure:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    CGPoint origin = CGPointMake(0.0f, 0.0f);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    
    GADAdSize adSize = kGADAdSizeBanner;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        adSize = kGADAdSizeLeaderboard;
    
    
    self.mAdBanner = [[GADBannerView alloc] initWithAdSize:adSize origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.mAdBanner.adUnitID = kSampleAdUnitID;
    self.mAdBanner.delegate = self;
    self.mAdBanner.rootViewController = self;
    [mViewAdParent addSubview:self.mAdBanner];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.mAdBanner loadRequest:request];
    

    [mLabelGender setFont:[UIFont fontWithName:FONT_1 size:mLabelGender.font.pointSize]];
    [mLabelYourPhoto setFont:[UIFont fontWithName:FONT_1 size:mLabelGender.font.pointSize]];

    [mButtonDone setEnabled:NO];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickChooseUser:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setAllowsEditing:YES];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {


    UIImage *image = (UIImage*)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image)
        [mLabelYourPhoto setHidden:YES];
    //NSLog(@"%@", info);
    
    API *a = [API getAPI];
    a.mUserImage = image;
    [mImgUser setImage:a.mUserImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [mButtonDone setEnabled:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    API *a = [API getAPI];
    if([[segue identifier] isEqualToString:@"SelectMale"]){
        a.mUserGender = USER_IS_MALE;
    } else if ([[segue identifier] isEqualToString:@"SelectFemale"]) {
        a.mUserGender = USER_IS_FEMALE;
    }
}


#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    // NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    // NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}



@end
