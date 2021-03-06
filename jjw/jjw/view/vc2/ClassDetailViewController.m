//
//  ClassDetailViewController.m
//  jjw
//
//  Created by ylc on 2017/4/11.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "LGSegment.h"
#import "TeacherHomeViewController.h"
#import "UIImageView+AFNetworking.h"
//#import "SRVideoPlayer.h"
#import "NSObject+Blocks.h"
#import "OpenShareHeader.h"
#import "Util.h"
#import "UIViewController+RegisterRandomAccount.h"
#import "SkinVideoViewController.h"
#import "NSDictionary+Category.h"

@interface ClassDetailViewController ()<SegmentDelegate>{
    NSDictionary *courseInfo;
    NSMutableArray *likeList;
    NSMutableArray *pinglunList;
    UITextView *commentTx;
    
    
    
}

@property (nonatomic, strong) SkinVideoViewController *videoPlayer;

//@property (nonatomic, strong) SRVideoPlayer *videoPlayer;

@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;

@end

@implementation ClassDetailViewController{
    UIView *v1;
    UIView *v2;
    UIView *v3;
    
//    BOOL _barShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.jz_navigationBarBackgroundHidden = NO;
    self.title = @"课程详情";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collection)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    likeList = [NSMutableArray array];
    pinglunList = [NSMutableArray array];
    
    _myScrollView.bounces = NO;
    
    
    
    
    
    
    
    
//    CGFloat width = self.view.bounds.size.width;
//    if (!self.videoPlayer) {
//        self.videoPlayer = [[SkinVideoViewController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
//    }
//    [self.view addSubview:self.videoPlayer.view];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.videoPlayer setFullscreenBlock:^{
//        NSLog(@"全屏了");
//        [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
//    }];
//    [self.videoPlayer setShrinkscreenBlock:^{
//        NSLog(@"小屏");
//        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
//    }];
//    [self.videoPlayer setVid:@"92b7ec4bd0970baa1614073eea0cbd90_9"];
    
    
    
    if (!self.videoPlayer) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoPlayer = [[SkinVideoViewController alloc] initWithFrame:CGRectMake(0, 44, width, width*(9.0/16.0))];
        [self.videoPlayer setEnableDanmuDisplay:NO];
        [self.videoPlayer enableDanmu:NO];
        __weak typeof(self)weakSelf = self;
        [self.videoPlayer setDimissCompleteBlock:^{
            [weakSelf.videoPlayer stop];
            weakSelf.isPresented = NO;
//            weakSelf.videoPlayer = nil;
        }];
        [self.videoPlayer setFullscreenBlock:^{
            NSLog(@"全屏了");
            if (weakSelf.isPresented) {
                [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
                weakSelf.videoPlayer.videoControl.closeButton.hidden = YES;
            }
            
        }];
        [self.videoPlayer setShrinkscreenBlock:^{
            NSLog(@"小屏");
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
            weakSelf.videoPlayer.videoControl.closeButton.hidden = NO;
        }];
        [self.videoPlayer setWatchCompletedBlock:^{
            weakSelf.isPresented = NO;
            NSLog(@"观看结束");
        }];
        
    }
    
    
    [self loadData];
//    [self loadPinglun];
}

//收藏
-(void)collection{
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_courseId forKey:@"id"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (userInfo) {
        [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    }
    
    //    [param setObject:@"1" forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/add_course_favorite"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}




//添加学习记录
-(void)addStudyLog:(NSString *)uid course_id:(NSString *)course_id{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:uid forKey:@"uid"];
    [param setObject:course_id forKey:@"course_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/add_study_log"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        DLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
//            NSDictionary *result = [dic objectForKey:@"result"];
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
//        DLog(@"%@",error.localizedDescription);
    }];
}

