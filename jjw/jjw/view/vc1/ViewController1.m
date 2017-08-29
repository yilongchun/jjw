//
//  ViewController1.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController1.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "HZSigmentView.h"
#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "ClassDetailViewController.h"
#import "TeacherViewController.h"
#import "TeacherHomeViewController.h"
#import "OpenShareHeader.h"
#import "UIViewController+RegisterRandomAccount.h"
#import "NSObject+Blocks.h"
#import "Util.h"

@interface ViewController1 ()<HZSigmentViewDelegate,UISearchBarDelegate>{
    UIScrollView *myScrollView;//主界面滚动视图
    
    UIScrollView *bixiuScrollView;//必修滚动界面
    
    NSInteger secondIndex;
    NSString *tsid;//二级分类：语文，数学，外语，政治，等
    NSMutableArray *secondDataSource;//二级分类
    
    
    NSString *ttsid;//三级分类：必修一，必修二，必修三，等
    NSMutableArray *thirdDataSource;//三级分类
    
    UISearchBar *_searchBar;
    
    int requestNum;
    NSArray *adImagesArray;
    NSArray *newsArray;
    NSArray *recCoursecArray;
    NSArray *freeCoursesArray;
    NSArray *centerAdImagesArray;
    NSArray *recommendTeacherArray;
    
    NSArray *courseList;//课程排名
    NSArray *teacherList;//教师排名
    
    UIButton *nbtn1;
    UIButton *nbtn2;
    
    UIView *popView;
    UIView *maskView;
    
    int action2Tag;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *line1;
    UILabel *line2;
    
    UIView *view1;
    UIView *view_1;
    UIView *view_2;
}

@property (nonatomic, strong) HZSigmentView * sigment;//横向滑动二级

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.jz_navigationBarBackgroundHidden = YES;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    
    nbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(2, 6, 60, 28)];
    [nbtn1 setTitle:@"高中" forState:UIControlStateNormal];
    [nbtn1 setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [nbtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nbtn1.titleLabel.font = SYSTEMFONT(13);
    [nbtn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(nbtn1, 5, 0, [UIColor whiteColor]);
    UIImage *imgArrow = [UIImage imageNamed:@"down2"];
    [nbtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
    [nbtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    [nbtn1 addTarget:self action:@selector(chooseType1:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:nbtn1];
    
    nbtn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nbtn1.frame) + 10, 6, 60, 28)];
    [nbtn2 setTitle:@"课程" forState:UIControlStateNormal];
    [nbtn2 setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [nbtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nbtn2.titleLabel.font = SYSTEMFONT(13);
    [nbtn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(nbtn2, 5, 0, [UIColor whiteColor]);
    [nbtn2 addTarget:self action:@selector(chooseType2:) forControlEvents:UIControlEventTouchUpInside];
    
    [nbtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
    [nbtn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    [navView addSubview:nbtn2];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nbtn2.frame) + 10, 6, Main_Screen_Width - CGRectGetMaxX(nbtn2.frame) - 28, 28)];
    ViewRadius(_searchBar, 5);
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索关键词";
    [navView addSubview:_searchBar];
    self.navigationItem.titleView = navView;
    
    
    secondDataSource = [NSMutableArray array];
    thirdDataSource = [NSMutableArray array];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height- - 49 - 50)];
    [self.view addSubview:myScrollView];
    myScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [myScrollView.mj_header endRefreshing];
    }];
    
    [myScrollView.mj_header beginRefreshing];
    
    
}

-(void)loadData{
    secondIndex = 0;
    requestNum = 0;
    [self loadTwoClass:@"268"];
    [self loadData1];
    [self loadData2];
    [self loadData3];
    [self loadData4];
    [self loadData5];
    [self loadData6];
    [self loadData7];
    [self loadData8];
}

-(void)loadSuccess{
    DLog(@"%d",requestNum);
    if (requestNum == 8) {
        [self initUI];
    }
}

//获得二级分类
-(void)loadTwoClass:(NSString *)parentId{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_next_class"];
    
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    [parameters setValue:parentId forKey:@"subject_id"];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            NSArray *dataList = [result objectForKey:@"data_list"];
            
            if (dataList.count > 0) {
                [secondDataSource removeAllObjects];
                [secondDataSource addObjectsFromArray:dataList];
                DLog(@"%@",responseObject);
                
                NSMutableArray *titleArray = [NSMutableArray array];
                for (int i = 0; i < secondDataSource.count; i++) {
                    NSDictionary *dic = [secondDataSource objectAtIndex:i];
                    NSString *name = [dic objectForKey:@"SUBJECT_NAME"];
                    [titleArray addObject:name];
                }
                
                if (self.sigment) {
                    [self.sigment removeFromSuperview];
                    self.sigment = nil;
                }
                
                self.sigment = [[HZSigmentView alloc] initWithOrgin:CGPointMake(0, 0) andHeight:40];
                self.sigment.delegate = self;
                self.sigment.titleArry = titleArray;
                
                // 设置标题选中时的颜色
                self.sigment.titleColorSelect = DDMColor(255, 153, 0);
                // 设置标题未选中的颜色
                //    self.sigment.titleColorNormal = [UIColor redColor];
                // 默认选中第几项
                //self.sigment.defaultIndex = 2;
                // 设置标题字体大小
                //    self.sigment.titleFont = [UIFont systemFontOfSize:9];
                
                //    self.sigment.bottomLineColor = [UIColor yellowColor];
                self.sigment.titleLineColor = [UIColor grayColor];
                self.sigment.defaultIndex = 1;
                [myScrollView addSubview:self.sigment];
                
//                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sigment.frame), Main_Screen_Width, 0.5)];
//                line.backgroundColor = RGB(219, 219, 219);
//                [self.view addSubview:line];
                
                
                NSDictionary *dic = [secondDataSource objectAtIndex:secondIndex];
                NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
            
                tsid = subjectId;
                
                [self loadThreeClass:subjectId];
            }
            
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
    }];
}

