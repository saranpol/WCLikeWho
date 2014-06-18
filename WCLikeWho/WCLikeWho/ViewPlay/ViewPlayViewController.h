//
//  ViewPlayViewController.h
//  WCLikeWho
//
//  Created by HLPTH-MACMINI2 on 6/18/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCSlotMachine.h"

@interface ViewPlayViewController : UIViewController <ZCSlotMachineDataSource, ZCSlotMachineDelegate> {
@public
    
}

@property (nonatomic, weak) IBOutlet ZCSlotMachine *mSlotMachine;
@property (nonatomic, weak) IBOutlet UIButton *mButton;


@property (nonatomic, strong) NSArray *mSlotIcons;


-(IBAction) didClickStart:(id) sender;

@end