- (void)showVideoPlayer {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        
        
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        
        return;
    }
    NSDictionary *course_info = [courseInfo objectForKey:@"course_info"];
    NSNumber *isBuy = [courseInfo objectForKey:@"is_buy"];
    NSString *expire_time = [courseInfo objectForKey:@"expire_time"];
    
    
    
    
    
    if ([isBuy boolValue] && expire_time && ![expire_time isKindOfClass:[NSNull class]] && ![expire_time isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expireDate = [dateFormatter dateFromString:expire_time];
        
        if ([expireDate compare:[NSDate date]] > 0) {
            NSString *vid = [course_info objectForKey:@"VIDEO_URL"];
            
//            [self.view addSubview:self.videoPlayer.view];
//            [self.videoPlayer setVid:vid];
            
        
            
            
////            [self.videoPlayer setHeadTitle:[course_info objectForKey:@"TITLE"]];
            [self.videoPlayer showInWindow];
//            NSLog(@"vid:%@",vid);
            [self.videoPlayer setVid:vid];
            self.isPresented = YES;
            
//            self.edgesForExtendedLayout=UIRectEdgeNone;
            
//            CGFloat width = self.view.bounds.size.width;
//            if (!self.videoPlayer) {
//                self.videoPlayer = [[SkinVideoViewController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
//            }
//            [self.videoPlayer setHeadTitle:[course_info objectForKey:@"TITLE"]];
//            UIImage*logo = [UIImage imageNamed:@"pvlogo.png"];
//            [self.videoPlayer setLogo:logo location:PvLogoLocationBottomRight size:CGSizeMake(70,30) alpha:0.8];
//            
//            [self.view addSubview:self.videoPlayer.view];
//            //	CGSize playerSize = self.videoPlayer.frame.size;
//            //	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, playerSize.width, playerSize.height + 20)];
//            //	[self.view addSubview:contentView];
//            //	contentView.backgroundColor = [UIColor blackColor];
//            //	[contentView addSubview:self.videoPlayer.view];
//            [self.videoPlayer setParentViewController:self];
//            [self.videoPlayer setNavigationController:self.navigationController];
//            //    [self.videoPlayer setVid:self.video.vid];
//            [self.videoPlayer setVid:vid];
//            //直接跳到上一次播放位置
//            //[self.videoPlayer setWatchStartTime:30];
//            
//            [self.videoPlayer rollInfo:@"info" font:[UIFont systemFontOfSize:10] color:[UIColor whiteColor] withDuration:3.0];
            
            
//            [self showHudInView:self.view];
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            NSMutableSet *set = [NSMutableSet setWithObjects:@"application/x-javascript",@"text/javascript", nil];
//            [manager.responseSerializer setAcceptableContentTypes:set];
//            
//            
//            NSString *url = [NSString stringWithFormat:@"http://player.polyv.net/videojson/%@.js",vid];
//            [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//                [self hideHud];
//                //        DLog(@"%@",responseObject);
//                NSArray *mp4Arr = [responseObject objectForKey:@"mp4"];
//                if (mp4Arr.count > 0) {
//                    NSString *mp4 = [mp4Arr objectAtIndex:0];
//                    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 250)];
//                    [self.view addSubview:playerView];
//                    _videoPlayer = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:mp4] playerView:playerView playerSuperView:playerView.superview];
//                    _videoPlayer.videoName = [course_info objectForKey:@"TITLE"];
//                    _videoPlayer.playerEndAction = SRVideoPlayerEndActionLoop;
//                    
//                    [_videoPlayer play];
//                    
//                    
                    NSString *uid = [userInfo objectForKey:@"USER_ID"];
                    [self addStudyLog:uid course_id:_courseId];
//                    
//                    
//                }else{
//                    [self showHintInView:self.view hint:@"获取视频失败"];
//                }
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                [self hideHud];
//                DLog(@"%@",error.description);
//                [self showHintInView:self.view hint:error.localizedDescription];
//            }];
        }else{
            [self showHintInView:self.view hint:@"需要购买才能观看"];
            return;
        }
    }else{
        [self showHintInView:self.view hint:@"需要购买才能观看"];
        return;
    }
    
}

//课程详情
-(void)loadData{
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_courseId forKey:@"id"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (userInfo) {
        [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    }
    
    //    [param setObject:@"1" forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_course_info"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            courseInfo = result;
            [self loadLike];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

//评论
-(void)addComment{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/add_course_comment"];
    
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    [parameters setValue:_courseId forKey:@"id"];
    [parameters setValue:commentTx.text forKey:@"content"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (userInfo) {
        [parameters setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    }else{
        [self showHintInView:self.view hint:@"请先登录"];
        return;
    }
    
    if ([commentTx.text isEqualToString:@""]) {
        [self showHintInView:self.view hint:@"请填写内容"];
        return;
    }
    [self.view endEditing:YES];
    
    [self showHudInView:self.view];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        DLog(@"%@",dic);
        if ([code isEqualToString:@"200"]) {
//            NSDictionary *result = [dic objectForKey:@"result"];
            commentTx.text = @"";
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        [self showHintInView:self.view hint:error.description];
    }];
    
}

//猜你喜欢
-(void)loadLike{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_courseId forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_like"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        DLog(@"get_like:%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSArray *array = [result objectForKey:@"data_list"];
            [likeList addObjectsFromArray:array];
           
        }else{
//            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        [self loadPinglun];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DLog(@"%@",error.description);
    }];
}

//评论列表
-(void)loadPinglun{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_courseId forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_comment_list"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        DLog(@"pinglun:%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            [pinglunList removeAllObjects];
            NSArray *array = [result objectForKey:@"data_list"];
            [pinglunList addObjectsFromArray:array];
            
        }else{
//            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        [self initUI];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        DLog(@"%@",error.description);
    }];
}

-(void)btnClick:(UIButton *)btn{
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_open"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSNumber *code = [result objectForKey:@"code"];
            if ([code boolValue]) {
                [self btnClick2:btn flag:[code boolValue]];
            }else{
                [self btnClick2:btn flag:[code boolValue]];
            }
        }else{
            [self btnClick2:btn flag:YES];
        }
        DLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
        [self btnClick2:btn flag:YES];
    }];
}