-(void)loadThreeClass:(NSString *)parentId{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_course_pack"];
    
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    [parameters setValue:parentId forKey:@"subject_id"];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *dataList = [result objectForKey:@"data_list"];
            
            if (dataList.count > 0) {
                [thirdDataSource removeAllObjects];
                [thirdDataSource addObjectsFromArray:dataList];
                
//                NSDictionary *dic = [thirdDataSource objectAtIndex:0];
//                NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
//                ttsid = subjectId;
                
                [self initBixiuData];
                
            }
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
    }];
}

-(void)action1:(UIButton *)btn{
    
    if (btn.tag > 1) {
        [self showHintInView:self.view hint:@"初中、小学部分即将推出"];
    }else{
        [nbtn1 setTitle:btn.currentTitle forState:UIControlStateNormal];
    }
    
    [self hidePopView:nil];
}

-(void)action2:(UIButton *)btn{
    action2Tag = (int)btn.tag-1;
    [nbtn2 setTitle:btn.currentTitle forState:UIControlStateNormal];
    [self hidePopView:nil];
}

-(void)chooseType1:(UIButton *)sender{
    
    if (popView == nil) {
        popView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 122)];
        popView.backgroundColor = RGB(255, 255, 255);
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        btn1.tag = 1;
        btn1.titleLabel.font = SYSTEMFONT(14);
        [btn1 setTitle:@"高中" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn1];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView addSubview:line];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn2.tag = 2;
        btn2.titleLabel.font = SYSTEMFONT(14);
        [btn2 setTitle:@"初中" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn2];
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn2.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView addSubview:line];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn3.tag = 3;
        btn3.titleLabel.font = SYSTEMFONT(14);
        [btn3 setTitle:@"小学" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn3];
        
        ViewBorderRadius(popView, 0, 0.5, RGB(160, 160, 160));
    }
    if (maskView == nil) {
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        maskView.backgroundColor = RGBA(0, 0, 0, 0.1);
        maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView:)];
        [maskView addGestureRecognizer:tap];
    }
    
    [self.navigationController.view addSubview:maskView];
    [self.navigationController.view addSubview:popView];
}

-(void)chooseType2:(UIButton *)sender{
    if (popView == nil) {
        popView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 122)];
        popView.backgroundColor = RGB(255, 255, 255);
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        btn1.tag = 1;
        btn1.titleLabel.font = SYSTEMFONT(14);
        [btn1 setTitle:@"课程" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn1];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView addSubview:line];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn2.tag = 2;
        btn2.titleLabel.font = SYSTEMFONT(14);
        [btn2 setTitle:@"名师" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn2];
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn2.frame), Main_Screen_Width, 1)];
        line.backgroundColor = RGB(210, 210, 210);
        [popView addSubview:line];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 40)];
        btn3.tag = 3;
        btn3.titleLabel.font = SYSTEMFONT(14);
        [btn3 setTitle:@"题目" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btn3];
        
        ViewBorderRadius(popView, 0, 0.5, RGB(160, 160, 160));
    }
    if (maskView == nil) {
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        maskView.backgroundColor = RGBA(0, 0, 0, 0.1);
        maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView:)];
        [maskView addGestureRecognizer:tap];
    }
    
    [self.navigationController.view addSubview:maskView];
    [self.navigationController.view addSubview:popView];
}

-(void)hidePopView:(UIGestureRecognizer *)sender{
    
    if (maskView) {
        [maskView removeFromSuperview];
    }
    if (popView) {
        [popView removeFromSuperview];
    }
    maskView = nil;
    popView = nil;
    
}

-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 2) {
        TeacherViewController *vc = [[TeacherViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)initUI{
    
    [myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[MJRefreshHeader class]] && ![obj isKindOfClass:[HZSigmentView class]]) {
            [obj removeFromSuperview];
        }
        
    }];
    
    CGFloat maxY;
    
//    //广告图片
    CGFloat imageViewHeight = Main_Screen_Width * 296 / 640;
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, Main_Screen_Width, imageViewHeight)];
//    
//    if (adImagesArray.count > 0) {
//        NSDictionary *dic = adImagesArray[0];
//        NSString *imageUrl = [dic objectForKey:@"IMAGE_URL"];
//        [imageview setImageWithURL:[NSURL URLWithString:imageUrl]];
//    }
//    
////    imageview.image = [UIImage imageNamed:@"1484533496_919.jpg"];
//    [myScrollView addSubview:imageview];
    
    //必修
    bixiuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 125)];
    bixiuScrollView.showsHorizontalScrollIndicator = NO;
    [myScrollView addSubview:bixiuScrollView];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bixiuScrollView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
