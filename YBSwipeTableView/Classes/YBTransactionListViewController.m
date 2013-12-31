//
//  YBTransactionListViewController.m
//  YNAB
//
//  Created by Sebastian Hubrich on 26.07.13.
//  Copyright (c) 2013 YouNeedABudget. All rights reserved.
//

#import "YBTransactionListViewController.h"
#import "YBTransactionListFrontView.h"
#import "YBTransactionListCell.h"
#import "YBCellSwipeHandler.h"

@interface YBTransactionListViewController ()


@property(nonatomic, strong) UIToolbar *actionToolbar;
@property(nonatomic) BOOL tableViewUpdateInProgress;
@property(nonatomic, strong) YBCellSwipeHandler *swipeHandler;
@property(nonatomic, strong) id swipeTransaction;

@end

@implementation YBTransactionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self initScreen];

    // Cell swipe handler
    self.swipeHandler = [[YBCellSwipeHandler alloc] init];
    self.swipeHandler.sourceViewController = self;
    self.swipeHandler.tableView = self.tableView;
    self.swipeHandler.panOpenX = PAN_OPEN_X;
}


- (void)viewWillAppear:(BOOL)animated {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1E3E4A);
        self.navigationController.navigationBar.translucent = NO;
    }

    [self.swipeHandler handleViewWillAppear];
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.swipeTransaction = nil;
}


- (void)initScreen {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}


- (UIView *)tableView:(UITableView *)curTableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    headerView.opaque = YES;
    headerView.backgroundColor = UIColorFromRGB(0xdaeef3);
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section * 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)curTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *txnCell = @"txnCell";
    UITableViewCell *cell = [curTableView dequeueReusableCellWithIdentifier:txnCell];

    if (cell == nil) {
        cell = [[YBTransactionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:txnCell];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YBTransactionListCell *custCell = (YBTransactionListCell *) cell;
    
    custCell.frontView.payeeText = @"Test";
    custCell.backView.clearLabel.text = @"Clear";
    
    // Set up the left swipe behavior
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.swipeHandler action:@selector(handlePan:)];
    [panGestureRecognizer setDelegate:self.swipeHandler];
    [custCell addGestureRecognizer:panGestureRecognizer];
    
    custCell.accessoryType = UITableViewCellAccessoryNone;
    
    // Wire up the button event handler
    YBTransactionListBackView *backView = (YBTransactionListBackView *)custCell.backView;
    [backView.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backView.clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.swipeHandler configureCell:custCell forIndexPath:indexPath];
}


- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)currentTableView animated:(BOOL)animated {
    [currentTableView deselectRowAtIndexPath:indexPath animated:animated];
}


- (void)tableView:(UITableView *)curTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath forTableView:curTableView animated:NO];
}


- (void)tableView:(UITableView *)curTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:curTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}


- (void)tableView:(UITableView *)curTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.visibleViewController != self) return;

    YBDetailViewController *detailViewController = [[YBDetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];

    [curTableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Close any open sliding menu to avoid a situation where the cell is no longer available (invisible so it's unloaded from memory) and we
// can't close the swipe view. Inspired by mail.app in iOS 7 that immediately closes any swipe menu when scrolling.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.swipeHandler handleViewWillAppear];
}


#pragma mark - YBSwipeTableViewProtocol
- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView canEditRowAtIndexPath:indexPath];
}


#pragma mark - Add/edit/delete a transaction
- (void)deleteButtonPressed:(id)sender {
    NSIndexPath *indexPath = [self indexPathForButtonPress:sender];
    YBTransactionListCell *cell = (YBTransactionListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.swipeHandler closeSwipeView:cell.frontView];
    cell.isSwiped = NO;
    cell.isAnimating = NO;
    
    NSLog(@"deleteButtonPressed");
}


- (void)clearButtonPressed:(id)sender {
    NSIndexPath *indexPath = [self indexPathForButtonPress:sender];
    YBTransactionListCell *cell = (YBTransactionListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.swipeHandler closeSwipeView:cell.frontView];
    cell.isSwiped = NO;
    cell.isAnimating = NO;
    
    NSLog(@"clearButtonPressed");
}


- (NSIndexPath *)indexPathForButtonPress:(UIButton *)button {
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath == nil) {
        return nil;
    }

    return indexPath;
}

@end