-(void)btnClick2:(UIButton *)btn flag:(BOOL)flag{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        NSString *message = @"";
        if (flag) {
            message = @"游客登录购买系统为当前设备随机分配账号登录购买";
        }else{
            message = @"需要登录购买讲解点";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买讲解点" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登录购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performBlock:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } afterDelay:1.5];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"游客登录购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *randomAccount = [Util generateRandomString];
            DLog(@"%@",randomAccount);
            [self registerRandomAccount:randomAccount];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        if (flag) {
            [alert addAction:action2];
        }
        
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSDictionary *course_info = [courseInfo objectForKey:@"course_info"];
    NSString *currentPrice = [course_info objectForKey:@"CURRENT_PRICE"];
    NSString *message = [NSString stringWithFormat:@"确认花费%@讲解点购买本课程吗？",currentPrice];
    
    if (btn.tag == 1) {//余额支付
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self payByYue];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (btn.tag == 2){//支付宝支付
        //        NSString *apiUrl = @"";
        //        //网络请求不要阻塞UI，仅限Demo
        //        NSData *data=[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]] returningResponse:nil error:nil];
        //        NSString *link=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self payByAlipay];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (btn.tag == 3){//微信支付
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self weixinPay];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (btn.tag == 99){//打包购买
        
        
        NSString *pack_price = [course_info objectForKey:@"pack_price"];
        message = [NSString stringWithFormat:@"确认花费%@讲解点购买本课程吗？",pack_price];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self alipayPayByPackage];
//            }];
//            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self weixinPayByPackage];
//            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"余额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self yuePayByPackage];
            }];
            UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:action1];
//            [alert addAction:action2];
            [alert addAction:action3];
            [alert addAction:action4];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)yuePayByPackage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"balance" forKey:@"pay_type"];
    NSDictionary *pack = [courseInfo objectForKey:@"pack"];
    if (pack) {
        NSString *subjectId = [pack objectForKey:@"SUBJECT_ID"];
        [param setObject:subjectId forKey:@"subject_id"];
    }else{
        [self showHintInView:self.view hint:@"打包购买失败"];
        return;
    }
    
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment_pack/goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
//            NSDictionary *result = [dic objectForKey:@"result"];
            
            [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self loadData];
//            [self loadPinglun];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)alipayPayByPackage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"alipay" forKey:@"pay_type"];
    NSDictionary *pack = [courseInfo objectForKey:@"pack"];
    if (pack) {
        NSString *subjectId = [pack objectForKey:@"SUBJECT_ID"];
        [param setObject:subjectId forKey:@"subject_id"];
    }else{
        [self showHintInView:self.view hint:@"打包购买失败"];
        return;
    }
    
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment_pack/goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *link = [result objectForKey:@"alipay_link"];
            
            [OpenShare AliPay:link Success:^(NSDictionary *message) {
                DLog(@"支付宝支付成功:\n%@",message);
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [self showHintInView:self.view hint:@"支付成功" customView:imageView];
                
                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self loadData];
//                [self loadPinglun];
                
                
            } Fail:^(NSDictionary *message, NSError *error) {
                DLog(@"微信支付失败:\n%@\n%@",message,error);
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

-(void)weixinPayByPackage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"wechat" forKey:@"pay_type"];
    NSDictionary *pack = [courseInfo objectForKey:@"pack"];
    if (pack) {
        NSString *subjectId = [pack objectForKey:@"SUBJECT_ID"];
        [param setObject:subjectId forKey:@"subject_id"];
    }else{
        [self showHintInView:self.view hint:@"打包购买失败"];
        return;
    }
    
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment_pack/goto_pay"];
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
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [self showHintInView:self.view hint:@"支付成功" customView:imageView];
                
                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self loadData];
//                [self loadPinglun];
                
                
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

-(void)payByAlipay{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"alipay" forKey:@"pay_type"];
    [param setObject:_courseId forKey:@"course_id"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *link = [result objectForKey:@"alipay_link"];
            
            [OpenShare AliPay:link Success:^(NSDictionary *message) {
                DLog(@"支付宝支付成功:\n%@",message);
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [self showHintInView:self.view hint:@"支付成功" customView:imageView];
                
                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self loadData];
//                [self loadPinglun];
                
                
            } Fail:^(NSDictionary *message, NSError *error) {
                DLog(@"支付宝支付失败:\n%@\n%@",message,error);
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

-(void)weixinPay{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"wechat" forKey:@"pay_type"];
    [param setObject:_courseId forKey:@"course_id"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/goto_pay"];
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
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [self showHintInView:self.view hint:@"支付成功" customView:imageView];
                
                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self loadData];
//                [self loadPinglun];
                
                
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

//余额支付
-(void)payByYue{
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_open"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSNumber *code = [result objectForKey:@"code"];
            if ([code boolValue]) {
                [self payByYue2:[code boolValue]];
            }else{
                [self payByYue2:[code boolValue]];
            }
        }else{
            [self payByYue2:YES];
        }
        DLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
        [self payByYue2:YES];
    }];
}

