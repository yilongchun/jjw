//
//  MyClassViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MyClassViewController.h"
#import "JZNavigationExtension.h"
#import "MyClassTableViewCell.h"
#import "MJRefresh.h"
#import "ClassDetailViewController.h"

@interface MyClassViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation MyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"我的课程";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    dataSource = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    _myTableView.tableFooterView = [[UIView alloc] init];
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer resetNoMoreData];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            [_myTableView reloadData];
            DLog(@"%@",result);
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page == [pageTotal intValue]) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadMore{
    page ++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            [dataSource addObjectsFromArray:array];
            [_myTableView reloadData];
            DLog(@"%@",result);
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page >= [pageTotal intValue]) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_myTableView.mj_footer endRefreshing];
            }
            
        }else{
            [_myTableView.mj_header endRefreshing];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
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

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *f_course_id = [info objectForKey:@"f_course_id"];
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
    static NSString *CellIdentifier = @"myClassCell";
    MyClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (MyClassTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MyClassTableViewCell" owner:self options:nil]  lastObject];
        
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *courseName = [info objectForKey:@"f_course_name"];
    NSString *date = [info objectForKey:@"f_expire_time"];
    NSString *teacher = [info objectForKey:@"teacher"];
    NSNumber *is_expired = [info objectForKey:@"is_expired"];
    
    cell.titleLabel.text = courseName;
    cell.teacherLabel.text = [NSString stringWithFormat:@"讲师:%@", teacher];
    
    if ([is_expired boolValue]) {
        cell.dateLabel.text = @"已过期";
        cell.dateLabel.textColor = [UIColor redColor];
    }else{
        cell.dateLabel.textColor = RGB(102, 102, 102);
        cell.dateLabel.text = date;
    }
    
    return cell;
}

@end
