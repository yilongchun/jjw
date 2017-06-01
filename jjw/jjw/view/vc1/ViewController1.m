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
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(2, 6, 60, 28)];
    [btn1 setTitle:@"高中" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMFONT(13);
    [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn1, 5, 0, [UIColor whiteColor]);
    [navView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, 6, 60, 28)];
    [btn2 setTitle:@"课程" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = SYSTEMFONT(13);
    [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn2, 5, 0, [UIColor whiteColor]);
    [navView addSubview:btn2];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, 6, Main_Screen_Width - CGRectGetMaxX(btn2.frame) - 28, 28)];
    ViewRadius(_searchBar, 5);
    _searchBar.delegate = self;
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
}

-(void)loadSuccess{
    DLog(@"%d",requestNum);
    if (requestNum == 6) {
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
    bixiuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 118)];
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
    [moreBtn addTarget:self action:@selector(bixiuClick:) forControlEvents:UIControlEventTouchUpInside];
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
//            NSString *subjectName = [dic objectForKey:@"SUBJECT_NAME"];
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
            kLabel.text = type;
            if (i == 1 || i ==2) {
                kLabel.backgroundColor = RGB(39, 68, 179);
                
            }
            if (i == 0) {
                kLabel.backgroundColor = RGB(242, 120, 120);
                
            }
            if (i == 3) {
                kLabel.backgroundColor = RGB(164, 114, 41);
                
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
    
    maxY = CGRectGetMaxY(line.frame);
    [myScrollView setContentSize:CGSizeMake(Main_Screen_Width, maxY)];
    
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
        [btn addTarget:self action:@selector(bixiuClick:) forControlEvents:UIControlEventTouchUpInside];
        [bixiuScrollView addSubview:btn];
        
        if (i == 0) {
            rect = btn.frame;
        }
        
        if ([isPack intValue] == 0) {
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 8, CGRectGetWidth(btn.frame), 11)];
            btnLabel.text = @"暂时没有打包";
            btnLabel.textAlignment = NSTextAlignmentCenter;
            btnLabel.font = SYSTEMFONT(14);
            [bixiuScrollView addSubview:btnLabel];
        }else if ([isPack intValue] == 1){
            UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 8, CGRectGetWidth(btn.frame), 11)];
            NSString *str = [NSString stringWithFormat:@"打包购买￥%@",price];
//            btnLabel.text = [NSString stringWithFormat:@"打包购买￥%@",price];
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

//必修点击
-(void)bixiuClick:(UIButton *)btn{
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"1"}];
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

-(void)buyPackage:(UIGestureRecognizer *)recog{
    NSDictionary *package = [thirdDataSource objectAtIndex:recog.view.tag];
    DLog(@"%@",package);
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
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"searchValue":_searchBar.text,@"a":@"1"}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
