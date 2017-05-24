//
//  NewsDetailViewController.m
//  jjw
//
//  Created by ylc on 2017/5/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _myWebView.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

-(void)loadData{
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    [parameters setValue:_newsId forKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/news/news_info"];
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSDictionary *result = [dic objectForKey:@"result"];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dataInfo = [result objectForKey:@"data_info"];
            NSString *content = [dataInfo objectForKey:@"CONTENT"];
            [_myWebView loadHTMLString:content baseURL:nil];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.localizedDescription];
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

@end
