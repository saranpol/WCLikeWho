//
//  ViewMore.h
//  LockScreen
//
//  Created by saranpol on 6/19/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMore : UIViewController  {
}

@property (nonatomic,weak) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSDictionary *mData;
- (IBAction)clickClose:(id)sender;
- (IBAction)clickCloseiPad:(id)sender;
@end
