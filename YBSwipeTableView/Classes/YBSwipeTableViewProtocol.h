//
//  YBSwipeTableViewProtocol.h
//  YNAB
//
//  Created by Sebastian Hubrich on 11.11.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YBSwipeTableViewProtocol <NSObject>

@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) UITableView *tableView;

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;

@end
