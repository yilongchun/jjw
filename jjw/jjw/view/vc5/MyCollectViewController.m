//
//  MyCollectViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MyCollectViewController.h"
#import "JZNavigationExtension.h"
#import "MJRefresh.h"
#import "MyCollectTableViewCell.h"
#import "UIImage+Color.h"
#import "ClassDetailViewController.h"

@interface MyCollectViewController (){
    NSMutableArray *dataSource;
    int page;
    int pageCount;
}

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"我的收藏";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
    self.automaticallyAdjustsScrollViewInsets = NO;

    _myTableView.tableFooterView = [[UIView alloc] init];
    dataSource = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    _myTableView.mj_footer.automaticallyHidden = YES;
    [_myTableView.mj_header beginRefreshing];
}

-(void)loadData{
    page = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_user_favorite"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_footer resetNoMoreData];
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            [_myTableView reloadData];
            
            NSNumber *page_count = [result objectForKey:@"page_count"];
            pageCount = [page_count intValue];
            if (page == pageCount) {
                [_myTableView.mj_header endRefreshing];
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_myTableView.mj_header endRefreshing];
            }
            DLog(@"%@",result);
            
        }else if([code isEqualToString:@"401"]){
            [dataSource removeAllObjects];
            [_myTableView reloadData];
            [_myTableView.mj_header endRefreshing];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }else{
            [_myTableView.mj_header endRefreshing];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadMore{
    page++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_user_favorite"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_footer endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            [dataSource addObjectsFromArray:array];
            NSNumber *pageNum = [result objectForKey:@"page"];
            if (page == [pageNum intValue]) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_myTableView reloadData];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

//删除收藏
-(void)delFav:(UIButton *)btn{
    NSDictionary *info = [dataSource objectAtIndex:btn.tag];
//    NSString *USER_ID = [info objectForKey:@"USER_ID"];
    NSString *ids = [info objectForKey:@"COURSE_ID"];
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:ids forKey:@"cid"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/delete_user_favorite"];
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
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    
    NSString *f_course_id = [info objectForKey:@"COURSE_ID"];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = f_course_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"myCollectCell";
    MyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (MyCollectTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MyCollectTableViewCell" owner:self options:nil]  lastObject];
        [cell.btn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        ViewRadius(cell.btn, 5);
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *courseName = [info objectForKey:@"COURSE_NAME"];
    NSString *date = [info objectForKey:@"ADD_TIME"];
    cell.label1.text = courseName;
    cell.label2.text = [NSString stringWithFormat:@"%@ 收藏", date];
    
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(delFav:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


@end