//    bixiuScrollView.backgroundColor = [UIColor redColor];
    
    [self initBixiuData];
    
    //最新动态
    CGFloat cellWidth = (Main_Screen_Width - 15)/2;
    CGFloat cellHeight = cellWidth * 2 / 3;
    CGFloat viewHeight = 35 + cellHeight * 2 + 50 * 2 + 20 + 38;
    
    UIView *zxdtView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, viewHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 35)];
    label.text = @"  最新动态";
    label.font = SYSTEMFONT(20);
    label.backgroundColor = [UIColor whiteColor];
    [zxdtView addSubview:label];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [zxdtView addSubview:line];
    
    UIView *dongtaiContent = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, CGRectGetHeight(zxdtView.frame))];
    dongtaiContent.backgroundColor = RGB(246, 246, 246);
    [zxdtView addSubview:dongtaiContent];
    
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    if (newsArray.count > 0) {
        for (int i = 0; i < newsArray.count; i++) {
            NSDictionary *dic = newsArray[i];
            NSString *imageUrl = [dic objectForKey:@"IMAGE_URL"];
            NSString *title = [dic objectForKey:@"TITLE"];
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50)];
            cellView.backgroundColor = [UIColor whiteColor];
            ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50)];
//            cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
            [cellImage setImageWithURL:[NSURL URLWithString:imageUrl]];
            [cellView addSubview:cellImage];
            ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
            cellLabel.font = SYSTEMFONT(13);
            cellLabel.numberOfLines = 2;
//            cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
            cellLabel.text = title;
            [cellView addSubview:cellLabel];
            cellView.tag = i;
            cellView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toNewsDetail:)];
            [cellView addGestureRecognizer:tap];
            [dongtaiContent addSubview:cellView];
            
            if ((i+1) % 2 == 0) {
                cellX = 0;
                cellY += CGRectGetHeight(cellView.frame) + 5;
            }else{
                cellX += CGRectGetWidth(cellView.frame) + 5;
            }
        }
    }
    

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(zxdtView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
    moreBtn.tag = 1;
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zxdtView addSubview:moreBtn];
    
    
    [myScrollView addSubview:zxdtView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zxdtView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    //精品推荐
    cellWidth = (Main_Screen_Width - 15)/2;
    cellHeight = cellWidth * 2 / 3;
    viewHeight = 35 + cellHeight * 2 + 70 * 2 + 20 + 38;
    
    UIView *jptjView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, viewHeight)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 35)];
    label.text = @"  精品推荐";
    label.font = SYSTEMFONT(20);
    label.backgroundColor = [UIColor whiteColor];
    [jptjView addSubview:label];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [jptjView addSubview:line];
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, CGRectGetHeight(jptjView.frame))];
    content.backgroundColor = RGB(246, 246, 246);
    [jptjView addSubview:content];
    
    cellX = 0;
    cellY = 0;
    if (recCoursecArray.count > 0) {
        for (int i = 0; i < recCoursecArray.count; i++) {
            NSDictionary *dic = recCoursecArray[i];
            NSString *logo = [dic objectForKey:@"LOGO"];
            NSString *courseName = [dic objectForKey:@"COURSE_NAME"];
            NSString *pageViewcount = [dic objectForKey:@"PAGE_VIEWCOUNT"];
            NSString *teacherName = [dic objectForKey:@"TEACHER_NAME"];
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50 + 20)];
            cellView.backgroundColor = [UIColor whiteColor];
            ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50 - 20)];
//            cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
            [cellImage setImageWithURL:[NSURL URLWithString:logo]];
            [cellView addSubview:cellImage];
            
            ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
            cellLabel.font = SYSTEMFONT(13);
            cellLabel.numberOfLines = 2;
//            cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
            cellLabel.text = courseName;
            [cellView addSubview:cellLabel];
            
            UILabel *clickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellLabel.frame), CGRectGetWidth(cellView.frame) - 10, 20)];
            clickLabel.font = SYSTEMFONT(11);
            clickLabel.textColor = [UIColor lightGrayColor];
            clickLabel.text = [NSString stringWithFormat:@"%@  点击%@次",teacherName,pageViewcount];
            [cellView addSubview:clickLabel];
            cellView.tag = i;
            cellView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toClassDetail:)];
            [cellView addGestureRecognizer:tap];
            [content addSubview:cellView];
            if ((i+1) % 2 == 0) {
                cellX = 0;
                cellY += CGRectGetHeight(cellView.frame) + 5;
            }else{
                cellX += CGRectGetWidth(cellView.frame) + 5;
            }
        }
    }
    
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(jptjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
    [moreBtn addTarget:self action:@selector(bixiuClick:) forControlEvents:UIControlEventTouchUpInside];
    [jptjView addSubview:moreBtn];
    
    [myScrollView addSubview:jptjView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(jptjView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    //免费体验
    cellWidth = (Main_Screen_Width - 15)/2;
    cellHeight = cellWidth * 2 / 3;
    viewHeight = 35 + cellHeight * 2 + 70 * 2 + 20 + 38;
    
    UIView *mftyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, viewHeight)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 35)];
    label.text = @"  免费体验";
    label.font = SYSTEMFONT(20);
    label.backgroundColor = [UIColor whiteColor];
    [mftyView addSubview:label];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [mftyView addSubview:line];
    
    content = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, CGRectGetHeight(mftyView.frame))];
    content.backgroundColor = RGB(246, 246, 246);
    [mftyView addSubview:content];
    
    cellX = 0;
    cellY = 0;
    if (freeCoursesArray.count > 0) {
        for (int i = 0; i < freeCoursesArray.count; i++) {
            NSDictionary *dic = freeCoursesArray[i];
            NSString *logo = [dic objectForKey:@"LOGO"];
            NSString *courseName = [dic objectForKey:@"COURSE_NAME"];
            NSString *pageViewcount = [dic objectForKey:@"PAGE_VIEWCOUNT"];
            NSString *teacherName = [dic objectForKey:@"TEACHER_NAME"];
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50 + 20)];
            cellView.backgroundColor = [UIColor whiteColor];
            ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50 - 20)];
