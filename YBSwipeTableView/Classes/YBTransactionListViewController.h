//
//  YBTransactionListViewController.h
//  YNAB
//
//  Created by Sebastian Hubrich on 26.07.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTransactionListBackView.h"
#import "YBSwipeTableViewProtocol.h"
#import "YBDetailViewController.h"

@interface YBTransactionListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, YBSwipeTableViewProtocol> {
    CGFloat bouncePixels;
}

@property(nonatomic, strong) UITableView *tableView;

- (void)initScreen;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