-(void)payByYue2:(BOOL)flag{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        NSString *message = @"";
        if (flag) {
            message = @"游客登录购买系统为当前设备随机分配账号登录购买";
        }else{
            message = @"需要登录购买讲解点";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买讲解点" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登录购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performBlock:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } afterDelay:1.5];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"游客登录购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *randomAccount = [Util generateRandomString];
            DLog(@"%@",randomAccount);
            [self registerRandomAccount:randomAccount];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        if (flag) {
            [alert addAction:action2];
        }
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"balance" forKey:@"pay_type"];
    [param setObject:_courseId forKey:@"course_id"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment/goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            
            
            [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self loadData];
            //            [self loadPinglun];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo" object:nil userInfo:nil]];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

//添加购物车
-(void)addGoodToCard{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"4"}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } afterDelay:1.5];
        return;
    }
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_courseId forKey:@"course_id"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/cart/add_good_to_cart"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *moneyTotal = [result objectForKey:@"money_total"];
            NSString *numTotal = [result objectForKey:@"num_total"];
            
            NSString *message = [NSString stringWithFormat:@"购物车总数:%@ , 总金额:%@",numTotal,moneyTotal];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"msg"] message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
//            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
            
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)initUI{
    CGFloat videoHeight = (Main_Screen_Width - 20)*0.6;
    
    NSDictionary *course_info = [courseInfo objectForKey:@"course_info"];
    NSString *LOGO = [course_info objectForKey:@"LOGO"];
    //添加视频
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width - 20, videoHeight)];
    [image setImageWithURL:[NSURL URLWithString:LOGO]];
    ViewRadius(image, 10);
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer)];
    [image addGestureRecognizer:tap];
    
    
    
    UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    [playImage setFrame:CGRectMake((CGRectGetWidth(image.frame) - CGRectGetWidth(playImage.frame))/2, videoHeight/2 - CGRectGetHeight(playImage.frame)/2, CGRectGetWidth(playImage.frame), CGRectGetHeight(playImage.frame))];
    [image addSubview:playImage];
    
    [_myScrollView addSubview:image];
    
    NSNumber *isBuy = [courseInfo objectForKey:@"is_buy"];
    NSString *expire_time = [courseInfo objectForKey:@"expire_time"];
    
    CGFloat maxY = 10 + videoHeight;
    
    if ([isBuy boolValue] && expire_time && ![expire_time isKindOfClass:[NSNull class]] && ![expire_time isEqualToString:@""]) {
        
    }else{
        //打包课程
        NSDictionary *pack = [courseInfo objectForKey:@"pack"];
        if (pack) {
            NSNumber *isPack = [pack objectForKey:@"is_pack"];
            if ([isPack boolValue]) {
                NSString *price = [pack objectForKey:@"price"];
                NSNumber *packNum = [pack objectForKey:@"pack_num"];
                
                UIButton *packageBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - 80)/2, 10 + videoHeight + 10, 80, 30)];
                [packageBtn setTitle:@"打包购买" forState:UIControlStateNormal];
                [packageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                packageBtn.titleLabel.font = SYSTEMFONT(15);
                [packageBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                ViewRadius(packageBtn, 5);
                packageBtn.tag = 99;
                [packageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_myScrollView addSubview:packageBtn];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(packageBtn.frame), CGRectGetMinY(packageBtn.frame)+6, 0, 0)];
                priceLabel.text = [NSString stringWithFormat:@"讲解点%@",price];
                priceLabel.textColor = RGB(255, 153, 0);
                priceLabel.font = BOLDSYSTEMFONT(14);
                [priceLabel sizeToFit];
                [_myScrollView addSubview:priceLabel];
                
                UILabel *courseLabel = [[UILabel alloc] init];
                courseLabel.text = [NSString stringWithFormat:@"本册%d节",[packNum intValue]];
                courseLabel.font = SYSTEMFONT(14);
                [courseLabel sizeToFit];
                [courseLabel setFrame:CGRectMake(CGRectGetMinX(packageBtn.frame) - CGRectGetWidth(courseLabel.frame) - 2, CGRectGetMinY(packageBtn.frame)+6, CGRectGetWidth(courseLabel.frame), CGRectGetHeight(courseLabel.frame))];
                [_myScrollView addSubview:courseLabel];
                
                maxY = CGRectGetMaxY(packageBtn.frame);
            }
        }
    }
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY + 10, Main_Screen_Width - 20, 1)];
    line.backgroundColor = RGB(239, 239, 239);
    [_myScrollView addSubview:line];
    //标题
    NSString *title = [course_info objectForKey:@"TITLE"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame) + 10, Main_Screen_Width - 20, 0)];
    titleLabel.font = SYSTEMFONT(18);
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    [_myScrollView addSubview:titleLabel];
    
    maxY = CGRectGetMaxY(titleLabel.frame);
    
    
    
    if ([isBuy boolValue] && expire_time && ![expire_time isKindOfClass:[NSNull class]] && ![expire_time isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expireDate = [dateFormatter dateFromString:expire_time];
        
        if ([expireDate compare:[NSDate date]] > 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY + 10, 0, 0)];
            label.font = SYSTEMFONT(18);
            label.textColor = [UIColor redColor];
            label.text = @"您已经购买了本课程";
            [label sizeToFit];
            maxY = CGRectGetMaxY(label.frame);
            [_myScrollView addSubview:label];
        }
        
    }
    
    
    //价格
    NSString *currentPrice = [course_info objectForKey:@"CURRENT_PRICE"];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY + 10, 0, 0)];
    priceLabel.font = SYSTEMFONT(12);
    priceLabel.textColor = RGB(102, 102, 102);
    priceLabel.text = @"价格:";
    [priceLabel sizeToFit];
    [_myScrollView addSubview:priceLabel];
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame) + 2, CGRectGetMinY(priceLabel.frame), 0, 0)];
    price.font = SYSTEMFONT(12);
    price.textColor = RGB(255, 153, 0);
    price.text = [NSString stringWithFormat:@"讲解点%@",currentPrice];
    [price sizeToFit];
    [_myScrollView addSubview:price];
    
    
    
    
    //原价
    NSString *sourcePrice = [course_info objectForKey:@"SOURCE_PRICE"];
    UILabel *yuanjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price.frame) + 20, maxY + 10, 0, 0)];
    yuanjiaLabel.font = SYSTEMFONT(12);
    yuanjiaLabel.textColor = RGB(102, 102, 102);
    yuanjiaLabel.text = [NSString stringWithFormat:@"原价: "];
    [yuanjiaLabel sizeToFit];
    [_myScrollView addSubview:yuanjiaLabel];
    
    UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yuanjiaLabel.frame), CGRectGetMinY(yuanjiaLabel.frame), 0, 0)];
    priceValue.font = SYSTEMFONT(12);
    priceValue.textColor = RGB(102, 102, 102);
    [_myScrollView addSubview:priceValue];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:sourcePrice attributes:attribtDic];
    priceValue.attributedText = attribtStr;
    [priceValue sizeToFit];
    
    //有效期
    UILabel *youxiaoqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceValue.frame) + 20, maxY + 10, 0, 0)];
    youxiaoqiLabel.font = SYSTEMFONT(12);
    youxiaoqiLabel.textColor = RGB(102, 102, 102);
    youxiaoqiLabel.text = [NSString stringWithFormat:@"有效期: %d天",[[course_info objectForKey:@"admin_days"] intValue]];
    [youxiaoqiLabel sizeToFit];
    [_myScrollView addSubview:youxiaoqiLabel];
    
    //购买
    NSString *buyNum = [course_info objectForKey:@"buy_num"];
    UILabel *payNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame) + 5, 0, 0)];
    payNumLabel.font = SYSTEMFONT(12);
    payNumLabel.textColor = RGB(102, 102, 102);
    payNumLabel.text = [NSString stringWithFormat:@"购买: %@人",buyNum];
    [payNumLabel sizeToFit];
    [_myScrollView addSubview:payNumLabel];
    //时长
    NSString *LESSION_NUM = [course_info objectForKey:@"LESSION_NUM"];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(payNumLabel.frame) + 20, CGRectGetMaxY(priceLabel.frame) + 5, 0, 0)];
    timeLabel.font = SYSTEMFONT(12);
    timeLabel.textColor = RGB(102, 102, 102);
    timeLabel.text = [NSString stringWithFormat:@"时长: %@分钟",LESSION_NUM];
    [timeLabel sizeToFit];
    [_myScrollView addSubview:timeLabel];
    //播放
    NSString *play_times = [course_info objectForKey:@"play_times"];
    UILabel *playNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame) + 20, CGRectGetMaxY(priceLabel.frame) + 5, 0, 0)];
    playNumLabel.font = SYSTEMFONT(12);
    playNumLabel.textColor = RGB(102, 102, 102);
    playNumLabel.text = [NSString stringWithFormat:@"播放: %@次",play_times];
    [playNumLabel sizeToFit];
    [_myScrollView addSubview:playNumLabel];
    
    if ([isBuy boolValue] && expire_time && ![expire_time isKindOfClass:[NSNull class]] && ![expire_time isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expireDate = [dateFormatter dateFromString:expire_time];
        
        if ([expireDate compare:[NSDate date]] > 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playNumLabel.frame) + 20, Main_Screen_Width - 20, 0)];
            label.font = SYSTEMFONT(20);
            label.textColor = [UIColor redColor];
            label.numberOfLines = 0;
            label.text = [NSString stringWithFormat:@"观看到期时间：%@",expire_time];
            [label sizeToFit];
            maxY = CGRectGetMaxY(label.frame);
            [_myScrollView addSubview:label];
        }else{
            CGFloat btnWidth = (Main_Screen_Width - 20)/1;
            //余额支付
            UIButton *yueBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth, 32)];
            [yueBtn setTitle:@"余额支付" forState:UIControlStateNormal];
            [yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            yueBtn.titleLabel.font = SYSTEMFONT(15);
            [yueBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(yueBtn, 5);
            yueBtn.tag = 1;
            [yueBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_myScrollView addSubview:yueBtn];
            
//            //支付宝支付
            UIButton *zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yueBtn.frame) + 10, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth, 32)];
            [zhifubaoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
            [zhifubaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            zhifubaoBtn.titleLabel.font = SYSTEMFONT(15);
            [zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(zhifubaoBtn, 5);
            zhifubaoBtn.tag = 2;
            [zhifubaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_myScrollView addSubview:zhifubaoBtn];
            
            CGFloat btnWidth2 = (Main_Screen_Width - 40)/3;
            
            //加入购物车
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 10 - btnWidth2, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth2, 32)];
            [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            addBtn.titleLabel.font = SYSTEMFONT(15);
            [addBtn setBackgroundImage:[UIImage imageWithColor:RGB(150, 218, 255) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(addBtn, 5);
            [addBtn addTarget:self action:@selector(addGoodToCard) forControlEvents:UIControlEventTouchUpInside];
            [_myScrollView addSubview:addBtn];
            
            maxY = CGRectGetMaxY(addBtn.frame);
        }
        
        
        
    }else{
        
        if ([currentPrice floatValue] == 0) {
            CGFloat btnWidth = (Main_Screen_Width - 40)/3;
            //余额支付
            UIButton *yueBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth, 32)];
            [yueBtn setTitle:@"免费观看" forState:UIControlStateNormal];
            [yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            yueBtn.titleLabel.font = SYSTEMFONT(15);
            [yueBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(yueBtn, 5);
            yueBtn.tag = 1;
            [yueBtn addTarget:self action:@selector(payByYue) forControlEvents:UIControlEventTouchUpInside];
            [_myScrollView addSubview:yueBtn];
            
            maxY = CGRectGetMaxY(yueBtn.frame);
        }else{
            CGFloat btnWidth = (Main_Screen_Width - 20)/1;
            //余额支付
            UIButton *yueBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playNumLabel.frame) + 10 + 40, btnWidth, 32)];
            [yueBtn setTitle:@"余额支付" forState:UIControlStateNormal];
            [yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            yueBtn.titleLabel.font = SYSTEMFONT(15);
            [yueBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 153, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(yueBtn, 5);
            yueBtn.tag = 1;
            [yueBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_myScrollView addSubview:yueBtn];
            
//            //支付宝支付
//            UIButton *zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yueBtn.frame) + 10, CGRectGetMaxY(playNumLabel.frame) + 10 + 40, btnWidth, 32)];
//            [zhifubaoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
//            [zhifubaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            zhifubaoBtn.titleLabel.font = SYSTEMFONT(15);
//            [zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//            ViewRadius(zhifubaoBtn, 5);
//            zhifubaoBtn.tag = 2;
//            [zhifubaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_myScrollView addSubview:zhifubaoBtn];
//            
//            //微信支付
//            UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zhifubaoBtn.frame) + 10, CGRectGetMaxY(playNumLabel.frame) + 10 + 40, btnWidth, 32)];
//            [weixinBtn setTitle:@"微信支付" forState:UIControlStateNormal];
//            [weixinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            weixinBtn.titleLabel.font = SYSTEMFONT(15);
//            [weixinBtn setBackgroundImage:[UIImage imageWithColor:RGB(85, 183, 55) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//            ViewRadius(weixinBtn, 5);
//            weixinBtn.tag = 3;
//            [weixinBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_myScrollView addSubview:weixinBtn];
            CGFloat btnWidth2 = (Main_Screen_Width - 40)/3;
            //加入购物车
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 10 - btnWidth2, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth2, 32)];
            [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            addBtn.titleLabel.font = SYSTEMFONT(15);
            [addBtn setBackgroundImage:[UIImage imageWithColor:RGB(150, 218, 255) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            ViewRadius(addBtn, 5);
            [addBtn addTarget:self action:@selector(addGoodToCard) forControlEvents:UIControlEventTouchUpInside];
            [_myScrollView addSubview:addBtn];
            
            maxY = CGRectGetMaxY(yueBtn.frame);
        }
        
        
        
    }
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY + 20, Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [_myScrollView addSubview:line];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 10)];
    sepView.backgroundColor = RGB(245, 245, 245);
    [_myScrollView addSubview:sepView];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepView.frame), Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [_myScrollView addSubview:line];
    
    //加载Segment
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    //初始化
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), self.view.frame.size.width, 40)];
    segment.delegate = self;
    self.segment = segment;
    [_myScrollView addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segment.frame), Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [_myScrollView addSubview:line];
    
    v1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 500)];
    v1.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:v1];
    
    CGFloat v1Height = [self setV1];
    
    v2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, v1Height)];
    v2.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:v2];
    
     [self setV2];
    
    v3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, v1Height)];
    v3.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:v3];
    
     [self setV3];
    
    [_myScrollView bringSubviewToFront:v1];
    
    [_myScrollView setContentSize:CGSizeMake(Main_Screen_Width, CGRectGetMaxY(v1.frame))];
}

