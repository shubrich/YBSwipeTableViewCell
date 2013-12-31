//
//  YBSwipeCellProtocol.h
//  YNAB
//
//  Created by Sebastian Hubrich on 11.11.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YBSwipeCellProtocol <NSObject>

@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic) BOOL isSwiped;
@property (nonatomic) BOOL isAnimating;

@end
