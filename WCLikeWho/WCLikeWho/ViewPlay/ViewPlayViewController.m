//
//  ViewPlayViewController.m
//  WCLikeWho
//
//  Created by HLPTH-MACMINI2 on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import "ViewPlayViewController.h"
#import "ViewShare.h"
#import "API.h"
#import "WCAppDelegate.h"
#import "WCViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "API.h"
#import "AFNetworking.h"

@implementation ViewPlayViewController
@synthesize mButton;
@synthesize mSlotMachine;
@synthesize mSlotIcons;
@synthesize mViewAdParent;
@synthesize mLabelCaption;
@synthesize mAdBanner;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        mSlotIcons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"Algeria"], [UIImage imageNamed:@"Argentina"], [UIImage imageNamed:@"Australia"], [UIImage imageNamed:@"Belgium"]
                      , [UIImage imageNamed:@"Bosnia-And-Herzegovina"], [UIImage imageNamed:@"Brazil"], [UIImage imageNamed:@"Cameroon"]
                      ,[UIImage imageNamed:@"Chile"], [UIImage imageNamed:@"Colombia"], [UIImage imageNamed:@"Costa-Rica"] ,[UIImage imageNamed:@"Côte-D'ivoire"]
                      , [UIImage imageNamed:@"Croatia"], [UIImage imageNamed:@"Ecuador"], [UIImage imageNamed:@"England"], [UIImage imageNamed:@"France"]
                      , [UIImage imageNamed:@"Germany"], [UIImage imageNamed:@"Ghana"], [UIImage imageNamed:@"Greece"], [UIImage imageNamed:@"Honduras"]
                      , [UIImage imageNamed:@"Iran"], [UIImage imageNamed:@"Italy"], [UIImage imageNamed:@"Japan"], [UIImage imageNamed:@"Korea-Republic"]
                      , [UIImage imageNamed:@"Mexico"], [UIImage imageNamed:@"Netherlands"], [UIImage imageNamed:@"Nigeria"], [UIImage imageNamed:@"Portugal"]
                      ,[UIImage imageNamed:@"Russia"], [UIImage imageNamed:@"Spain"], [UIImage imageNamed:@"Switzerland"], [UIImage imageNamed:@"Uruguay"]
                      , [UIImage imageNamed:@"Usa"], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[API getAPI] requestStarSilentlyWithSuccess:nil failure:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        mIsiPad=YES;
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(5, 19, 5, 8);
    
    if (mIsiPad)
        edgeInset = UIEdgeInsetsMake(7, 40, 7, 8);
    
    mSlotMachine.contentInset = edgeInset;
    mSlotMachine.backgroundImage = [UIImage imageNamed:@"role"];
    mSlotMachine.coverImage = [UIImage imageNamed:@"mask"];
    mSlotMachine.delegate = self;
    mSlotMachine.dataSource = self;


    
    // Admob
    CGPoint origin = CGPointMake(0.0f, 0.0f);
    
    GADAdSize adSize = kGADAdSizeBanner;
    if (mIsiPad)
        adSize = kGADAdSizeLeaderboard;
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.mAdBanner = [[GADBannerView alloc] initWithAdSize:adSize origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.mAdBanner.adUnitID = kSampleAdUnitID;
    self.mAdBanner.delegate = self;
    self.mAdBanner.rootViewController = self;
    [mViewAdParent addSubview:self.mAdBanner];
    [self.mAdBanner loadRequest:[self request]];
    
    
    [mLabelCaption setFont:[UIFont fontWithName:FONT_1 size:mLabelCaption.font.pointSize]];

    
//    mSlotMachine.singleUnitDuration = 0.0f;
//    [self start];
      mSlotMachine.singleUnitDuration = 0.07f;
    
    [mButton.titleLabel setFont:[UIFont fontWithName:FONT_1 size:mButton.titleLabel.font.pointSize]];
    
//    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    // NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    // NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
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


-(IBAction) didClickStart:(id) sender {

    [self start];
    
    return;
    
    WCAppDelegate *core = [WCAppDelegate core];
    [core openSessionWithAllowLoginUI:YES];
    
    return;
    
    API *a = [API getAPI];
    if ([a isTimeToCanClick]) {
        [self start];
    } else {
        int remainingTime = [a canClickTimeRemaining];
        NSString *desc = [NSString stringWithFormat:@"You must wait for %d min.", remainingTime];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:desc
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    

}

-(IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIResponder

- (void)start {
    NSUInteger slotIconCount = [mSlotIcons count];
    
    NSUInteger slotOneIndex = abs(rand() % slotIconCount);
    NSUInteger slotTwoIndex = abs(rand() % slotIconCount);
    NSUInteger slotThreeIndex = abs(rand() % slotIconCount);
    NSUInteger slotFourIndex = abs(rand() % slotIconCount);
    
    // NSLog(@"%d , %d, %d, %d", (int)slotOneIndex, (int)slotTwoIndex, (int)slotThreeIndex, (int)slotFourIndex);
    
    mSlotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:slotOneIndex],
                                [NSNumber numberWithInteger:slotTwoIndex],
                                [NSNumber numberWithInteger:slotThreeIndex],
                                [NSNumber numberWithInteger:slotFourIndex],
                                nil];
    
    [mSlotMachine startSliding];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    mButton.highlighted = YES;
    [mButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.8];
    
    [self start];
}

#pragma mark - ZCSlotMachineDelegate

- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine {
    mButton.enabled = NO;
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
    API *a = [API getAPI];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        ViewShare *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewShare"];
        [self presentViewController:vc animated:YES completion:nil];
        mButton.enabled = YES;
        [a gotStar];
    });
    

}

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return mSlotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 4;
}

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine {
    if (mIsiPad)
        return 95.0f;
    else
        return 60.0f;
}

- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine {
    if (mIsiPad)
        return 30;
    else
        return 14;
}

@end