-(CGFloat)setV1{
    NSDictionary *course_info = [courseInfo objectForKey:@"course_info"];
    NSString *title = [course_info objectForKey:@"TITLE"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    label.font = SYSTEMFONT(15);
    label.text = @"课程详情";
    [label sizeToFit];
    [v1 addSubview:label];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, Main_Screen_Width - 40, 0)];
    titleLabel2.numberOfLines = 0;
    titleLabel2.textColor = RGB(102, 102, 102);
    titleLabel2.font = SYSTEMFONT(15);
    titleLabel2.text = title;
    [titleLabel2 sizeToFit];
    [v1 addSubview:titleLabel2];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel2.frame) + 20, Main_Screen_Width - 20, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [v1 addSubview:line];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame) + 10, 0, 0)];
    label2.font = SYSTEMFONT(15);
    label2.text = @"主讲讲师";
    [label2 sizeToFit];
    [v1 addSubview:label2];
    
    NSDictionary *teacherInfo = [courseInfo objectForKey:@"teacher_info"];
    
    CGFloat imgWidth = (Main_Screen_Width - 80)/3;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label2.frame) + 10, imgWidth, imgWidth)];
    ViewRadius(headImageView, imgWidth/2);
    [headImageView setImageWithURL:[NSURL URLWithString:[teacherInfo objectForKey:@"PIC_PATH"]]];
