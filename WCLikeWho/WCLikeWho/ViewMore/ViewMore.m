//
//  ViewMore.m
//  LockScreen
//
//  Created by saranpol on 6/19/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

#import "ViewMore.h"
#import "CellMore.h"
#import "WCViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"


#define isNSNull(value) [value isKindOfClass:[NSNull class]]
#define HOST @"http://lock-screen-iphone.appspot.com/"
#define REUSE_CELL(CELL_CLASS, TABLE_OBJECT) \
CELL_CLASS *cell = (CELL_CLASS *)[TABLE_OBJECT dequeueReusableCellWithIdentifier:@#CELL_CLASS];\
if (cell == nil) {\
NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@#CELL_CLASS owner:self options:nil];\
cell = [nibArray objectAtIndex:0];\
[cell setSelectionStyle:UITableViewCellSelectionStyleNone];\

#define REUSE_CELL_END }

@implementation ViewMore
@synthesize mTableView;
@synthesize mData;

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
    [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickCloseiPad:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Data

- (void)updateData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@get_list_more?app_id=5",HOST] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        mData = responseObject;
        [mTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary_list_screen = [mData objectForKey:@"data"];
    int i = 0;
    if (ary_list_screen && !isNSNull(ary_list_screen))
        i = (int)[ary_list_screen count];
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellMoreAtIndexPath:indexPath];
}

- (CellMore*)getCellMoreAtIndexPath:(NSIndexPath *)indexPath {
    REUSE_CELL(CellMore, mTableView)
    REUSE_CELL_END
    
    NSMutableArray *ary = [mData objectForKey:@"data"];
    if ([ary count] != 0 && !isNSNull(ary)) {
        NSDictionary *d = [ary objectAtIndex:indexPath.row];
        [cell.mLabel setText:[d objectForKey:@"title"]];
        [cell.mImageView sd_setImageWithURL:[d objectForKey:@"images"]];
        
        [cell.mImageView.layer setCornerRadius:15.0];
        [cell.mImageView.layer setMasksToBounds:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *ary = [mData objectForKey:@"data"];
    if ([ary count] != 0 && !isNSNull(ary)) {
        NSDictionary *d = [ary objectAtIndex:indexPath.row];
        
        NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",[d objectForKey:@"link"]];
        //@"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

@end



















