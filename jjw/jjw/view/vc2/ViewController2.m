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

@interface ViewController2 (){
    NSMutableArray *dataSource;
}

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_myCollectionView registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:@"collectionViewCell2"];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell2"];
    
    _myCollectionView.backgroundColor = RGB(245, 245, 245);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    dataSource = [NSMutableArray array];
    
    [self initUI];
    
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [_myCollectionView.mj_header beginRefreshing];
    
//    [self loadTest2];
}

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
            
            DLog(@"%@",responseObject);
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/course/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"268" forKey:@"osid"];//一级分类：高中、初中、小学
    [param setObject:@"" forKey:@"tsid"];//二级分类：语文，数学，外语，政治，等
    [param setObject:@"" forKey:@"ttsid"];//三级分类：必修一，必修二，必修三，等
    [param setObject:@"" forKey:@"tttsid"];//四级分类：3．2 简单的三角恒等变换，等
    
    [param setObject:@"" forKey:@"ctype"];//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评
    [param setObject:@"" forKey:@"oby"];//new：发布时间降序，look：浏览次数降序，price：价格降序，price_asc：价格升序
    [param setObject:@"" forKey:@"search_key"];//搜索关键词
    [param setObject:@"1" forKey:@"page"];//当前第几页
    
    
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
            
           
            DLog(@"%@",responseObject);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myCollectionView.mj_header endRefreshing];
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
    vc.info = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
