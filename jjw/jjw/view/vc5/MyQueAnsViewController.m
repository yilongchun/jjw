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
    int page;
    int pageCount;
}

@end

@implementation MyQueAnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"我的问答";
    self.view.backgroundColor = RGB(245, 245, 245);
    
    ViewBorderRadius(_myTableView, 0, 1, BORDER_COLOR);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _myTableView.tableFooterView = [[UIView alloc] init];
    
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
    if (dataSource == nil) {
        dataSource = [NSMutableArray array];
    }
    [_myTableView.mj_footer resetNoMoreData];
    
    page = 1;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
//    [param setObject:@"1" forKey:@"uid"];
    [param setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_do_demand"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *dataList = [result objectForKey:@"data_list"];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:dataList];
            NSNumber *pageCountNum = [result objectForKey:@"page_count"];
            
            pageCount = [pageCountNum intValue];
            
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
    
    if (page < pageCount) {
        page++;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSSet *set = [NSSet setWithObject:@"text/html"];
        [manager.responseSerializer setAcceptableContentTypes:set];
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
        //    [param setObject:@"1" forKey:@"uid"];
        [param setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/get_do_demand"];
        [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            DLog(@"%@",responseObject);
            NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *result = [dic objectForKey:@"result"];
                NSArray *dataList = [result objectForKey:@"data_list"];
                [dataSource addObjectsFromArray:dataList];
                NSNumber *pageCountNum = [result objectForKey:@"page_count"];
                pageCount = [pageCountNum intValue];
                
                if (page == pageCount) {
                    [_myTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_myTableView.mj_footer endRefreshing];
                }
                
            }else{
                [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            }
            [_myTableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_myTableView.mj_footer endRefreshing];
            DLog(@"%@",error.description);
        }];
    }else{
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data = [dataSource objectAtIndex:indexPath.row];
    NSString *content = [data objectForKey:@"CONTENT"];
    
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(Main_Screen_Width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    
    CGSize titleSize2 = [@"感谢使用点播功能，客服将尽快联系你，请注意关注你的个人主页！" boundingRectWithSize:CGSizeMake(Main_Screen_Width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    
    
    return 8+titleSize.height + 8 + titleSize2.height + 8 + 15 + 8;
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
    
    NSDictionary *data = [dataSource objectAtIndex:indexPath.row];
    NSString *createTime = [data objectForKey:@"CREATE_TIME"];
    NSString *content = [data objectForKey:@"CONTENT"];
    cell.createTime.text = [NSString stringWithFormat:@"提问: %@",createTime];
    cell.content.text = content;
    
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
