//
//  SysMsgViewController.m
//  jjw
//
//  Created by ylc on 2017/10/21.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "SysMsgViewController.h"
#import "MJRefresh.h"
#import "JZNavigationExtension.h"
#import "SysMsgTableViewCell.h"

@interface SysMsgViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation SysMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"系统消息";
    
    self.view.backgroundColor = RGB(245, 245, 245);
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    dataSource = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    _myTableView.mj_footer.automaticallyHidden = YES;
    _myTableView.tableFooterView = [[UIView alloc] init];
    [_myTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/user_message"];
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/user_message"];
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
            [_myTableView.mj_footer endRefreshing];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_footer endRefreshing];
        DLog(@"%@",error.description);
    }];
    
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *CONTENT = [info objectForKey:@"CONTENT"];
    
    CGSize titleSize = [CONTENT boundingRectWithSize:CGSizeMake(Main_Screen_Width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return 8 + titleSize.height + 8 + 16 + 8;
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
    static NSString *CellIdentifier = @"SysMsgCell";
    SysMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (SysMsgTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"SysMsgTableViewCell" owner:self options:nil]  lastObject];
        
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *CONTENT = [info objectForKey:@"CONTENT"];
    NSString *CREATE_TIME = [info objectForKey:@"CREATE_TIME"];
    
    cell.contentLabel.text = CONTENT;
    cell.contentTimeLabel.text = CREATE_TIME;

    return cell;
}


@end
