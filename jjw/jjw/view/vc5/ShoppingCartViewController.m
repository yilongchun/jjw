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
#import "UIImage+Color.h"
#import "OpenShareHeader.h"

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
            
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 90)];
//            ViewBorderRadius(tableFooterView, 0, 1, [UIColor blackColor]);
            
            
            UILabel *totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, Main_Screen_Width - 20, 30)];
            [tableFooterView addSubview:totalMoney];
            totalMoney.font = SYSTEMFONT(14);
            totalMoney.textColor = RGB(51, 51, 51);
            totalMoney.text = [NSString stringWithFormat:@"总额:￥%@",[result objectForKey:@"total"]];
            totalMoney.textAlignment = NSTextAlignmentCenter;
            
            CGFloat btnWidth = (Main_Screen_Width - 60)/3;
            //余额支付
            UIButton *yueBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, btnWidth, 32)];
            [yueBtn setTitle:@"余额支付" forState:UIControlStateNormal];
            [yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            yueBtn.titleLabel.font = SYSTEMFONT(15);
            [yueBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(yueBtn, 5);
            yueBtn.tag = 1;
            [yueBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [tableFooterView addSubview:yueBtn];
            
            //支付宝支付
            UIButton *zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yueBtn.frame) + 10, 40, btnWidth, 32)];
            [zhifubaoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
            [zhifubaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            zhifubaoBtn.titleLabel.font = SYSTEMFONT(15);
            [zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(zhifubaoBtn, 5);
            zhifubaoBtn.tag = 2;
            [zhifubaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [tableFooterView addSubview:zhifubaoBtn];
            
            //微信支付
            UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zhifubaoBtn.frame) + 10, 40, btnWidth, 32)];
            [weixinBtn setTitle:@"微信支付" forState:UIControlStateNormal];
            [weixinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            weixinBtn.titleLabel.font = SYSTEMFONT(15);
            [weixinBtn setBackgroundImage:[UIImage imageWithColor:RGB(85, 183, 55) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(weixinBtn, 5);
            weixinBtn.tag = 3;
            [weixinBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [tableFooterView addSubview:weixinBtn];
            
            _myTableView.tableFooterView = tableFooterView;
            
        }else{
            _myTableView.tableFooterView = [[UIView alloc] init];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        [_myTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
    }];
}

-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要购买吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self payByYue];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (btn.tag == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要购买吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self payByAlipay];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (btn.tag == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要购买吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self payByWeixin];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)payByAlipay{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"alipay" forKey:@"pay_type"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/cart_goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *link = [result objectForKey:@"wechat_link"];
            
            [OpenShare AliPay:link Success:^(NSDictionary *message) {
                DLog(@"支付宝支付成功:\n%@",message);
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [self showHintInView:self.view hint:@"支付成功" customView:imageView];
                
                [self loadData];
                
            } Fail:^(NSDictionary *message, NSError *error) {
                DLog(@"支付宝支付失败:\n%@\n%@",message,error);
//                NSString *ret = [message objectForKey:@"ret"];
//                if ([ret isEqualToString:@"-2"]) {
//                    [self showHintInView:self.view hint:@"支付取消"];
//                }else{
//                    [self showHintInView:self.view hint:@"支付失败"];
//                }
                
                NSDictionary *memo = [message objectForKey:@"memo"];
                NSString *memos = [memo objectForKey:@"memo"];
                [self showHintInView:self.view hint:memos];
                
            }];
            
            //            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)payByWeixin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"wechat" forKey:@"pay_type"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/cart_goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *link = [result objectForKey:@"wechat_link"];
            
            [OpenShare WeixinPay:link Success:^(NSDictionary *message) {
                DLog(@"微信支付成功:\n%@",message);
                [self showHintInView:self.view hint:@"支付成功"];
                
                [self loadData];
                
            } Fail:^(NSDictionary *message, NSError *error) {
                DLog(@"微信支付失败:\n%@\n%@",message,error);
                NSString *ret = [message objectForKey:@"ret"];
                if ([ret isEqualToString:@"-2"]) {
                    [self showHintInView:self.view hint:@"支付取消"];
                }else{
                    [self showHintInView:self.view hint:@"支付失败"];
                }
                
            }];
            
            //            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)payByYue{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"balance" forKey:@"pay_type"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/cart_goto_pay"];
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
        DLog(@"%@",error.description);
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
