//
//  PackageClassViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "PackageClassViewController.h"
#import "JZNavigationExtension.h"
#import "MJRefresh.h"
#import "PackageClassTableViewCell.h"
#import "NSDictionary+Category.h"
#import "PackageClassDetailTableViewCell.h"
#import "ClassDetailViewController.h"

@interface PackageClassViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *table1;
    UITableView *table2;
    UITableView *table3;
    
    NSMutableArray *dataSource1;
    NSMutableArray *dataSource2;
    NSMutableArray *dataSource3;
    
    int page1;
    int page2;
    int page3;
}

@end

@implementation PackageClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"打包课程";

    [_mySegment addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    
    dataSource1 = [NSMutableArray array];
    dataSource2 = [NSMutableArray array];
    dataSource3 = [NSMutableArray array];
    
   
    
    
    [self showTable1];
}

-(void)loadData1{
    page1 = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page1] forKey:@"page"];
    [param setObject:@"SUCCESS" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table1.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [table1.mj_footer resetNoMoreData];
            [dataSource1 removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource1 addObject:info];
            }
//            [dataSource1 addObjectsFromArray:array];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page1 == [pageTotal intValue]) {
                [table1.mj_footer endRefreshingWithNoMoreData];
            }
            [table1 reloadData];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table1.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadMore1{
    page1++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page1] forKey:@"page"];
    [param setObject:@"SUCCESS" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table1.mj_footer endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource1 addObject:info];
            }
//            [dataSource1 addObjectsFromArray:array];
            [table1 reloadData];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page1 >= [pageTotal intValue]) {
                [table1.mj_footer endRefreshingWithNoMoreData];
            }else{
                [table1.mj_footer endRefreshing];
            }
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table1.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadData2{
    page2 = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page2] forKey:@"page"];
    [param setObject:@"INIT" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table2.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
        
            
            
            [table2.mj_footer resetNoMoreData];
            [dataSource2 removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource2 addObject:info];
            }
//            [dataSource2 addObjectsFromArray:array];
            [table2 reloadData];
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page2 == [pageTotal intValue]) {
                [table2.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table2.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadMore2{
    page2++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page2] forKey:@"page"];
    [param setObject:@"INIT" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table2.mj_footer endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource2 addObject:info];
            }
//            [dataSource2 addObjectsFromArray:array];
            [table2 reloadData];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page2 >= [pageTotal intValue]) {
                [table2.mj_footer endRefreshingWithNoMoreData];
            }else{
                [table2.mj_footer endRefreshing];
            }
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table2.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadData3{
    page3 = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page3] forKey:@"page"];
    [param setObject:@"CANCEL" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table3.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [table3.mj_footer resetNoMoreData];
            [dataSource3 removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource3 addObject:info];
            }
//            [dataSource3 addObjectsFromArray:array];
            [table3 reloadData];
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page3 == [pageTotal intValue]) {
                [table3.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table3.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadMore3{
    page3++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    [param setObject:[NSNumber numberWithInt:page3] forKey:@"page"];
    [param setObject:@"CANCEL" forKey:@"type"];//订单状态 SUCCESS已支付 INIT未支付 CANCEL已取消 （大写）
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_order_pack_course"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [table3.mj_footer endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [[array objectAtIndex:i] cleanNull];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
                [info setObject:@"0" forKey:@"expand"];
                [dataSource3 addObject:info];
            }
//            [dataSource3 addObjectsFromArray:array];
            [table3 reloadData];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page3 >= [pageTotal intValue]) {
                [table3.mj_footer endRefreshingWithNoMoreData];
            }else{
                [table3.mj_footer endRefreshing];
            }
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [table3.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeSeg:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        [self showTable1];
    }
    if (seg.selectedSegmentIndex == 1) {
        [self showTable2];
    }
    if (seg.selectedSegmentIndex == 2) {
        [self showTable3];
    }
}

