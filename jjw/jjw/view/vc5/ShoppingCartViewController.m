//
//  ShoppingCartViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "JZNavigationExtension.h"
#import "MJRefresh.h"
#import "ShoppintCarTableViewCell.h"

@interface ShoppingCartViewController (){
    NSMutableArray *dataSource;
}

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"购物车";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    dataSource = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _myTableView.tableFooterView = [[UIView alloc] init];
    [_myTableView.mj_header beginRefreshing];
}

-(void)loadData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_cart"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        [dataSource removeAllObjects];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSArray *array = [result objectForKey:@"data_list"];
            
            [dataSource addObjectsFromArray:array];
            
            DLog(@"%@",result);
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        [_myTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
    }];
}

-(void)del:(UIButton *)btn{
    NSDictionary *info = [dataSource objectAtIndex:btn.tag];
    //    NSString *USER_ID = [info objectForKey:@"USER_ID"];
    NSString *ids = [info objectForKey:@"f_id"];
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:ids forKey:@"cid"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_cart_delete"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            [self loadData];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
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
    static NSString *CellIdentifier = @"shoppintCarCell";
    ShoppintCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (ShoppintCarTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ShoppintCarTableViewCell" owner:self options:nil]  lastObject];
        
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *COURSE_NAME = [info objectForKey:@"COURSE_NAME"];
    NSString *CURRENT_PRICE = [info objectForKey:@"CURRENT_PRICE"];
    NSString *f_create_time = [info objectForKey:@"f_create_time"];
    
    cell.nameLabel.text = COURSE_NAME;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",CURRENT_PRICE];
    cell.dateLabel.text = f_create_time;
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

@end
