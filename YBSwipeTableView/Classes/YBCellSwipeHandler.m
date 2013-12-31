//
//  YBCellSwipeHandler.m
//  YNAB
//
//  Created by Sebastian Hubrich on 11.11.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import "YBCellSwipeHandler.h"

@implementation YBCellSwipeHandler

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.tableView.isEditing) {
        return NO;
    }
    
    UIView *cell = [panGestureRecognizer view];
    CGPoint translation = [panGestureRecognizer translationInView:[cell superview]];
    return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
}


#pragma mark - Gesture handlers
- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    float threshold = (self.panOpenX / 2 + PAN_CLOSED_X) / 2.0;
    float vX = 0.0;
    float compare;
    float finalX;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[panGestureRecognizer view]];
    
    if ( ! [self.sourceViewController canEditRowAtIndexPath:indexPath]) {
        return;
    }
    
    UIView *view = ((id<YBSwipeCellProtocol>)panGestureRecognizer.view).frontView;
    
    switch ([panGestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
        {
            // If there's an open cell, close it before we start opening the new one
            if (self.openCellIndexPath != nil && (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row)) {
                id<YBSwipeCellProtocol> customCell = (id<YBSwipeCellProtocol>) [self.tableView cellForRowAtIndexPath:self.openCellIndexPath];
                [self closeSwipeView:customCell.frontView];
                customCell.isSwiped = NO;
                customCell.isAnimating = NO;
            }
            
            id<YBSwipeCellProtocol> newCell = (id<YBSwipeCellProtocol>)panGestureRecognizer.view;
            newCell.isAnimating = YES;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
            vX = (FAST_ANIMATION_DURATION / 2.0) * [panGestureRecognizer velocityInView:self.sourceViewController.view].x;
            compare = view.transform.tx + vX;
            if (compare > threshold) {
                finalX = MAX(self.panOpenX, PAN_CLOSED_X);
                [self setOpenCellLastTX:0];
            } else {
                finalX = MIN(self.panOpenX, PAN_CLOSED_X);
                [self setOpenCellLastTX:view.transform.tx];
            }
            
            [self snapView:view toX:finalX animated:YES];
            if (finalX == PAN_CLOSED_X) {
                id<YBSwipeCellProtocol> cell = (id<YBSwipeCellProtocol>) panGestureRecognizer.view;
                [self setOpenCellIndexPath:nil];
                cell.isSwiped = NO;
                cell.isAnimating = NO;
            } else {
                id<YBSwipeCellProtocol> cell = (id<YBSwipeCellProtocol>) panGestureRecognizer.view;
                [self setOpenCellIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)cell]];
                cell.isSwiped = YES;
                cell.isAnimating = NO;
            }
            break;
        case UIGestureRecognizerStateChanged: {
            compare = self.openCellLastTX + [panGestureRecognizer translationInView:self.sourceViewController.view].x;
            if (compare > MAX(self.panOpenX, PAN_CLOSED_X))
                compare = MAX(self.panOpenX, PAN_CLOSED_X);
            else if (compare < MIN(self.panOpenX, PAN_CLOSED_X))
                compare = MIN(self.panOpenX, PAN_CLOSED_X);
            [view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
            break;
        }
        default:
            break;
    }
}


- (void)closeSwipeView:(UIView *)view {
    [self snapView:view toX:0 animated:YES];
    [self setOpenCellIndexPath:nil];
    self.openCellLastTX = 0;
}


- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:FAST_ANIMATION_DURATION];
    }
    
    [view setTransform:CGAffineTransformMakeTranslation(x, 0)];
    
    if (animated) {
        [UIView commitAnimations];
    }
}


- (void)handleViewWillAppear {
    if (self.openCellLastTX != 0) {
        id<YBSwipeCellProtocol> openCell = (id<YBSwipeCellProtocol>) [self.tableView cellForRowAtIndexPath:self.openCellIndexPath];
        if (openCell) {
            [self closeSwipeView:openCell.frontView];
            openCell.isSwiped = NO;
            openCell.isAnimating = NO;
        }
    }
}


- (void)configureCell:(id<YBSwipeCellProtocol>)cell forIndexPath:(NSIndexPath *)indexPath {
    if (self.openCellIndexPath != nil && self.openCellIndexPath.section == indexPath.section && self.openCellIndexPath.row == indexPath.row) {
        cell.isSwiped = YES;
        cell.isAnimating = NO;
    }
    else {
        cell.isSwiped = NO;
        cell.isAnimating = NO;
    }
}

@end
