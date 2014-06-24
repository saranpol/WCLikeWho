//
//  ViewPlayViewController.h
//  WCLikeWho
//
//  Created by HLPTH-MACMINI2 on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCSlotMachine.h"
#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface ViewPlayViewController : UIViewController <ZCSlotMachineDataSource, ZCSlotMachineDelegate, GADBannerViewDelegate> {
@public
    BOOL mIsiPad;
}

@property (nonatomic, weak) IBOutlet ZCSlotMachine *mSlotMachine;
@property (nonatomic, weak) IBOutlet UIButton *mButton;


@property (nonatomic, strong) NSArray *mSlotIcons;


@property (nonatomic, weak) IBOutlet UILabel *mLabelCaption;
@property (nonatomic, weak) IBOutlet UIView *mViewAdParent;
@property (nonatomic, strong) GADBannerView *mAdBanner;

-(IBAction)didClickStart:(id)sender;
-(IBAction)didClickBack:(id)sender;

@end
