//
//  ViewController2.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController2.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "CollectionViewCell2.h"
#import "ClassDetailViewController.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "WJDropdownMenu.h"

@interface ViewController2 ()<WJMenuDelegate>{
    NSMutableArray *dataSource;
    int page;
    
    NSString *osid;//一级分类：高中、初中、小学
}

@property (nonatomic,weak) WJDropdownMenu *menu;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  如果是有导航栏请清除自动适应设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_myCollectionView registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:@"collectionViewCell2"];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell2"];
    
    _myCollectionView.backgroundColor = RGB(245, 245, 245);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    dataSource = [NSMutableArray array];
    
    [self initMenu];
    [self initUI];
    
    osid = @"268";
    
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    [_myCollectionView.mj_header beginRefreshing];
    
    [self loadTest];
    [self loadTest2];
}

-(void)initMenu{
    
    
//    NSArray *threeMenuTitleArray =  @[@"菜单A",@"菜单B"];
    
    // 创建menu
    WJDropdownMenu *menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 40)];
    menu.delegate = self;         //  设置代理
    [self.view addSubview:menu];
    self.menu = menu;
    
    // 设置属性(可不设置)
    menu.caverAnimationTime = 0.2;             //  增加了展开动画时间设置   不设置默认是  0.15
    menu.hideAnimationTime = 0.2;              //  增加了缩进动画时间设置   不设置默认是  0.15
    menu.menuTitleFont = 12;                   //  设置menuTitle字体大小    不设置默认是  11
    menu.tableTitleFont = 11;                  //  设置tableTitle字体大小   不设置默认是  10
    menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
    menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
    menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
    menu.menuButtonTag = 100;                  //  menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
    menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    menu.selectedColor = [UIColor redColor];   //  选中的字体颜色
    menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
    
#warning 此处有两种方法导入数据 1.第一种是直接导入菜单一级子菜单二级子菜单三级子菜单的所有数据  2.第二种是根据每次点击index的请求数据后返回下一菜单的数据时导入数据一级一级联动的网络请求数据所有的方法都是以net开头
    // 第一种方法一次性导入所有菜单数据
        [self createAllMenuData];
    
    // 第二中方法net网络请求一级一级导入数据，先在此导入菜单数据，然后分别再后面的net开头的代理方法中导入一级一级子菜单的数据
//    [menu netCreateMenuTitleArray:threeMenuTitleArray];
}