//    headImageView.image = [UI
    [v1 addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 20, CGRectGetMinY(headImageView.frame) + 10, 0, 0)];
    nameLabel.text = [teacherInfo objectForKey:@"NAME"];
    nameLabel.font = SYSTEMFONT(16);
    [nameLabel sizeToFit];
    [v1 addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame) + 5, 0, 0)];
    detailLabel.textColor = RGB(153, 153, 153);
    detailLabel.text = [NSString stringWithFormat:@"%@节微课",[teacherInfo objectForKey:@"course_num"]];
    detailLabel.font = SYSTEMFONT(12);
    [detailLabel sizeToFit];
    [v1 addSubview:detailLabel];
    
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - imgWidth), CGRectGetMinY(nameLabel.frame), imgWidth, 32)];
    [homeBtn setTitle:@"TA的主页" forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    homeBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [homeBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(toTeacherHome) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(homeBtn, 5);
    [v1 addSubview:homeBtn];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headImageView.frame) + 10, Main_Screen_Width - 20, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [v1 addSubview:line];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame) + 10, 0, 0)];
    label3.font = SYSTEMFONT(15);
    label3.text = @"猜你喜欢";
    [label3 sizeToFit];
    [v1 addSubview:label3];
    
    CGFloat imgWidth2 = (Main_Screen_Width - 40)*0.35;
    CGFloat imageHeight2 = imgWidth2*2/3;
    CGFloat maxY = CGRectGetMaxY(label3.frame);
    
    
    
    
    for (int i = 0; i< likeList.count; i++) {
        
        NSDictionary *like = [likeList objectAtIndex:i];
        NSString *image = [like objectForKey:@"image"];
        NSString *teacher_name = [like objectForKey:@"teacher_name"];
        NSString *look_num = [like objectForKey:@"look_num"];
        NSString *name = [like objectForKey:@"name"];
        
        UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(0, maxY + 10, Main_Screen_Width, imageHeight2)];
         
        UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, imgWidth2, imageHeight2)];
        [imageview1 setImageWithURL:[NSURL URLWithString:image]];
        ViewRadius(imageview1, 5);
        [cview addSubview:imageview1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview1.frame) + 10, CGRectGetMinY(imageview1.frame)+5, Main_Screen_Width - CGRectGetMaxX(imageview1.frame) - 20, 0)];
        titleLabel.text = name;
        titleLabel.numberOfLines = 2;
        titleLabel.font = SYSTEMFONT(14);
        titleLabel.textColor = RGB(51, 51, 51);
        [titleLabel sizeToFit];
        [cview addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview1.frame) + 10, CGRectGetMaxY(titleLabel.frame) + 5, 0, 0)];
        detailLabel.text = [NSString stringWithFormat:@"讲师：%@  浏览：%@人",teacher_name,look_num];
        detailLabel.font = SYSTEMFONT(12);
        detailLabel.textColor = RGB(102, 102, 102);
        [detailLabel sizeToFit];
        [cview addSubview:detailLabel];
        cview.userInteractionEnabled = YES;
        cview.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLike:)];
        [cview addGestureRecognizer:tap];
        [v1 addSubview:cview];
        maxY = CGRectGetMaxY(cview.frame);
    }
    
    CGRect v1Rect = v1.frame;
    v1Rect.size.height = maxY + 20;
    [v1 setFrame:v1Rect];
    
    return v1Rect.size.height;
}

