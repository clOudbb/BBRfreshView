//
//  BBMainViewController.m
//  Bilibili_Demo
//
//  Created by 张征鸿 on 2017/8/23.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "BBMainViewController.h"
#import "BBRfreshView.h"
#define kPinkColor   kRGB(247, 75, 121)
#define kRGB(R, G, B)               [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
@interface BBMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) BBRfreshView *backGoundView;

@end

@implementation BBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backGoundView];
    [self.backGoundView showFromScrollView:self.tableView];
    self.backGoundView.showView.backgroundColor = [UIColor grayColor];
    self.backGoundView.showView.layer.cornerRadius = 8;
    self.view.backgroundColor = kPinkColor;
    self.view.layer.masksToBounds = true;
    self.view.layer.cornerRadius = 8;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (BBRfreshView *)backGoundView
{
    if (!_backGoundView) {
        _backGoundView = [BBRfreshView new ];
        _backGoundView.frame = self.tableView.frame;
        _backGoundView.backgroundColor = [UIColor clearColor];
    }
    return _backGoundView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
