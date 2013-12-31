//
//  YBTransactionListFrontView.h
//  YNAB
//
//  Created by Sebastian Hubrich on 4/23/11.
//  Copyright 2011 YouNeedABudget.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBTransactionListFrontView : UIView {

}

@property (nonatomic, strong) NSString *payeeText;

@property(nonatomic) BOOL highlightedView;
@property(nonatomic) BOOL selectedView;
@property(nonatomic) BOOL editingView;

@end
