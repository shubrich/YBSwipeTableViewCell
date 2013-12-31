//
//  YBTransactionListFrontView.m
//  YNAB
//
//  Created by Sebastian Hubrich on 4/23/11.
//  Copyright 2011 YouNeedABudget.com. All rights reserved.
//

#import "YBTransactionListFrontView.h"


@interface YBTransactionListFrontView ()
@end

@implementation YBTransactionListFrontView

static UIFont *payeeFont = nil;

+ (void)initialize {
	if(self == [YBTransactionListFrontView class]) {
        payeeFont = [UIFont fontWithName:@"HelveticaNeue" size:16.5];
    }
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	
	[backgroundColor set];
	CGContextFillRect(context, rect);
    
    if(self.highlightedView) {
        [UIColorFromRGB(0xD0D0D0) set];
        CGContextFillRect(context, rect);
    }
    
    [textColor set];
    NSInteger editOffset = self.editingView ? 30 : 0;
    NSInteger xPosPayee =  30 + editOffset;
    NSInteger yPosPayee = 6;
    NSInteger widthPayee = 170 - editOffset;
    
    
    // Draw the payee name
    if (self.payeeText == nil || [self.payeeText isEqualToString:@""]) {
        [UIColorFromRGB(0x949494) set];
        self.payeeText = @"No payee set";
        [self.payeeText drawInRect:CGRectMake(xPosPayee, yPosPayee, widthPayee, 21) withFont:payeeFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    }
    else {
        [UIColorFromRGB(0x151515) set];
        [self.payeeText drawInRect:CGRectMake(xPosPayee, yPosPayee, widthPayee, 21) withFont:payeeFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    }
}
@end
