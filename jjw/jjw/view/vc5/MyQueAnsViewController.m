//
//  MyQueAnsViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MyQueAnsViewController.h"
#import "JZNavigationExtension.h"
#import "MJRefresh.h"
#import "MyQusAnsTableViewCell.h"
#import "NSDictionary+Category.h"

@interface MyQueAnsViewController (){
    NSMutableArray *dataSource;
}

@end

@implementation MyQueAnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.title = @"我的问答";
    self.view.backgroundColor = RGB(245, 245, 245);
    
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        
    }];
    
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
        [_myTableView.mj_footer endRefreshing];
    }];
    
    
    [_myTableView.mj_header beginRefreshing];
}

-(void)loadData{
    if (dataSource == nil) {
        dataSource = [NSMutableArray array];
    }
    
    [dataSource removeAllObjects];
    
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"uid"];
    [param setObject:@"1" forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_do_demand"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            
            
            
            
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        [_myTableView reloadData];
        [_myTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        DLog(@"%@",error.description);
    }];
    
}

-(void)loadMore{
    for (int i = 0 ; i < 10; i++) {
        [dataSource addObject:@"1"];
    }
    [_myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"myQusAnsCell";
    MyQusAnsTableViewCell *cell = (MyQusAnsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (MyQusAnsTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MyQusAnsTableViewCell" owner:self options:nil]  lastObject];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
