//
//  Class2ViewController.m
//  jjw
//
//  Created by ylc on 2017/10/21.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "Class2ViewController.h"
#import "MJRefresh.h"
#import "CollectionViewCell2.h"
#import "ClassDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Color.h"

@interface Class2ViewController (){
    NSMutableArray *dataSource;
    int page;
    
    NSString *osid;//一级分类：高中、初中、小学
    
    NSString *tsid;//二级分类：语文，数学，外语，政治，等
    
    NSString *ttsid;//三级分类：必修一，必修二，必修三，等
    
    NSString *tttsid;//四级分类：3．2 简单的三角恒等变换，等
    
    NSString *ctype;//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评

}

@end

@implementation Class2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_myCollectionView registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:@"collectionViewCell2"];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell2"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    dataSource = [NSMutableArray array];
    osid = @"268";
    tsid = @"210";
    ttsid = @"0";
    tttsid = @"0";
    ctype = @"0";
    
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    _myCollectionView.mj_footer.automaticallyHidden = YES;
    
    [_myCollectionView.mj_header beginRefreshing];
}

-(void)loadData{
    page = 1;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,_action];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:osid forKey:@"osid"];//一级分类：高中、初中、小学
    [param setObject:tsid forKey:@"tsid"];//二级分类：语文，数学，外语，政治，等
    [param setObject:ttsid forKey:@"ttsid"];//三级分类：必修一，必修二，必修三，等
    [param setObject:tttsid forKey:@"tttsid"];//四级分类：3．2 简单的三角恒等变换，等
    
    [param setObject:ctype forKey:@"ctype"];//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评
    [param setObject:@"" forKey:@"oby"];//new：发布时间降序，look：浏览次数降序，price：价格降序，price_asc：价格升序
    [param setObject:@"" forKey:@"search_key"];//搜索关键词
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    
    DLog(@"loadData %@",param);
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
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page == [pageTotal intValue]) {
                [_myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            //            DLog(@"%@",responseObject);
        }else{
            if ([code isEqualToString:@"401"]){
                [dataSource removeAllObjects];
                [_myCollectionView reloadData];
                [self showHintInView:self.view hint:@"暂无法搜索到相关的课程"];
            }
            
            [_myCollectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myCollectionView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.localizedDescription];
        DLog(@"%@",error.description);
    }];
    
}

-(void)loadMore{
    page ++;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,_action];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:osid forKey:@"osid"];//一级分类：高中、初中、小学
    [param setObject:tsid forKey:@"tsid"];//二级分类：语文，数学，外语，政治，等
    [param setObject:ttsid forKey:@"ttsid"];//三级分类：必修一，必修二，必修三，等
    [param setObject:tttsid forKey:@"tttsid"];//四级分类：3．2 简单的三角恒等变换，等
    
    [param setObject:ctype forKey:@"ctype"];//课程分类：3:同步课程,5:方法建模,6:题型突破,9:习题讲评
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [cell.topImageView setImageWithURL:[NSURL URLWithString:LOGO] placeholderImage:[UIImage imageWithColor:RGB(220, 220, 220) size:CGSizeMake(10, 10)]];
    cell.teacherLabel.text = teacher_name;
    cell.titleLabel.text = TITLE;
    cell.lessionNumLabel.text = LESSION_NUM;
    cell.playTimesLabel.text = play_times;
    cell.priceLabel.text = [NSString stringWithFormat:@"讲解点%@",CURRENT_PRICE];
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
    
    
    //    DetailViewController *vc = [[DetailViewController alloc] init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