-(void)tapLike:(UITapGestureRecognizer *)recog{
    
    NSString *courseId = [[likeList objectAtIndex:recog.view.tag] objectForKey:@"id"];
    
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = courseId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setV2{
    
}

-(void)setV3{
    [v3.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    tips.textColor = RGB(200, 200, 200);
    tips.text = @"评论将由平台审核后发布";
    tips.font = SYSTEMFONT(14);
    [tips sizeToFit];
    [v3 addSubview:tips];
    
    commentTx = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tips.frame) + 10, Main_Screen_Width - 20, 60)];
    ViewBorderRadius(commentTx, 5, 1, RGB(223, 223, 223));
    [v3 addSubview:commentTx];
    
    CGFloat btnWidth = Main_Screen_Width*0.6;
    UIButton *tijiaoBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - btnWidth)/2, CGRectGetMaxY(commentTx.frame) + 10, btnWidth, 32)];
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiaoBtn.titleLabel.font = SYSTEMFONT(15);
    [tijiaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    ViewRadius(tijiaoBtn, 5);
    [tijiaoBtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    [v3 addSubview:tijiaoBtn];
    
    CGFloat maxY = CGRectGetMaxY(tijiaoBtn.frame) + 10;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY, Main_Screen_Width, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [v3 addSubview:line];
    
    for (int i = 0; i < pinglunList.count; i++) {
        NSDictionary *pinglun = [[pinglunList objectAtIndex:i] cleanNull];
        NSString *userAvatar = [pinglun objectForKey:@"user_avatar"];
        NSString *name = [pinglun objectForKey:@"user_name"];
        NSString *content = [pinglun objectForKey:@"CONTENT"];
        NSString *addtime = [pinglun objectForKey:@"ADDTIME"];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, Main_Screen_Width, 60)];
//        commentView.backgroundColor = [UIColor grayColor];
        
        UIImageView *headimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [headimage setImageWithURL:[NSURL URLWithString:userAvatar]];
        ViewRadius(headimage, 20);
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 0, 0)];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = RGB(51, 51, 51);
        nameLabel.text = name;
        [nameLabel sizeToFit];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        dateLabel.text = addtime;
        dateLabel.font = SYSTEMFONT(12);
        dateLabel.textColor = RGB(102, 102, 102);
        [dateLabel sizeToFit];
        [dateLabel setFrame:CGRectMake(Main_Screen_Width - CGRectGetWidth(dateLabel.frame) - 10, 5, CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(nameLabel.frame) + 5, Main_Screen_Width - 70, 0)];
        contentLabel.numberOfLines = 0;
        contentLabel.font = SYSTEMFONT(14);
        contentLabel.textColor = RGB(51, 51, 51);
        contentLabel.text = content;
        [contentLabel sizeToFit];
        [commentView addSubview:contentLabel];
        
        [commentView addSubview:dateLabel];
        [commentView addSubview:headimage];
        [commentView addSubview:nameLabel];
        
        
        
        
        CGRect rect = commentView.frame;
        rect.size.height = CGRectGetMaxY(contentLabel.frame) + 10;
        if (rect.size.height > 60) {
            [commentView setFrame:rect];
            maxY = CGRectGetMaxY(commentView.frame);
        }else{
            maxY = CGRectGetMaxY(commentView.frame);
        }
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(commentView.frame) -1, Main_Screen_Width, 1)];
        line.backgroundColor = RGB(223, 223, 223);
        [commentView addSubview:line];
        
        [v3 addSubview:commentView];
         