- (void)createAllMenuData{
    NSArray *threeMenuTitleArray =  @[@"菜单A",@"菜单B",@"菜单C"];
    //  创建第一个菜单的first数据second数据
    NSArray *firstArrOne = [NSArray arrayWithObjects:@"A一级菜单1",@"A一级菜单2",@"A一级菜单3", nil];
    NSArray *firstMenu = [NSArray arrayWithObject:firstArrOne];
    
    //  创建第二个菜单的first数据second数据
    NSArray *firstArrTwo = [NSArray arrayWithObjects:@"B一级菜单1",@"B一级菜单2", nil];
    NSArray *secondArrTwo = @[@[@"B二级菜单11",@"B二级菜单12"],@[@"B二级菜单21",@"B二级菜单22"]];
    //    NSArray *thirdArrTwo = @[@[@"B三级菜单11-1",@"B三级菜单11-2",@"B三级菜单11-3"],@[@"B三级菜单12-1",@"B三级菜单12-2"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[@"B三级菜单22-1",@"B三级菜单22-2"]];
    NSArray *thirdArrTwo = @[@[@"B三级菜单11-1",@"B三级菜单11-2",@"B三级菜单11-3"],@[@"B三级菜单12-1",@"B三级菜单12-2"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[]];
    NSArray *secondMenu = [NSArray arrayWithObjects:firstArrTwo,secondArrTwo,thirdArrTwo, nil];
    
    //  创建第三个菜单的first数据second数据
    NSArray *firstArrThree = [NSArray arrayWithObjects:@"C一级菜单1",@"C一级菜单2", nil];
    NSArray *secondArrThree = @[@[@"C二级菜单11",@"C二级菜单12"],@[]];
    //    NSArray *secondArrThree = @[@[@"C二级菜单11",@"C二级菜单12"],@[@"C二级菜单21",@"C二级菜单22",@"C二级菜单23",@"C二级菜单24"]];
    NSArray *threeMenu = [NSArray arrayWithObjects:firstArrThree,secondArrThree, nil];
    
    [self.menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstMenu SecondArr:secondMenu threeArr:threeMenu];
}

#pragma mark -- 代理方法1 返回点击时对应的index

- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex secondIndex:(NSInteger)secondIndex thirdIndex:(NSInteger)thirdIndex{
    NSLog(@"菜单数:%ld      一级菜单数:%ld      二级子菜单数:%ld  三级子菜单:%ld",MenuTitleIndex,firstIndex,secondIndex,thirdIndex);
    
};


#pragma mark -- 代理方法2 返回点击时对应的内容
- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent{
    
    NSLog(@"菜单title:%@       一级菜单:%@         二级子菜单:%@    三级子菜单:%@",MenuTitle,firstContent,secondContent,thirdContent);
    
    
//    self.data = [NSMutableArray array];
//    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 1",secondContent]];
//    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 2",secondContent]];
//    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 3",secondContent]];
//    [self.tableView reloadData];
    
};

#pragma mark -- 代理方法3 返回点击时对应的内容和index(合并了方法1和方法2)
- (void)menuCellDidSelected:(NSString *)MenuTitle menuIndex:(NSInteger)menuIndex firstContent:(NSString *)firstContent firstIndex:(NSInteger)firstIndex secondContent:(NSString *)secondContent secondIndex:(NSInteger)secondIndex thirdContent:(NSString *)thirdContent thirdIndex:(NSInteger)thirdIndex{
    NSLog(@"菜单title:%@  titleIndex:%ld,一级菜单:%@    一级菜单Index:%ld,     二级子菜单:%@   二级子菜单Index:%ld   三级子菜单:%@  三级子菜单Index:%ld",MenuTitle,menuIndex,firstContent,firstIndex,secondContent,secondIndex,thirdContent,thirdIndex);
}

// ------------------------------------------  以下是网络点击联动的代理方法可在此一级一级的导入数据，测试方法请打开 if 0 -------------------

#if 0

#pragma mark -- net网络获取数据代理方法返回点击时菜单对应的index(导入子菜单数据)
- (void)netMenuClickMenuIndex:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle{
    
    // 模拟网络加载数据延时0.5秒，相当于传一个menuIndex的参数返回数据之后 调用netLoadFirstArray方法，将网络请求返回数据导入一级数据到菜单
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (menuIndex == 0) {
            
            NSArray *firstArrTwo = [NSArray arrayWithObjects:@"A一级菜单1",@"A一级菜单2", nil];
            [self.menu netLoadFirstArray:firstArrTwo];
            
        }
        if (menuIndex == 1) {
            NSArray *firstArrTwo = [NSArray arrayWithObjects:@"B一级菜单1",@"B一级菜单2", nil];
            [self.menu netLoadFirstArray:firstArrTwo];
        }
        if (menuIndex == 2) {
            NSArray *firstArrTwo = [NSArray arrayWithObjects:@"C一级菜单1",@"C一级菜单2", nil];
            [self.menu netLoadFirstArray:firstArrTwo];
        }
    });
}


#pragma mark -- net网络获取数据代理方法返回点击时菜单和一级子菜单分别对应的index(导入子菜单数据)
- (void)netMenuClickMenuIndex:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle FirstIndex:(NSInteger)FirstIndex firstContent:(NSString *)firstContent{
    
    // 模拟网络加载数据延时0.5秒，相当于传menuIndex、FirstIndex的两个参数返回数据之后，调用 netLoadSecondArray 方法，将网络请求返回数据导入二级数据到菜单
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (menuIndex == 0) {
            if (FirstIndex == 0) {
                NSArray *secondArrTwo = @[@"A二级菜单11",@"A二级菜单12",@"A二级菜单13",@"A二级菜单14",@"A二级菜单15",@"A二级菜单16",@"A二级菜单17",@"A二级菜单18",@"A二级菜单19",@"A二级菜单20",@"A二级菜单11",@"A二级菜单12",@"A二级菜单13",@"A二级菜单14",@"A二级菜单15",@"A二级菜单16",@"A二级菜单17",@"A二级菜单18",@"A二级菜单19",@"A二级菜单20"];
                [self.menu netLoadSecondArray:secondArrTwo];
            }
            if (FirstIndex == 1) {
                NSArray *secondArrTwo = @[@"A二级菜单21",@"A二级菜单22"];
                [self.menu netLoadSecondArray:secondArrTwo];
            }
        }
        if (menuIndex == 1) {
            if (FirstIndex == 0) {
                NSArray *secondArrTwo = @[@"B二级菜单11",@"B二级菜单12"];
                [self.menu netLoadSecondArray:secondArrTwo];
            }
            if (FirstIndex == 1) {
                NSArray *secondArrTwo = @[@"B二级菜单21",@"B二级菜单22"];
                [self.menu netLoadSecondArray:secondArrTwo];
            }
        }
        if (menuIndex == 2) {
            if (FirstIndex == 0) {
                NSArray *secondArrTwo = @[@"C二级菜单11",@"C二级菜单12"];
                [self.menu netLoadSecondArray:secondArrTwo];
                
            }
            if (FirstIndex == 1) {
                NSArray *secondArrTwo = @[@"C二级菜单21",@"C二级菜单22"];
                [self.menu netLoadSecondArray:secondArrTwo];
            }
        }
        
    });
}


