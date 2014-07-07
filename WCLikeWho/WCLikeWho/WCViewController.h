//
//  WCViewController.h
//  WCLikeWho
//
//  Created by saranpol on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface WCViewController : UIViewController <GADBannerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
@public
    
}

@property (nonatomic, weak) IBOutlet UILabel *mLabelGender;
@property (nonatomic, weak) IBOutlet UILabel *mLabelYourPhoto;

@property (nonatomic, weak) IBOutlet UIView *mViewAdParent;
@property (nonatomic, strong) GADBannerView *mAdBanner;


// new
@property (nonatomic, weak) IBOutlet UIButton *mButtonDone;
@property (nonatomic, weak) IBOutlet UIImageView *mImgUser;
- (IBAction)clickChooseUser:(id)sender;

@end
