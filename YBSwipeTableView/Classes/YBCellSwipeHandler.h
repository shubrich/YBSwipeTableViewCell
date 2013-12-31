//
//  YBCellSwipeHandler.h
//  YNAB
//
//  Created by Sebastian Hubrich on 11.11.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBSwipeCellProtocol.h"
#import "YBSwipeTableViewProtocol.h"

@interface YBCellSwipeHandler : NSObject <UIGestureRecognizerDelegate> {
    
}

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic) CGFloat panOpenX;
@property(nonatomic, strong) NSIndexPath *openCellIndexPath;
@property(nonatomic) float openCellLastTX;
@property(nonatomic, weak) id<YBSwipeTableViewProtocol>sourceViewController;

- (void)handleViewWillAppear;
- (void)closeSwipeView:(UIView *)view;
- (void)configureCell:(id<YBSwipeCellProtocol>)cell forIndexPath:(NSIndexPath *)indexPath;

@end