//        CGRect rect3 = v3.frame;
//        rect3.size.height = maxY;
//        [v3 setFrame:rect3];
    }
    
    
    
    
}

-(void)toTeacherHome{
    NSDictionary *teacherInfo = [courseInfo objectForKey:@"teacher_info"];
    NSString *teacherId = [teacherInfo objectForKey:@"ID"];
    
    TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] init];
    vc.teacherId = teacherId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    if (Page == 0) {
        [_myScrollView bringSubviewToFront:v1];
    }
    if (Page == 1) {
        [_myScrollView bringSubviewToFront:v2];
    }
    if (Page == 2) {
        [_myScrollView bringSubviewToFront:v3];
    }
}

#pragma mark - player

-(void)viewDidDisappear:(BOOL)animated {
    self.isPresented = NO;
    self.videoPlayer.contentURL = nil;
    [self.videoPlayer stop];
    [self.videoPlayer cancel];
    //[self.videoPlayer cancelObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
    [self.videoPlayer dismiss];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.videoPlayer configObserver];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    [super viewWillAppear:animated];
}

////设置状态栏颜色
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}

//- (BOOL)prefersStatusBarHidden{
//    if (!_barShow) {
//        _barShow = !_barShow;
//        return _barShow;
//    }else{
//        _barShow = !_barShow;
//        return NO;
//    }
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

@end
