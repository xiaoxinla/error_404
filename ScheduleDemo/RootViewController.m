//
//  ViewController.m
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/18.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import "RootViewController.h"
#import "DBManager.h"
#import "TaskCell.h"

#define statusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

const static CGFloat tabBarHeight = 50.0f;
const static CGFloat addButtonLength = 50.0f;
const NSInteger futureTableViewTag = 1;
const NSInteger currentTableViewTag = 2;
const NSInteger doneTableViewTag = 3;
@interface RootViewController ()

@property (nonatomic, strong) NSArray *futureTaskArray;
@property (nonatomic, strong) NSArray *currentTaskArray;
@property (nonatomic, strong) NSArray *doneTaskArray;
@property (nonatomic, strong) NSArray *tabBarArray;

@property (nonatomic, strong) UIScrollView *mainScroller;
@property (nonatomic, strong) UITabBar *tabBar;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UITableView *futureTableView;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) UITableView *doneTableView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    
    [DBManager manager];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureData];
    [self configureViews];
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureData {
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"TODO" image:[UIImage imageNamed:@"Clock"] tag:1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"NOW" image:[UIImage imageNamed:@"Bell"] tag:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"DONE" image:[UIImage imageNamed:@"Trophy"] tag:3];
    
    self.tabBarArray = @[item1, item2, item3];
    self.tabBar.items = self.tabBarArray;
}

- (void)configureViews {
    
    self.futureTableView.backgroundColor = [UIColor whiteColor];
    self.currentTableView.backgroundColor = [UIColor whiteColor];
    self.doneTableView.backgroundColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self.addButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    
    self.mainScroller.directionalLockEnabled = YES;
    
    self.mainScroller.contentOffset = CGPointMake(self.mainScroller.frame.size.width, 0);
    self.tabBar.selectedItem = self.tabBarArray[1];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect viewBounds = self.view.bounds;
    
    self.tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0, statusBarHeight, viewBounds.size.width, tabBarHeight}];
    [self.view addSubview:self.tabBar];
    self.tabBar.delegate = self;
    
    self.mainScroller = [[UIScrollView alloc] initWithFrame:(CGRect){0, tabBarHeight + statusBarHeight, viewBounds.size.width, viewBounds.size.height - tabBarHeight}];
    
    CGSize scrollerSize = self.mainScroller.bounds.size;
    self.mainScroller.contentSize = CGSizeMake(scrollerSize.width * 3, scrollerSize.height);
    self.mainScroller.pagingEnabled = YES;
    [self.view addSubview:self.mainScroller];
    self.mainScroller.delegate = self;
    
    self.futureTableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, scrollerSize.width, scrollerSize.height} style:UITableViewStylePlain];
    self.currentTableView = [[UITableView alloc] initWithFrame:(CGRect){scrollerSize.width, 0, scrollerSize.width, scrollerSize.height} style:UITableViewStylePlain];
    self.doneTableView = [[UITableView alloc] initWithFrame:(CGRect){scrollerSize.width * 2, 0, scrollerSize.width, scrollerSize.height} style:UITableViewStylePlain];
    
    self.futureTableView.tag = futureTableViewTag;
    self.futureTableView.dataSource = self;
    self.futureTableView.delegate = self;
    self.currentTableView.tag = currentTableViewTag;
    self.currentTableView.dataSource = self;
    self.currentTableView.delegate = self;
    self.doneTableView.tag = doneTableViewTag;
    self.doneTableView.dataSource = self;
    self.doneTableView.delegate = self;
    
    [self.mainScroller addSubview:self.futureTableView];
    [self.mainScroller addSubview:self.currentTableView];
    [self.mainScroller addSubview:self.doneTableView];
    
    self.addButton = [[UIButton alloc] initWithFrame:(CGRect){(viewBounds.size.width - addButtonLength)/2, viewBounds.size.height - addButtonLength, addButtonLength, addButtonLength}];
    [self.view addSubview:self.addButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = item.tag;
    CGPoint conOffset = CGPointMake(self.mainScroller.frame.size.width * (index - 1), 0);
    self.mainScroller.contentOffset = conOffset;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat pageWidth = scrollView.frame.size.width;
    if (offset < pageWidth / 2) {
        self.tabBar.selectedItem = self.tabBarArray[0];
    } else if (offset < pageWidth * 3 / 2) {
        self.tabBar.selectedItem = self.tabBarArray[1];
    } else {
        self.tabBar.selectedItem = self.tabBarArray[2];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *taskCellIdentifier = @"TaskCell";
    TaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    if (!taskCell) {
        taskCell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    if (tableView.tag == futureTableViewTag) {
//        taskCell.task = self.
    }
    
    return taskCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
