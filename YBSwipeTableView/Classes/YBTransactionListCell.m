//
//  YBTransactionListCell.m
//  YNAB
//
//  Created by Sebastian Hubrich on 17.08.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import "YBTransactionListCell.h"
#import "YBTransactionListBackView.h"


const NSInteger EDITING_HORIZONTAL_OFFSET = 35;
const NSInteger SELECTION_INDICATOR_TAG = 54321;
const NSInteger SIDE_PADDING = 5;

@interface YBTransactionListCell ()

@end

@implementation YBTransactionListCell

static UIImage *imgSelected;
static UIImage *imgNotSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _frontView = [[YBTransactionListFrontView alloc] initWithFrame:self.frame];
        _frontView.opaque = YES;
        _frontView.userInteractionEnabled = NO;

        _backView = [[YBTransactionListBackView alloc] initWithFrame:self.frame];
        
        [self.contentView addSubview:_backView];
        [self.contentView addSubview:_frontView];
        
        // Indicator view for bulk editing
        imgSelected = [UIImage imageNamed:@"selected.png"];
        imgNotSelected = [UIImage imageNamed:@"notselected.png"];
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:imgNotSelected];
        indicator.contentMode = UIViewContentModeCenter;
        const NSInteger IMAGE_SIZE = 30;
        
        indicator.tag = SELECTION_INDICATOR_TAG;
        indicator.frame = CGRectMake(-EDITING_HORIZONTAL_OFFSET + SIDE_PADDING, (self.frame.size.height / 2) - (IMAGE_SIZE / 2), IMAGE_SIZE, IMAGE_SIZE);
        
        [self.contentView addSubview:indicator];
    }

    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIImageView *indicator = (UIImageView *)[self.contentView viewWithTag:SELECTION_INDICATOR_TAG];
    if (selected) {
        indicator.image = [UIImage imageNamed:@"selected.png"];
    }
    else {
        indicator.image = [UIImage imageNamed:@"notselected.png"];
    };
    
    self.frontView.selectedView = selected;
    [super setSelected:selected animated:animated];
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.isCustomEditing) {
        highlighted = NO;
    }
    self.frontView.highlightedView = highlighted;
    [super setHighlighted:highlighted animated:animated];
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Don't pass it on, we'll handle it ourselves to have control over the editing view (checkmark)
    _isCustomEditing = editing;
    self.frontView.editingView = editing;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    UIImageView *indicator = (UIImageView *)[self.contentView viewWithTag:SELECTION_INDICATOR_TAG];
    if (self.isCustomEditing) {
        CGRect contentFrame = indicator.frame;
        contentFrame.origin.x = SIDE_PADDING;
        indicator.frame = contentFrame;
    }
    else {
        CGRect contentFrame = indicator.frame;
        contentFrame.origin.x = -EDITING_HORIZONTAL_OFFSET + SIDE_PADDING;
        indicator.frame = contentFrame;
    }
    
    [UIView commitAnimations];
    [self.frontView setNeedsDisplay];
}


-(void)layoutSubviews {
    if ( ! self.isAnimating) {
        if (self.isSwiped) {
            _backView.frame = CGRectMake(PAN_CLOSED_X, 0, self.frame.size.width, self.frame.size.height);
            _frontView.frame = CGRectMake(PAN_OPEN_X, 0, self.frame.size.width, self.frame.size.height);
        }
        else {
            _backView.frame = CGRectMake(PAN_CLOSED_X, 0, self.frame.size.width, self.frame.size.height);
            _frontView.frame = CGRectMake(PAN_CLOSED_X, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    
    [super layoutSubviews];
}

- (void)setIsSwiped:(BOOL)isSwiped {
    _isSwiped = isSwiped;
    self.backView.userInteractionEnabled = isSwiped;
}


@end
