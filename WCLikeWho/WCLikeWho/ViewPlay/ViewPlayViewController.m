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

@implementation ViewPlayViewController
@synthesize mButton;
@synthesize mSlotMachine;
@synthesize mSlotIcons;
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
                      [UIImage imageNamed:@"Doraemon"], [UIImage imageNamed:@"Mario"], [UIImage imageNamed:@"Nobi Nobita"], [UIImage imageNamed:@"Batman"], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mSlotMachine.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
    mSlotMachine.backgroundImage = [UIImage imageNamed:@"SlotMachineBackground"];
    mSlotMachine.coverImage = [UIImage imageNamed:@"SlotMachineCover"];
    
    mSlotMachine.delegate = self;
    mSlotMachine.dataSource = self;

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - UIResponder

- (void)start {
    NSUInteger slotIconCount = [mSlotIcons count];
    
    NSUInteger slotOneIndex = abs(rand() % slotIconCount);
    NSUInteger slotTwoIndex = abs(rand() % slotIconCount);
    NSUInteger slotThreeIndex = abs(rand() % slotIconCount);
    NSUInteger slotFourIndex = abs(rand() % slotIconCount);
    
    NSLog(@"%d , %d, %d, %d", (int)slotOneIndex, (int)slotTwoIndex, (int)slotThreeIndex, (int)slotFourIndex);
    
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
    
    mButton.enabled = YES;
    
    [a gotStar];
    ViewShare *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewShare"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return mSlotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 4;
}

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 65.0f;
}

- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 5.0f;
}

@end


