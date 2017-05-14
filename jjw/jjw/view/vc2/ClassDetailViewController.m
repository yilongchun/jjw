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

@interface ClassDetailViewController ()<SegmentDelegate>{
    NSDictionary *courseInfo;
}

@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;

@end

@implementation ClassDetailViewController{
    UIView *v1;
    UIView *v2;
    UIView *v3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.jz_navigationBarBackgroundHidden = NO;
    self.title = @"课程详情";
    
    
    [self loadData];
}

-(void)loadData{
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[_info objectForKey:@"COURSE_ID"] forKey:@"id"];
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
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
            [self initUI];
        }else{
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        DLog(@"%@",error.description);
    }];
}

-(void)initUI{
    CGFloat videoHeight = (Main_Screen_Width - 20)/2;
    
    NSDictionary *course_info = [courseInfo objectForKey:@"course_info"];
    NSString *LOGO = [course_info objectForKey:@"LOGO"];
    //添加视频
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width - 20, videoHeight)];
    [image setImageWithURL:[NSURL URLWithString:LOGO]];
    ViewRadius(image, 10);
    [_myScrollView addSubview:image];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + videoHeight + 10, Main_Screen_Width - 20, 1)];
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
    //价格
    NSString *currentPrice = [course_info objectForKey:@"CURRENT_PRICE"];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
    priceLabel.font = SYSTEMFONT(12);
    priceLabel.textColor = RGB(102, 102, 102);
    priceLabel.text = @"价格:";
    [priceLabel sizeToFit];
    [_myScrollView addSubview:priceLabel];
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame) + 2, CGRectGetMinY(priceLabel.frame), 0, 0)];
    price.font = SYSTEMFONT(12);
    price.textColor = RGB(255, 153, 0);
    price.text = [NSString stringWithFormat:@"￥%@",currentPrice];
    [price sizeToFit];
    [_myScrollView addSubview:price];
    
    
    
    
    //原价
    NSString *sourcePrice = [course_info objectForKey:@"SOURCE_PRICE"];
    UILabel *yuanjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price.frame) + 20, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
    yuanjiaLabel.font = SYSTEMFONT(12);
    yuanjiaLabel.textColor = RGB(102, 102, 102);
    yuanjiaLabel.text = [NSString stringWithFormat:@"原价: %@",sourcePrice];
    [yuanjiaLabel sizeToFit];
    [_myScrollView addSubview:yuanjiaLabel];
    //有效期
    UILabel *youxiaoqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yuanjiaLabel.frame) + 20, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
    youxiaoqiLabel.font = SYSTEMFONT(12);
    youxiaoqiLabel.textColor = RGB(102, 102, 102);
    youxiaoqiLabel.text = [NSString stringWithFormat:@"有效期: 180天"];
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
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(payNumLabel.frame) + 20, CGRectGetMaxY(priceLabel.frame) + 5, 0, 0)];
    timeLabel.font = SYSTEMFONT(12);
    timeLabel.textColor = RGB(102, 102, 102);
    timeLabel.text = [NSString stringWithFormat:@"时长: 6分钟"];
    [timeLabel sizeToFit];
    [_myScrollView addSubview:timeLabel];
    //播放
    UILabel *playNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame) + 20, CGRectGetMaxY(priceLabel.frame) + 5, 0, 0)];
    playNumLabel.font = SYSTEMFONT(12);
    playNumLabel.textColor = RGB(102, 102, 102);
    playNumLabel.text = [NSString stringWithFormat:@"播放: 0次"];
    [playNumLabel sizeToFit];
    [_myScrollView addSubview:playNumLabel];
    
    CGFloat btnWidth = (Main_Screen_Width - 40)/3;
    //支付宝支付
    UIButton *zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth, 32)];
    [zhifubaoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [zhifubaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhifubaoBtn.titleLabel.font = SYSTEMFONT(15);
    [zhifubaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    ViewRadius(zhifubaoBtn, 5);
    [_myScrollView addSubview:zhifubaoBtn];
    
    //加入购物车
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zhifubaoBtn.frame) + 10, CGRectGetMaxY(playNumLabel.frame) + 10, btnWidth, 32)];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = SYSTEMFONT(15);
    [addBtn setBackgroundImage:[UIImage imageWithColor:RGB(150, 218, 255) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    ViewRadius(addBtn, 5);
    [_myScrollView addSubview:addBtn];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addBtn.frame) + 20, Main_Screen_Width, 1)];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    label.font = SYSTEMFONT(15);
    label.text = @"课程详情";
    [label sizeToFit];
    [v1 addSubview:label];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, Main_Screen_Width - 40, 0)];
    titleLabel2.numberOfLines = 0;
    titleLabel2.textColor = RGB(102, 102, 102);
    titleLabel2.font = SYSTEMFONT(15);
    titleLabel2.text = @"函数定义域之2：如何求抽象函数的定义域";
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
    
    CGFloat imgWidth = (Main_Screen_Width - 80)/3;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label2.frame) + 10, imgWidth, imgWidth)];
    ViewRadius(headImageView, imgWidth/2);
    headImageView.image = [UIImage imageNamed:@"1481518277839.png"];
    [v1 addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 20, CGRectGetMinY(headImageView.frame) + 10, 0, 0)];
    nameLabel.text = @"吴清华";
    nameLabel.font = SYSTEMFONT(16);
    [nameLabel sizeToFit];
    [v1 addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame) + 5, 0, 0)];
    detailLabel.textColor = RGB(153, 153, 153);
    detailLabel.text = @"21节微课";
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
    
    for (int i = 0; i< 3; i++) {
        UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, maxY + 10, imgWidth2, imageHeight2)];
        imageview1.image = [UIImage imageNamed:@"1475988005412.jpeg"];
        ViewRadius(imageview1, 5);
        [v1 addSubview:imageview1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview1.frame) + 10, CGRectGetMinY(imageview1.frame)+5, 0, 0)];
        titleLabel.text = @"集合的表示方法";
        titleLabel.font = SYSTEMFONT(14);
        titleLabel.textColor = RGB(51, 51, 51);
        [titleLabel sizeToFit];
        [v1 addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview1.frame) + 10, CGRectGetMaxY(titleLabel.frame) + 5, 0, 0)];
        detailLabel.text = @"讲师：吴清华  浏览：27人";
        detailLabel.font = SYSTEMFONT(12);
        detailLabel.textColor = RGB(102, 102, 102);
        [detailLabel sizeToFit];
        [v1 addSubview:detailLabel];
        maxY = CGRectGetMaxY(imageview1.frame);
    }
    
    CGRect v1Rect = v1.frame;
    v1Rect.size.height = maxY + 20;
    [v1 setFrame:v1Rect];
    
    return v1Rect.size.height;
}

-(void)setV2{
    
}

-(void)setV3{
    UITextView *tv1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width - 20, 60)];
    ViewBorderRadius(tv1, 5, 1, RGB(223, 223, 223));
    [v3 addSubview:tv1];
    
    CGFloat btnWidth = Main_Screen_Width*0.6;
    UIButton *tijiaoBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - btnWidth)/2, CGRectGetMaxY(tv1.frame) + 10, btnWidth, 32)];
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiaoBtn.titleLabel.font = SYSTEMFONT(15);
    [tijiaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    ViewRadius(tijiaoBtn, 5);
    [v3 addSubview:tijiaoBtn];
}

-(void)toTeacherHome{
    TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] init];
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

@end
