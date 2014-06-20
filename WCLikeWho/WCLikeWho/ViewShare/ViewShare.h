//
//  ViewShare.h
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCAppDelegate.h"

@interface ViewShare : UIViewController <FacebookLoginDelegate> {
@public
    
}

@property (nonatomic, weak) IBOutlet UILabel *mLabelWCWhoLike;
@property (nonatomic, weak) IBOutlet UILabel *mLabelYouLike;
@property (nonatomic, weak) IBOutlet UILabel *mLabelName;
@property (nonatomic, weak) IBOutlet UIButton *mBtnFBShare;
@property (nonatomic, weak) IBOutlet UIButton *mBtnNormalShare;
@property (nonatomic, weak) IBOutlet UIButton *mBtnClose;
@property (nonatomic, weak) IBOutlet UIView *mViewContent;


- (IBAction)clickBack:(id)sender;
- (IBAction)clickNormalShare:(id)sender;
- (IBAction)clickFacebookShare:(id)sender;

@end
