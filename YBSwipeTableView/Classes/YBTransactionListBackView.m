//
//  YBTransactionListBackView.m
//  YNAB
//
//  Created by Sebastian Hubrich on 31.07.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import "YBTransactionListBackView.h"

@implementation YBTransactionListBackView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect labelRect = CGRectMake(0, 15, 70, 20);
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(frame.size.width-70-70, 0, 70, frame.size.height);
        _clearButton.backgroundColor = UIColorFromRGB(0x1E3E4A);
        self.clearLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.clearLabel.textColor = [UIColor whiteColor];
        self.clearLabel.text = @"Clear";
        self.clearLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.5];
        self.clearLabel.backgroundColor = [UIColor clearColor];
        self.clearLabel.textAlignment = NSTextAlignmentCenter;
        [_clearButton addSubview:self.clearLabel];
        
        [self addSubview:_clearButton];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(frame.size.width-70, 0, 70, frame.size.height);
        _deleteButton.backgroundColor = UIColorFromRGB(0xdd3646);
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:labelRect];
        deleteLabel.textColor = [UIColor whiteColor];
        deleteLabel.text = @"Delete";
        deleteLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.5];
        deleteLabel.backgroundColor = [UIColor clearColor];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        [_deleteButton addSubview:deleteLabel];
        
        [self addSubview:_deleteButton];
    }
    return self;
}


- (void)layoutSubviews {
    self.clearButton.frame = CGRectMake(self.frame.size.width-70-70, 0, 70, self.frame.size.height);
    self.deleteButton.frame = CGRectMake(self.frame.size.width-70, 0, 70, self.frame.size.height);

    [super layoutSubviews];
}

@end
