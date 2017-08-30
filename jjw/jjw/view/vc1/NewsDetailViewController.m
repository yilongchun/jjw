//
//  NewsDetailViewController.m
//  jjw
//
//  Created by ylc on 2017/5/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<UIWebViewDelegate>

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _myWebView.backgroundColor = [UIColor whiteColor];
    _myWebView.delegate = self;
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //这里是js，主要目的实现对url的获取
    //    static  NSString * const jsGetImages =
    //    @"function getImages(){\
    //    var objs = document.getElementsByTagName(\"img\");\
    //    var imgScr = '';\
    //    for(var i=0;i<objs.length;i++){\
    //    imgScr = imgScr + objs[i].src + '+';\
    //    };\
    //    return imgScr;\
    //    };";
    //
    //    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    //    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //    mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    //    if (mUrlArray.count >= 2) {
    //        [mUrlArray removeLastObject];
    //    }
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var tagHead =document.documentElement.firstChild;"
//     "var tagMeta = document.createElement(\"meta\");"
//     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
//     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8; initial-scale=1.0, user-scalable=no, width=device-width\");"
//     "tagMeta.setAttribute(\"name\", \"viewport\");"
//     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    
//    //修改图片大小
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth;"
//     "var maxwidth = document.body.offsetWidth - 20;" // UIWebView中显示的图片宽度
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "if(myimg.width > maxwidth){"
//     "oldwidth = myimg.width;"
//     "myimg.width = maxwidth;"
//     "}"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    
    //    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    NSString *defaultFontSize = [ud objectForKey:DEFAULT_FONT_SIZE];
    //    if ([defaultFontSize isEqualToString:@"1"]) {
    //        NSString *fontstr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
    //        [webView stringByEvaluatingJavaScriptFromString:fontstr];
    //    }
    //    if ([defaultFontSize isEqualToString:@"2"]) {
    //
    //    }
    //    if ([defaultFontSize isEqualToString:@"3"]) {
    //        NSString *fontstr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'";
    //        [webView stringByEvaluatingJavaScriptFromString:fontstr];
    //    }
    
    
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.padding = '20px 3%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    
    //    NSNumber *onlyWifiDownloadPic = [ud objectForKey:ONLY_WIFI_DOWNLOAD_PIC];
    //    if ([onlyWifiDownloadPic boolValue]) {
    //        if (netStatus != AFNetworkReachabilityStatusReachableViaWiFi){//仅wifi下载图片
    //            //添加图片可点击js
    //            [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
    //             var imgs=document.getElementsByTagName('img');\
    //             var length=imgs.length;\
    //             for(var i=0;i<length;i++){\
    //             img=imgs[i];\
    //             img.width=0;\
    //             img.height=0;\
    //             img.onclick=function(){\
    //             window.location.href='image-preview:'+this.src}\
    //             }\
    //             }"];
    //            [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
    //        }
    //    }
    
    DLog(@"加载完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"%@",error.localizedDescription);
    //    [self showHintInView:self.view hint:@"加载失败"];
}

@end