//            cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
            [cellImage setImageWithURL:[NSURL URLWithString:logo]];
            [cellView addSubview:cellImage];
            
            ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
            cellLabel.font = SYSTEMFONT(13);
            cellLabel.numberOfLines = 2;
//            cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
            cellLabel.text = courseName;
            [cellView addSubview:cellLabel];
            
            UILabel *clickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellLabel.frame), CGRectGetWidth(cellView.frame) - 10, 20)];
            clickLabel.font = SYSTEMFONT(11);
            clickLabel.textColor = [UIColor lightGrayColor];
//            clickLabel.text = @"江艳  点击44次";
            clickLabel.text = [NSString stringWithFormat:@"%@  点击%@次",teacherName,pageViewcount];
            [cellView addSubview:clickLabel];
            cellView.tag = i;
            cellView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFreeClassDetail:)];
            [cellView addGestureRecognizer:tap];
            [content addSubview:cellView];
            if ((i+1) % 2 == 0) {
                cellX = 0;
                cellY += CGRectGetHeight(cellView.frame) + 5;
            }else{
                cellX += CGRectGetWidth(cellView.frame) + 5;
            }
        }
    }
    
    
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(jptjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
    [moreBtn addTarget:self action:@selector(showFreeCourse:) forControlEvents:UIControlEventTouchUpInside];
    [mftyView addSubview:moreBtn];
    
    
    [myScrollView addSubview:mftyView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mftyView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    //图片
    
//    CGFloat imageViewHeight = Main_Screen_Width * 296 / 640;
//    UIImage *image = [UIImage imageNamed:@"1484533489_1588.jpg"];
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, imageViewHeight)];
//    imageview2.image = image;
    if (centerAdImagesArray.count > 0) {
        NSDictionary *dic = centerAdImagesArray[0];
        NSString *imageUrl = [dic objectForKey:@"IMAGE_URL"];
        [imageview2 setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
    [myScrollView addSubview:imageview2];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview2.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    UIView *sepview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 5)];
    sepview.backgroundColor = RGB(246, 246, 246);
    [myScrollView addSubview:sepview];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepview.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    //名师推荐
    cellWidth = (Main_Screen_Width - 15)/2;
    cellHeight = cellWidth * 3 / 2 + 10;
    viewHeight = 35 + cellHeight * 2 + 20 + 38;
    
    UIView *mstjView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, viewHeight)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 35)];
    label.text = @"  名师推荐";
    label.font = SYSTEMFONT(20);
    label.backgroundColor = [UIColor whiteColor];
    [mstjView addSubview:label];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [mstjView addSubview:line];
    
    content = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, CGRectGetHeight(mstjView.frame) - 35)];
    content.backgroundColor = RGB(246, 246, 246);
    [mstjView addSubview:content];
    
    cellX = 0;
    cellY = 0;
    if (recommendTeacherArray.count > 0) {
        for (int i = 0; i < recommendTeacherArray.count; i++) {
            NSDictionary *dic = recommendTeacherArray[i];
            NSString *type = [dic objectForKey:@"TYPE"];
            NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
            NSString *teacherName = [dic objectForKey:@"TEACHER_NAME"];
            NSString *img = [dic objectForKey:@"IMG"];
            NSString *studyNum = [dic objectForKey:@"STUDY_NUM"];
            NSString *courseNum = [dic objectForKey:@"COURSE_NUM"];
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight)];
            cellView.backgroundColor = [UIColor whiteColor];
            ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
            
            UILabel *kLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 60, 26)];
            
            kLabel.font = SYSTEMFONT(12);
            kLabel.textColor = [UIColor whiteColor];
            kLabel.text = [NSString stringWithFormat:@"%@%@",type,subjectName];
            
            
            
            if ([kLabel.text isEqualToString:@"高中数学"]) {
                kLabel.backgroundColor = RGB(245, 123, 40);
            }else if ([kLabel.text isEqualToString:@"高中英语"]) {
                kLabel.backgroundColor = RGB(223, 10, 200);
            }else if ([kLabel.text isEqualToString:@"高中物理"]) {
                kLabel.backgroundColor = RGB(34, 60, 170);
            }else if ([kLabel.text isEqualToString:@"高中化学"]) {
                kLabel.backgroundColor = RGB(48, 177, 136);
            }else if ([kLabel.text isEqualToString:@"高中生物"]) {
                kLabel.backgroundColor = RGB(154, 103, 37);
            }else if ([kLabel.text isEqualToString:@"高中政治"]) {
                kLabel.backgroundColor = RGB(133, 195, 6);
            }else if ([kLabel.text isEqualToString:@"高中历史"]) {
                kLabel.backgroundColor = RGB(234, 154, 39);
            }else if ([kLabel.text isEqualToString:@"高中地理"]) {
                kLabel.backgroundColor = RGB(160, 6, 16);
            }else{
                kLabel.backgroundColor = RGB(160, 6, 16);
            }
            
            kLabel.textAlignment = NSTextAlignmentCenter;
            [cellView addSubview:kLabel];
            UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:kLabel.bounds
                                                           byRoundingCorners:corners
                                                                 cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = kLabel.bounds;
            maskLayer.path = maskPath.CGPath;
            kLabel.layer.mask = maskLayer;
            //头像
            CGFloat cellImageWidth = CGRectGetWidth(cellView.frame) - 10;
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(kLabel.frame) + 5,cellImageWidth , cellImageWidth)];
            ViewBorderRadius(cellImage, cellImageWidth/2, 0, [UIColor whiteColor]);