#endif

//获取课程一级分类
-(void)loadTest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_one_class"];
    
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            DLog(@"课程一级分类%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
    }];
}

//获得课程下级分类
-(void)loadTest2{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/get_next_class"];
    
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
    }];
}


-(void)loadData{
    page = 1;
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:osid forKey:@"osid"];//一级分类：高中、初中、小学
    [param setObject:@"" forKey:@"tsid"];//二级分类：语文，数学，外语，政治，等
    [param setObject:@"" forKey:@"ttsid"];//三级分类：必修一，必修二，必修三，等
    [param setObject:@"" forKey:@"tttsid"];//四级分类：3．2 简单的三角恒等变换，等
    
    [param setObject:@"" forKey:@"ctype"];//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评
    [param setObject:@"" forKey:@"oby"];//new：发布时间降序，look：浏览次数降序，price：价格降序，price_asc：价格升序
    [param setObject:@"" forKey:@"search_key"];//搜索关键词
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myCollectionView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [_myCollectionView.mj_footer resetNoMoreData];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            [_myCollectionView reloadData];
            
            NSNumber *pageTotal = [responseObject objectForKey:@"page_total"];
            if (page == [pageTotal intValue]) {
                [_myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
           
            DLog(@"%@",responseObject);
        }else{
            [_myCollectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myCollectionView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
    
}

-(void)loadMore{
    page ++;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:osid forKey:@"osid"];//一级分类：高中、初中、小学
    [param setObject:@"" forKey:@"tsid"];//二级分类：语文，数学，外语，政治，等
    [param setObject:@"" forKey:@"ttsid"];//三级分类：必修一，必修二，必修三，等
    [param setObject:@"" forKey:@"tttsid"];//四级分类：3．2 简单的三角恒等变换，等
    
    [param setObject:@"" forKey:@"ctype"];//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评
    [param setObject:@"" forKey:@"oby"];//new：发布时间降序，look：浏览次数降序，price：价格降序，price_asc：价格升序
    [param setObject:@"" forKey:@"search_key"];//搜索关键词
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [dataSource addObjectsFromArray:array];
            [_myCollectionView reloadData];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page >= [pageTotal intValue]) {
                [_myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_myCollectionView.mj_footer endRefreshing];
            }
            
            
            DLog(@"%@",responseObject);
        }else{
            [_myCollectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myCollectionView.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
    
}

-(void)initUI{
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
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, 6, Main_Screen_Width - CGRectGetMaxX(btn2.frame) - 28, 28)];
    ViewRadius(searchBar, 5);
    [navView addSubview:searchBar];
    self.navigationItem.titleView = navView;
    
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


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell2" forIndexPath:indexPath];
    ViewBorderRadius(cell, 0, 1, BORDER_COLOR);
    ViewBorderRadius(cell.topImageView, 5, 0, BORDER_COLOR);
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    
    NSString *LOGO = [info objectForKey:@"LOGO"];
    NSString *teacher_name = [info objectForKey:@"teacher_name"];
    NSString *TITLE = [info objectForKey:@"TITLE"];
    NSString *CURRENT_PRICE = [info objectForKey:@"CURRENT_PRICE"];
    
    NSString *LESSION_NUM = [info objectForKey:@"LESSION_NUM"];
    NSString *play_times = [info objectForKey:@"play_times"];
    [cell.topImageView setImageWithURL:[NSURL URLWithString:LOGO]];
    cell.teacherLabel.text = teacher_name;
    cell.titleLabel.text = TITLE;
    cell.lessionNumLabel.text = LESSION_NUM;
    cell.playTimesLabel.text = play_times;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",CURRENT_PRICE];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat imgWidth = width - 10;
    CGFloat imgHeight = imgWidth * 2 / 3;
    return CGSizeMake(width, 5 + imgHeight + 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = [info objectForKey:@"COURSE_ID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
