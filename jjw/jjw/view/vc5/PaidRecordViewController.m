//
//  PaidRecordViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "PaidRecordViewController.h"
#import "JZNavigationExtension.h"
#import "MJRefresh.h"
#import "PaidRecordTableViewCell.h"

@interface PaidRecordViewController (){
    NSMutableArray *dataSource;
}

@end

@implementation PaidRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.title = @"充值记录";
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user_center/user_recharge_log"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSArray *array = [result objectForKey:@"data_list"];
            
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            [_myTableView reloadData];
            DLog(@"%@",result);
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
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
    static NSString *CellIdentifier = @"paidRecordCell";
    PaidRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (PaidRecordTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PaidRecordTableViewCell" owner:self options:nil]  lastObject];
        
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *order = [info objectForKey:@"order_sn"];
    NSString *payType = [info objectForKey:@"pay_type"];
    NSString *status = [info objectForKey:@"status"];
    NSString *money = [info objectForKey:@"money"];
    NSString *time = [info objectForKey:@"time"];
    
    cell.orderLabel.text = order;
    cell.payTypeLabel.text = status;
    if ([status isEqualToString:@"支付失败"]) {
        cell.payTypeLabel.textColor = RGB(204, 204, 204);
    }else if ([status isEqualToString:@"支付成功"]){
        cell.payTypeLabel.textColor = RGB(0, 128, 0);
    }
    cell.statusLabel.text = [NSString stringWithFormat:@"%@：",payType];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",money];
    cell.timeLabel.text = time;
    
    
    
    return cell;
}

@end