//            cellImage.image = [UIImage imageNamed:@"1484533489_1588.jpg"];
            [cellImage setImageWithURL:[NSURL URLWithString:img]];
            [cellView addSubview:cellImage];
            //姓名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame) + 5, cellImageWidth, 20)];
            nameLabel.text = teacherName;
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [cellView addSubview:nameLabel];
            
            line = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(nameLabel.frame) + 5, cellImageWidth, 0.5)];
            line.backgroundColor = BORDER_COLOR;
            [cellView addSubview:line];
            
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(line.frame) + 5, cellImageWidth, CGRectGetHeight(cellView.frame) - CGRectGetMaxY(line.frame) - 5)];
            bottomLabel.text = [NSString stringWithFormat:@"%@节微课 | %@人学习",courseNum,studyNum];
            bottomLabel.font = SYSTEMFONT(11);
            bottomLabel.textColor = [UIColor lightGrayColor];
            [cellView addSubview:bottomLabel];
            
            cellView.userInteractionEnabled = YES;
            cellView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTeacherDetail:)];
            [cellView addGestureRecognizer:tap];
            
            [content addSubview:cellView];
            if ((i+1) % 2 == 0) {
                cellX = 0;
                cellY += CGRectGetHeight(cellView.frame) + 5;
            }else{
                cellX += CGRectGetWidth(cellView.frame) + 5;
            }
        }
    }
    
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(mstjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
    moreBtn.tag = 2;
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mstjView addSubview:moreBtn];
    
    
    [myScrollView addSubview:mstjView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mstjView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    viewHeight = 35 + 5 + 44 + 70*4 + 5;
    
    UIView *wkfybView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, viewHeight)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 35)];
    label.text = @"  微课风云榜";
    label.font = SYSTEMFONT(20);
    label.backgroundColor = [UIColor whiteColor];
    [wkfybView addSubview:label];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [wkfybView addSubview:line];
    
    content = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, 44 + 70 * 4 + 10)];
    content.backgroundColor = RGB(246, 246, 246);
    [wkfybView addSubview:content];
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, Main_Screen_Width - 10, 44 + 70 * 4)];
    view1.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(view1, 0, 1, BORDER_COLOR);
    [content addSubview:view1];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, (Main_Screen_Width - 10)/2, 34)];
    label1.font = SYSTEMFONT(18);
    label1.textColor = RGB(0, 150, 230);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"课程排名";
    [view1 addSubview:label1];
    label1.tag = 1;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    label1.userInteractionEnabled = YES;
    [label1 addGestureRecognizer:tap1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 10, (Main_Screen_Width - 10)/2, 34)];
    label2.font = SYSTEMFONT(18);
    label2.textColor = RGB(51, 51, 51);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"教师排名";
    [view1 addSubview:label2];
    label2.tag = 2;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    label2.userInteractionEnabled = YES;
    [label2 addGestureRecognizer:tap2];
    
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), 10, (Main_Screen_Width - 10)/3, 34)];
//    label3.font = SYSTEMFONT(18);
//    label3.textColor = RGB(51, 51, 51);
//    label3.textAlignment = NSTextAlignmentCenter;
//    label3.text = @"教师排名";
//    [view1 addSubview:label3];
    
    UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), Main_Screen_Width - 10, 1)];
    line9.backgroundColor = BORDER_COLOR;
    [view1 addSubview:line9];
    
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), CGRectGetWidth(label1.frame), 1)];
    line1.backgroundColor = RGB(0, 150, 230);
    [view1 addSubview:line1];
    
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMaxY(label1.frame), CGRectGetWidth(label1.frame), 1)];
//    line2.backgroundColor = [UIColor clearColor];
    [view1 addSubview:line2];
    
    //课程排名
    view_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, Main_Screen_Width - 10, 70 * 4)];
    view_1.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:view_1];
    
    
    for (int i = 0; i < courseList.count; i++) {
        NSDictionary *dic = [courseList objectAtIndex:i];
        NSString *courseName = [dic objectForKey:@"COURSE_NAME"];
        NSString *teacherName = [dic objectForKey:@"TEACHER_NAME"];
        NSString *playNum = [dic objectForKey:@"PLAY_NUM"];
        
        
        
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 70*i, Main_Screen_Width - 10, 70)];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width - 20, 24)];
        titleLabel.text = courseName;
        titleLabel.font = SYSTEMFONT(15);
        [cell addSubview:titleLabel];
        
        UILabel *playNumLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
        playNumLabel1.text = @"播放: ";
        playNumLabel1.textColor = RGB(101, 101, 101);
        playNumLabel1.font = SYSTEMFONT(12);
        [playNumLabel1 sizeToFit];
        [cell addSubview:playNumLabel1];
        UILabel *playNumLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playNumLabel1.frame), CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
        playNumLabel2.text = playNum;
        playNumLabel2.textColor = RGB(255, 153, 0);
        playNumLabel2.font = SYSTEMFONT(12);
        [playNumLabel2 sizeToFit];
        [cell addSubview:playNumLabel2];
        UILabel *playNumLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playNumLabel2.frame), CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
        playNumLabel3.text = @"次";
        playNumLabel3.textColor = RGB(101, 101, 101);
        playNumLabel3.font = SYSTEMFONT(12);
        [playNumLabel3 sizeToFit];
        [cell addSubview:playNumLabel3];
        
        UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playNumLabel3.frame) + 30, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0)];
        teacherLabel.text = [NSString stringWithFormat:@"讲师: %@",teacherName];
        teacherLabel.textColor = RGB(101, 101, 101);
        teacherLabel.font = SYSTEMFONT(12);
        [teacherLabel sizeToFit];
        [cell addSubview:teacherLabel];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width-10, 0.5)];
        line.backgroundColor = BORDER_COLOR;
        [cell addSubview:line];
        cell.userInteractionEnabled = YES;
        cell.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCourse:)];
        [cell addGestureRecognizer:tap];
        
        [view_1 addSubview:cell];
    }
    
    //讲师排名
    view_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, Main_Screen_Width - 10, 70 * 4)];
    view_2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:view_2];
    
    for (int i = 0; i < teacherList.count; i++) {
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 70*i, Main_Screen_Width - 10, 70)];
        
        NSDictionary *dic = [teacherList objectAtIndex:i];
        NSString *teacherName = [dic objectForKey:@"TEAHCER_NAME"];
        NSString *type = [dic objectForKey:@"TYPE"];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        NSString *img = [dic objectForKey:@"IMG"];
        NSNumber *courseNum = [dic objectForKey:@"COURSE_NUM"];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [imageview setImageWithURL:[NSURL URLWithString:img]];
        [cell addSubview:imageview];
        ViewRadius(imageview, 25);
        
        UILabel *teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 0, 0)];
        teacherNameLabel.font = SYSTEMFONT(15);
        teacherNameLabel.textColor = RGB(51, 51, 51);
        teacherNameLabel.text = teacherName;
        [teacherNameLabel sizeToFit];
        [cell addSubview:teacherNameLabel];
        
        UILabel *courseNumLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 0, 0)];
        courseNumLabel1.text = @"微课: ";
        courseNumLabel1.textColor = RGB(101, 101, 101);
        courseNumLabel1.font = SYSTEMFONT(12);
        [courseNumLabel1 sizeToFit];
        [cell addSubview:courseNumLabel1];
        UILabel *courseNumLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(courseNumLabel1.frame), 40, 0, 0)];
        courseNumLabel2.text = [NSString stringWithFormat:@"%d",[courseNum intValue]];
        courseNumLabel2.textColor = RGB(255, 153, 0);
        courseNumLabel2.font = SYSTEMFONT(12);
        [courseNumLabel2 sizeToFit];
        [cell addSubview:courseNumLabel2];
        UILabel *courseNumLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(courseNumLabel2.frame), 40, 0, 0)];
        courseNumLabel3.text = @"节";
        courseNumLabel3.textColor = RGB(101, 101, 101);
        courseNumLabel3.font = SYSTEMFONT(12);
        [courseNumLabel3 sizeToFit];
        [cell addSubview:courseNumLabel3];
        
        UILabel *subjectNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(courseNumLabel3.frame) + 30, 40, 0, 0)];
        subjectNameLabel.text = [NSString stringWithFormat:@"%@",type];
        subjectNameLabel.textColor = RGB(101, 101, 101);
        subjectNameLabel.font = SYSTEMFONT(12);
        [subjectNameLabel sizeToFit];
        [cell addSubview:subjectNameLabel];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width-10, 0.5)];
        line.backgroundColor = BORDER_COLOR;
        [cell addSubview:line];
        cell.userInteractionEnabled = YES;
        cell.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTeacher:)];
        [cell addGestureRecognizer:tap];
        [view_2 addSubview:cell];
    }
    
    [view1 bringSubviewToFront:view_1];
    
    
    [myScrollView addSubview:wkfybView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wkfybView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    maxY = CGRectGetMaxY(line.frame);
    [myScrollView setContentSize:CGSizeMake(Main_Screen_Width, maxY)];
    
}

