//
//  YBTransactionListCell.h
//  YNAB
//
//  Created by Sebastian Hubrich on 17.08.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTransactionListFrontView.h"
#import "YBTransactionListBackView.h"
#import "YBSwipeCellProtocol.h"

extern const NSInteger EDITING_HORIZONTAL_OFFSET;

@interface YBTransactionListCell : UITableViewCell <YBSwipeCellProtocol>

@property(nonatomic, retain) YBTransactionListFrontView *frontView;
@property(nonatomic, retain) YBTransactionListBackView *backView;
@property(nonatomic) BOOL isSwiped;
@property(nonatomic) BOOL isAnimating;
@property(nonatomic) BOOL isCustomEditing;

@end