-(void)showTable1{
    if (!table1) {
        table1 = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySegment.frame) + 10, Main_Screen_Width - 20, Main_Screen_Height - CGRectGetMaxY(_mySegment.frame) - 20) style:UITableViewStyleGrouped];
        table1.delegate = self;
        table1.dataSource = self;
        table1.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:table1];
        ViewBorderRadius(table1, 0, 1, BORDER_COLOR);
        
        table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData1];
        }];
        
        table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMore1];
        }];
        
        [table1.mj_header beginRefreshing];
    }
    [self.view bringSubviewToFront:table1];
    
}

-(void)showTable2{
    if (!table2) {
        table2 = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySegment.frame) + 10, Main_Screen_Width - 20, Main_Screen_Height - CGRectGetMaxY(_mySegment.frame) - 20) style:UITableViewStyleGrouped];
        table2.delegate = self;
        table2.dataSource = self;
        table2.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:table2];
        ViewBorderRadius(table2, 0, 1, BORDER_COLOR);
        
        table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData2];
        }];
        
        table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMore2];
        }];
        
        [table2.mj_header beginRefreshing];
    }
    [self.view bringSubviewToFront:table2];
}

-(void)showTable3{
    if (!table3) {
        table3 = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySegment.frame) + 10, Main_Screen_Width - 20, Main_Screen_Height - CGRectGetMaxY(_mySegment.frame) - 20) style:UITableViewStyleGrouped];
        table3.delegate = self;
        table3.dataSource = self;
        table3.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:table3];
        ViewBorderRadius(table3, 0, 1, BORDER_COLOR);
        
        table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData3];
        }];
        
        table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMore3];
        }];
        
        [table3.mj_header beginRefreshing];
    }
    [self.view bringSubviewToFront:table3];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mySegment.selectedSegmentIndex == 0) {
        if (indexPath.row == 0) {
            NSMutableDictionary *info = [dataSource1 objectAtIndex:indexPath.section];
            NSString *expand = [info objectForKey:@"expand"];
            if ([expand isEqualToString:@"0"]) {
                [info setObject:@"1" forKey:@"expand"];
            }else if ([expand isEqualToString:@"1"]){
                [info setObject:@"0" forKey:@"expand"];
            }
            [table1 reloadData];
        }else{
            NSMutableDictionary *info = [dataSource1 objectAtIndex:indexPath.section];
            NSArray *course_list = [info objectForKey:@"course_list"];
            NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
            NSString *COURSE_ID = [detail objectForKey:@"COURSE_ID"];
            ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
            vc.courseId = COURSE_ID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (_mySegment.selectedSegmentIndex == 1) {
        if (indexPath.row == 0) {
            NSMutableDictionary *info = [dataSource2 objectAtIndex:indexPath.section];
            NSString *expand = [info objectForKey:@"expand"];
            if ([expand isEqualToString:@"0"]) {
                [info setObject:@"1" forKey:@"expand"];
            }else if ([expand isEqualToString:@"1"]){
                [info setObject:@"0" forKey:@"expand"];
            }
            [table2 reloadData];
        }else{
            NSMutableDictionary *info = [dataSource2 objectAtIndex:indexPath.section];
            NSArray *course_list = [info objectForKey:@"course_list"];
            NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
            NSString *COURSE_ID = [detail objectForKey:@"COURSE_ID"];
            ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
            vc.courseId = COURSE_ID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (_mySegment.selectedSegmentIndex == 2) {
        if (indexPath.row == 0) {
            NSMutableDictionary *info = [dataSource3 objectAtIndex:indexPath.section];
            NSString *expand = [info objectForKey:@"expand"];
            if ([expand isEqualToString:@"0"]) {
                [info setObject:@"1" forKey:@"expand"];
            }else if ([expand isEqualToString:@"1"]){
                [info setObject:@"0" forKey:@"expand"];
            }
            [table3 reloadData];
        }else{
            NSMutableDictionary *info = [dataSource3 objectAtIndex:indexPath.section];
            NSArray *course_list = [info objectForKey:@"course_list"];
            NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
            NSString *COURSE_ID = [detail objectForKey:@"COURSE_ID"];
            ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
            vc.courseId = COURSE_ID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_mySegment.selectedSegmentIndex == 0) {
        return dataSource1.count;
    }
    if (_mySegment.selectedSegmentIndex == 1) {
        return dataSource2.count;
    }
    if (_mySegment.selectedSegmentIndex == 2) {
        return dataSource3.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_mySegment.selectedSegmentIndex == 0) {
        NSDictionary *info = [dataSource1 objectAtIndex:section];
        NSString *expand = [info objectForKey:@"expand"];
        if ([expand isEqualToString:@"0"]) {
            return 1;
        }else if ([expand isEqualToString:@"1"]){
            NSArray *course_list = [info objectForKey:@"course_list"];
            return course_list.count+1;
        }
        return 0;
    }
    if (_mySegment.selectedSegmentIndex == 1) {
        NSDictionary *info = [dataSource2 objectAtIndex:section];
        NSString *expand = [info objectForKey:@"expand"];
        if ([expand isEqualToString:@"0"]) {
            return 1;
        }else if ([expand isEqualToString:@"1"]){
            NSArray *course_list = [info objectForKey:@"course_list"];
            return course_list.count+1;
        }
        return 0;
    }
    if (_mySegment.selectedSegmentIndex == 2) {
        NSDictionary *info = [dataSource3 objectAtIndex:section];
        NSString *expand = [info objectForKey:@"expand"];
        if ([expand isEqualToString:@"0"]) {
            return 1;
        }else if ([expand isEqualToString:@"1"]){
            NSArray *course_list = [info objectForKey:@"course_list"];
            return course_list.count+1;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_mySegment.selectedSegmentIndex == 0) {
        NSDictionary *info = [[dataSource1 objectAtIndex:indexPath.section] cleanNull];
        NSString *expand = [info objectForKey:@"expand"];
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"packageClassCell";
            PackageClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell= (PackageClassTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassTableViewCell" owner:self options:nil]  lastObject];
            }
            NSString *f_order_sn = [info objectForKey:@"f_order_sn"];
            NSString *f_desc = [info objectForKey:@"f_desc"];
            NSString *f_expire_time = [info objectForKey:@"f_create_time"];
            NSString *f_money = [info objectForKey:@"f_money"];
            cell.orderNo.text = f_order_sn;
            cell.desLabel.text = f_desc;
            cell.dateLabel.text = f_expire_time;
            cell.priceLabel.text = [NSString stringWithFormat:@"讲解点%@",f_money];
            return cell;
        }else{
            if ([expand isEqualToString:@"1"]){
                NSArray *course_list = [info objectForKey:@"course_list"];
                NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
                
                static NSString *CellIdentifier = @"packageClassDetailCell";
                PackageClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell= (PackageClassDetailTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassDetailTableViewCell" owner:self options:nil]  lastObject];
                }
                
                NSString *COURSE_NAME = [detail objectForKey:@"COURSE_NAME"];
                NSString *teacher = [detail objectForKey:@"teacher"];
                NSString *expire_time = [detail objectForKey:@"expire_time"];
                NSNumber *is_expired = [info objectForKey:@"is_expired"];
                
                cell.titleLabel.text = COURSE_NAME;
                cell.teacherLabel.text = [NSString stringWithFormat:@"讲师:%@",teacher];
                if ([is_expired boolValue]) {
                    cell.dateLabel.text = @"已过期";
                    cell.dateLabel.textColor = [UIColor redColor];
                }else{
                    cell.dateLabel.textColor = RGB(102, 102, 102);
                    cell.dateLabel.text = expire_time;
                }
                return cell;
            }
        }
    }
    if (_mySegment.selectedSegmentIndex == 1) {
        NSDictionary *info = [[dataSource2 objectAtIndex:indexPath.section] cleanNull];
        NSString *expand = [info objectForKey:@"expand"];
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"packageClassCell";
            PackageClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell= (PackageClassTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassTableViewCell" owner:self options:nil]  lastObject];
            }
            NSString *f_order_sn = [info objectForKey:@"f_order_sn"];
            NSString *f_desc = [info objectForKey:@"f_desc"];
            NSString *f_expire_time = [info objectForKey:@"f_create_time"];
            NSString *f_money = [info objectForKey:@"f_money"];
            cell.orderNo.text = f_order_sn;
            cell.desLabel.text = f_desc;
            cell.dateLabel.text = f_expire_time;
            cell.priceLabel.text = [NSString stringWithFormat:@"讲解点%@",f_money];
            return cell;
        }else{
            if ([expand isEqualToString:@"1"]){
                NSArray *course_list = [info objectForKey:@"course_list"];
                NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
                
                static NSString *CellIdentifier = @"packageClassDetailCell";
                PackageClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell= (PackageClassDetailTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassDetailTableViewCell" owner:self options:nil]  lastObject];
                }
                
                NSString *COURSE_NAME = [detail objectForKey:@"COURSE_NAME"];
                NSString *teacher = [detail objectForKey:@"teacher"];
                NSString *expire_time = [detail objectForKey:@"expire_time"];
                NSNumber *is_expired = [info objectForKey:@"is_expired"];
                
                cell.titleLabel.text = COURSE_NAME;
                cell.teacherLabel.text = [NSString stringWithFormat:@"讲师:%@",teacher];
                if ([is_expired boolValue]) {
                    cell.dateLabel.text = @"已过期";
                    cell.dateLabel.textColor = [UIColor redColor];
                }else{
                    cell.dateLabel.textColor = RGB(102, 102, 102);
                    cell.dateLabel.text = expire_time;
                }
                return cell;
            }
        }
    }
    if (_mySegment.selectedSegmentIndex == 2) {
        NSDictionary *info = [[dataSource3 objectAtIndex:indexPath.section] cleanNull];
        NSString *expand = [info objectForKey:@"expand"];
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"packageClassCell";
            PackageClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell= (PackageClassTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassTableViewCell" owner:self options:nil]  lastObject];
            }
            NSString *f_order_sn = [info objectForKey:@"f_order_sn"];
            NSString *f_desc = [info objectForKey:@"f_desc"];
            NSString *f_expire_time = [info objectForKey:@"f_create_time"];
            NSString *f_money = [info objectForKey:@"f_money"];
            cell.orderNo.text = f_order_sn;
            cell.desLabel.text = f_desc;
            cell.dateLabel.text = f_expire_time;
            cell.priceLabel.text = [NSString stringWithFormat:@"讲解点%@",f_money];
            return cell;
        }else{
            if ([expand isEqualToString:@"1"]){
                NSArray *course_list = [info objectForKey:@"course_list"];
                NSDictionary *detail = [[course_list objectAtIndex:indexPath.row - 1] cleanNull];
                
                static NSString *CellIdentifier = @"packageClassDetailCell";
                PackageClassDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell= (PackageClassDetailTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PackageClassDetailTableViewCell" owner:self options:nil]  lastObject];
                }
                
                NSString *COURSE_NAME = [detail objectForKey:@"COURSE_NAME"];
                NSString *teacher = [detail objectForKey:@"teacher"];
                NSString *expire_time = [detail objectForKey:@"expire_time"];
                NSNumber *is_expired = [info objectForKey:@"is_expired"];
                
                cell.titleLabel.text = COURSE_NAME;
                cell.teacherLabel.text = [NSString stringWithFormat:@"讲师:%@",teacher];
                if ([is_expired boolValue]) {
                    cell.dateLabel.text = @"已过期";
                    cell.dateLabel.textColor = [UIColor redColor];
                }else{
                    cell.dateLabel.textColor = RGB(102, 102, 102);
                    cell.dateLabel.text = expire_time;
                }
                return cell;
            }
        }
    }
    
    return nil;
}

@end