-(void)tapCourse:(UIGestureRecognizer *)recog{
    NSDictionary *dic = [courseList objectAtIndex:recog.view.tag];
    NSString *courseId = [dic objectForKey:@"COURSE_ID"];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = courseId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tapTeacher:(UIGestureRecognizer *)recog{
    NSDictionary *dic = [teacherList objectAtIndex:recog.view.tag];
    NSString *teacherId = [dic objectForKey:@"ID"];
    TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] init];
    vc.teacherId = teacherId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tap:(UIGestureRecognizer *)recog{
    if (recog.view.tag == 1) {
        label1.textColor = RGB(0, 150, 230);
        line1.backgroundColor = RGB(0, 150, 230);
        label2.textColor = RGB(51, 51, 51);
        line2.backgroundColor = [UIColor clearColor];
        [view1 bringSubviewToFront:view_1];
    }
    if (recog.view.tag == 2) {
        label1.textColor = RGB(51, 51, 51);
        line1.backgroundColor = [UIColor clearColor];
        label2.textColor = RGB(0, 150, 230);
        line2.backgroundColor = RGB(0, 150, 230);
        [view1 bringSubviewToFront:view_2];
    }
}

//加载必修课程
-(void)initBixiuData{
    
    [bixiuScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (secondDataSource.count == 0) {
        return;
    }
    
    NSDictionary *secDic = [secondDataSource objectAtIndex:secondIndex];
    NSString *name = [secDic objectForKey:@"SUBJECT_NAME"];
    CGRect rect = CGRectMake(0, 0, 0, 0);
    CGFloat x = 0;
    for (int i = 0; i < thirdDataSource.count; i++) {
        NSDictionary *dic = [thirdDataSource objectAtIndex:i];
        NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
        NSNumber *isPack = [dic objectForKey:@"is_pack"];
        NSString *price = [dic objectForKey:@"price"];
        NSNumber *course_num = [dic objectForKey:@"course_num"];
        DLog(@"%@",dic);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + 5, 10, 130, 80)];
        [btn setTitle:[NSString stringWithFormat:@"%@%@\n共%d节",name,subjectName,[course_num intValue]] forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        [btn setBackgroundImage:[UIImage imageWithColor:RGB(86, 189, 238) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        ViewBorderRadius(btn, 10, 0, [UIColor whiteColor]);
        NSString *btnStr = btn.titleLabel.text;
        NSRange range = [btnStr rangeOfString:@"\n"];
        //字体
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, range.location)];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(range.location, btnStr.length - range.location)];
        //行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [btnStr length])];
        btn.titleLabel.attributedText = noteStr;
        btn.tag = i;
        [btn addTarget:self action:@selector(bixiuClick:) forControlEvents:UIControlEventTouchUpInside];
        [bixiuScrollView addSubview:btn];
        
        if (i == 0) {
            rect = btn.frame;
        }
        
        if ([isPack intValue] == 0) {
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 12, CGRectGetWidth(btn.frame), 11)];
            btnLabel.text = @"暂时没有打包";
            btnLabel.textAlignment = NSTextAlignmentCenter;
            btnLabel.font = SYSTEMFONT(14);
            [bixiuScrollView addSubview:btnLabel];
        }else if ([isPack intValue] == 1){
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 12, CGRectGetWidth(btn.frame), 11)];
            NSString *str = [NSString stringWithFormat:@"打包购买%@",price];
