//
//  ViewController.m
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/18.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import "RootViewController.h"
#import "DBManager.h"

@interface RootViewController ()

@property (nonatomic, strong) UIScrollView *mainScroller;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    [DBManager manager];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect viewBounds = self.view.bounds;
    self.mainScroller = [[UIScrollView alloc] initWithFrame:viewBounds];
    self.mainScroller.contentSize = CGSizeMake(viewBounds.size.width * 3, viewBounds.size.height);
    self.mainScroller.pagingEnabled = YES;
    [self.view addSubview:self.mainScroller];
    
    UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0, 0, viewBounds.size.width, viewBounds.size.height}];
    view1.backgroundColor = [UIColor redColor];
    [self.mainScroller addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:(CGRect){viewBounds.size.width, 0, viewBounds.size.width, viewBounds.size.height}];
    view2.backgroundColor = [UIColor greenColor];
    [self.mainScroller addSubview:view2];
    UIView *view3 = [[UIView alloc] initWithFrame:(CGRect){viewBounds.size.width * 2, 0, viewBounds.size.width, viewBounds.size.height}];
    view3.backgroundColor = [UIColor yellowColor];
    [self.mainScroller addSubview:view3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
