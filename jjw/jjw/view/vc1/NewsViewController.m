//
//  NewsViewController.m
//  jjw
//
//  Created by ylc on 2017/5/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "NewsViewController.h"
#import "MJRefresh.h"
#import "NewsCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Color.h"
#import "NewsDetailViewController.h"

@interface NewsViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"NewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"newsCollectionViewCell"];
    self.title = @"新闻列表";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _myCollectionView.backgroundColor = RGB(245, 245, 245);
    dataSource = [NSMutableArray array];
    
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/news/index"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
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
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/news/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
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
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCollectionViewCell" forIndexPath:indexPath];
    ViewBorderRadius(cell, 0, 1, BORDER_COLOR);
    ViewBorderRadius(cell.topImageView, 5, 0, BORDER_COLOR);
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [info objectForKey:@"IMAGE_URL"];
    NSString *TITLE = [info objectForKey:@"TITLE"];
    
    [cell.topImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageWithColor:RGB(220, 220, 220) size:CGSizeMake(10, 10)]];
    cell.titleLabel.text = TITLE;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat imgWidth = width - 10;
    CGFloat imgHeight = imgWidth * 2 / 3;
    return CGSizeMake(width, 5 + imgHeight + 5 + 45);
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
    DLog(@"%@",info);
    NSString *articleId = [info objectForKey:@"ARTICLE_ID"];
    NSString *title = [info objectForKey:@"TITLE"];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
    vc.newsId = articleId;
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