//            btnLabel.text = [NSString stringWithFormat:@"打包购买讲解点%@",price];
            btnLabel.textAlignment = NSTextAlignmentCenter;
            btnLabel.font = SYSTEMFONT(14);
            
            
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:RGB(255, 153, 0)
                                  range:NSMakeRange(4, str.length-4)];
            btnLabel.attributedText = AttributedStr;
            btnLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyPackage:)];
            btnLabel.tag = i;
            [btnLabel addGestureRecognizer:tap];
            [bixiuScrollView addSubview:btnLabel];
        }
        
        
        
        x = CGRectGetMaxX(btn.frame) + 5;
    }
    [bixiuScrollView setContentSize:CGSizeMake(x, CGRectGetHeight(bixiuScrollView.frame))];
    rect.origin.x -= 5;
    [bixiuScrollView scrollRectToVisible:rect animated:YES];
}

-(void)showFreeCourse:(UIButton *)btn{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"price_asc" forKey:@"oby"];
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"1",@"param2":param}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//必修点击
-(void)bixiuClick:(UIButton *)btn{
    
    NSDictionary *dic = [secondDataSource objectAtIndex:secondIndex];
    NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
//    DLog(@"%@",dic);
    
    
    NSDictionary *info = [thirdDataSource objectAtIndex:btn.tag];
    NSString *bixiuSubjectId = [info objectForKey:@"SUBJECT_ID"];
//    DLog(@"%@",info);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:subjectId forKey:@"kemu"];
    [param setObject:[NSNumber numberWithInteger:secondIndex+1] forKey:@"kemuIndex"];
    [param setObject:bixiuSubjectId forKey:@"bixiu"];
    [param setObject:[NSNumber numberWithInteger:btn.tag] forKey:@"bixiuIndex"];
    
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"1",@"param":param}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//加载首页顶部幻灯片
-(void)loadData1{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_top_ad_img"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            adImagesArray = [NSArray arrayWithArray:array];
            [self loadSuccess];
//            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页最新动态
-(void)loadData2{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_news"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            newsArray = [result objectForKey:@"data_list"];
            [self loadSuccess];
//            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页精品推荐
-(void)loadData3{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_rec_courses"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            recCoursecArray = [result objectForKey:@"data_list"];
            [self loadSuccess];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页免费体验
-(void)loadData4{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_free_courses"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            freeCoursesArray = [result objectForKey:@"data_list"];
            [self loadSuccess];
//            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页中间广告图
-(void)loadData5{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_center_ad_img"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            centerAdImagesArray = [result objectForKey:@"data_list"];
            [self loadSuccess];
//            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页名师推荐
-(void)loadData6{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_recommend_teacher"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            recommendTeacherArray = [result objectForKey:@"data_list"];
            [self loadSuccess];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页课程排名
-(void)loadData7{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_course_by_playtime"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            courseList = [result objectForKey:@"data_list"];
            [self loadSuccess];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

//加载首页课程排名
-(void)loadData8{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/welcome/get_teacher_by_pay"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            requestNum++;
            NSDictionary *result = [dic objectForKey:@"result"];
            teacherList = [result objectForKey:@"data_list"];
            [self loadSuccess];
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@",error.description);
    }];
}

-(void)buyPackage:(UIGestureRecognizer *)recog{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    if (!userInfo) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买讲解点" message:@"游客登录购买系统为当前设备随机分配账号登录购买" preferredStyle:UIAlertControllerStyleAlert];
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
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSDictionary *package = [thirdDataSource objectAtIndex:recog.view.tag];
    DLog(@"%@",package);
    NSString *price = [package objectForKey:@"price"];
    NSString *SUBJECT_NAME = [package objectForKey:@"SUBJECT_NAME"];
    NSString *SUBJECT_ID = [package objectForKey:@"SUBJECT_ID"];
    
    NSString *title = [NSString stringWithFormat:@"确认花费%@讲解点打包购买%@吗?",price,SUBJECT_NAME];

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self alipayPayByPackage:SUBJECT_ID];
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self weixinPayByPackage:SUBJECT_ID];
//        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"余额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self yuePayByPackage:SUBJECT_ID];
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action1];
//        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action4];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action2];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

-(void)yuePayByPackage:(NSString *)subjectId{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"balance" forKey:@"pay_type"];
    [param setObject:subjectId forKey:@"subject_id"];
    
    
    [param setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/payment_pack/goto_pay"];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud];
        DLog(@"%@",responseObject);
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            //            NSDictionary *result = [dic objectForKey:@"result"];
            
//            [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj removeFromSuperview];
//            }];
//            [self loadData];
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

-(void)alipayPayByPackage:(NSString *)subjectId{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"alipay" forKey:@"pay_type"];
    [param setObject:subjectId forKey:@"subject_id"];
   
    
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
                
//                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [obj removeFromSuperview];
//                }];
//                [self loadData];
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

-(void)weixinPayByPackage:(NSString *)subjectId{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    if (!userInfo) {
        [self showHintInView:self.view hint:@"请先登录"];
        return;
    }
    [self showHudInView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"wechat" forKey:@"pay_type"];
    [param setObject:subjectId forKey:@"subject_id"];
    
    
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
                
//                [_myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [obj removeFromSuperview];
//                }];
//                [self loadData];
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

-(void)toNewsDetail:(UITapGestureRecognizer *)recog{
    NSDictionary *info = [newsArray objectAtIndex:recog.view.tag];
    NSString *articleId = [info objectForKey:@"ARTICLE_ID"];
    NSString *title = [info objectForKey:@"TITLE"];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
    vc.newsId = articleId;
    vc.title = title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)toClassDetail:(UITapGestureRecognizer *)recog{
    NSDictionary *info = [recCoursecArray objectAtIndex:recog.view.tag];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = [info objectForKey:@"COURSE_ID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)toFreeClassDetail:(UITapGestureRecognizer *)recog{
    NSDictionary *info = [freeCoursesArray objectAtIndex:recog.view.tag];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = [info objectForKey:@"COURSE_ID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)toTeacherDetail:(UITapGestureRecognizer *)recog{
    NSDictionary *info = [recommendTeacherArray objectAtIndex:recog.view.tag];
    TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] init];
    vc.teacherId = [info objectForKey:@"ID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (action2Tag == 1) {
        TeacherViewController *vc = [[TeacherViewController alloc] init];
        vc.top_search_key = _searchBar.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"searchValue":_searchBar.text,@"a":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
    
}

#pragma mark - HZSigmentViewDelegate

-(void)segment:(HZSigmentView *)sengment didSelectColumnIndex:(NSInteger)index {
    
    secondIndex = index-1;
    NSDictionary *dic = [secondDataSource objectAtIndex:index-1];
    NSString *subjectId = [dic objectForKey:@"SUBJECT_ID"];
    [self loadThreeClass:subjectId];
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
