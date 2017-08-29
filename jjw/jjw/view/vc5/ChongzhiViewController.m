//
//  ChongzhiViewController.m
//  jjw
//
//  Created by ylc on 2017/7/18.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ChongzhiViewController.h"
#import "UIImage+Color.h"
#import <StoreKit/StoreKit.h>
#import "NSObject+Blocks.h"

@interface ChongzhiViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    int index;
    NSMutableArray *dataSource;
}

@end

@implementation ChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 4.设置支付服务
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.title = @"充值";
    dataSource = [NSMutableArray array];
    [dataSource addObject:[NSNumber numberWithInt:6]];
//    [dataSource addObject:[NSNumber numberWithInt:12]];
    [dataSource addObject:[NSNumber numberWithInt:18]];
    [dataSource addObject:[NSNumber numberWithInt:68]];
    [dataSource addObject:[NSNumber numberWithInt:118]];
    [dataSource addObject:[NSNumber numberWithInt:318]];
    [dataSource addObject:[NSNumber numberWithInt:518]];
    [dataSource addObject:[NSNumber numberWithInt:818]];
    [dataSource addObject:[NSNumber numberWithInt:998]];
    [dataSource addObject:[NSNumber numberWithInt:1448]];
    [dataSource addObject:[NSNumber numberWithInt:1998]];
    [dataSource addObject:[NSNumber numberWithInt:2298]];
    [dataSource addObject:[NSNumber numberWithInt:2598]];
    
    [_myTableView reloadData];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 150)];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, Main_Screen_Width - 40, 40)];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(69, 179, 230) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [submitBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(payByApple) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:submitBtn];
    _myTableView.tableFooterView = tableFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    index = indexPath.row;
    [_myTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return dataSource.count;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = SYSTEMFONT(15);
        cell.detailTextLabel.font = SYSTEMFONT(15);
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    if (indexPath.section == 0) {
        NSNumber *money = [dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"充值%d讲解点",[money intValue]];
        if (indexPath.row == index) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"支付:";
        NSNumber *money = [dataSource objectAtIndex:index];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[money floatValue]];
    }
    
    
    return cell;
}



-(void)payByApple{
    // 5.点击按钮的时候判断app是否允许apple支付
    //如果app允许applepay
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"yes");
        // 6.请求苹果后台商品
        [self getRequestAppleProduct];
    }
    else
    {
        NSLog(@"not");
        [self showHintInView:self.view hint:@"不允许苹果支付"];
    }
}

//请求苹果商品
- (void)getRequestAppleProduct
{
    
    [self showHudInView:self.view];
    NSNumber *money = [dataSource objectAtIndex:index];
    NSString *moneyId = [NSString stringWithFormat:@"com.yc.jjw.%d",[money intValue]];
    
    // 7.这里的com.czchat.CZChat01就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
    NSArray *product = [[NSArray alloc] initWithObjects:moneyId,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    // 8.初始化请求
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    // 9.开始请求
    [request start];
}

// 10.接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [self hideHud];
    NSArray *product = response.products;
    
    //如果服务器没有产品
    if([product count] == 0){
        NSLog(@"nothing");
        return;
    }
    
    NSNumber *money = [dataSource objectAtIndex:index];
    NSString *moneyId = [NSString stringWithFormat:@"com.yc.jjw.%d",[money intValue]];
    
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:moneyId]){
            requestProduct = pro;
        }
    }
    
    // 12.发送购买请求
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self hideHud];
    NSLog(@"error:%@", error);
}

//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"信息反馈结束");
}

// 13.监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                
                break;
            default:
                break;
        }
    }
}

// 14.交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString * str=[[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    
    NSString *environment=[self environmentForReceipt:str];
    NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@",environment);
    
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    /**
     20      BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     21      BASE64是可以编码和解码的
     22      */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSLog(@"_____%@",sendString);
    NSURL *StoreURL=nil;
    if ([environment isEqualToString:@"environment=Sandbox"]) {
        
        StoreURL= [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
    }
    else{
        
        StoreURL= [[NSURL alloc] initWithString: @"https://buy.itunes.apple.com/verifyReceipt"];
    }
    //这个二进制数据由服务器进行验证；zl
    NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
    
    NSLog(@"++++++%@",postData);
    NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:StoreURL];
    
    [connectionRequest setHTTPMethod:@"POST"];
    [connectionRequest setTimeoutInterval:50.0];//120.0---50.0zl
    [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [connectionRequest setHTTPBody:postData];
    
    //开始请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"请求成功后的数据:%@",dic);
    //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
    //    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSString *product = transaction.payment.productIdentifier;
    
    NSLog(@"transaction.payment.productIdentifier++++%@",product);
    
    if ([product length] > 0)
    {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        
        NSString *bookid = [tt lastObject];
        
        if([bookid length] > 0)
        {
            
            NSLog(@"打印bookid%@",bookid);
            //这里可以做操作吧用户对应的虚拟物品通过自己服务器进行下发操作,或者在这里通过判断得到用户将会得到多少虚拟物品,在后面（[self getApplePayDataToServerRequsetWith:transaction];的地方）上传上面自己的服务器。
        }
    }
    //此方法为将这一次操作上传给我本地服务器,记得在上传成功过后一定要记得销毁本次操作。调用[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self getApplePayDataToServerRequsetWith:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(NSString * )environmentForReceipt:(NSString * )str
{
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray * arr=[str componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}

-(void)getApplePayDataToServerRequsetWith:(SKPaymentTransaction *)transaction{
    DLog(@"%@",transaction);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSNumber *money = [dataSource objectAtIndex:index];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInt:[money intValue]] forKey:@"money"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"userid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/alipay_call_back/apple_recharge"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
//            NSDictionary *result = [dic objectForKey:@"result"];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];

}

@end
