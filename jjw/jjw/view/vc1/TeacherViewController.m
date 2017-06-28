//
//  TeacherViewController.m
//  jjw
//
//  Created by ylc on 2017/5/26.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "TeacherViewController.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "TeacherCollectionViewCell.h"
#import "LrdSuperMenu.h"
#import "TeacherHomeViewController.h"

@interface TeacherViewController ()<LrdSuperMenuDataSource, LrdSuperMenuDelegate>{
    NSMutableArray *dataSource;
    int page;
    int loadTypeCount;
    
    NSString *type_one;
    NSString *type_two;
    
    NSMutableArray *typeOneDataSource;
    NSMutableArray *typeTwoDataSource;
}

@property (nonatomic, strong) LrdSuperMenu *menu;

@end

@implementation TeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"TeacherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"teacherCell"];
    
    _myCollectionView.backgroundColor = RGB(245, 245, 245);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"主讲讲师";
    
    dataSource = [NSMutableArray array];
    typeOneDataSource = [NSMutableArray array];
    typeTwoDataSource = [NSMutableArray array];
    loadTypeCount = 0;
    
    type_one = @"";
    type_two = @"";
    
    [self getOneType];
    [self getTwoType];
    
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    [_myCollectionView.mj_header beginRefreshing];
}

-(void)getOneType{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/get_one_type"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myCollectionView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            loadTypeCount++;
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [typeOneDataSource removeAllObjects];
            
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"SUBJECT_ID",@"年级",@"SUBJECT_NAME", nil];
//            [typeOneDataSource addObject:dic];
            [typeOneDataSource addObjectsFromArray:array];
            
            
            DLog(@"%@",responseObject);
            [self initTopView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)getTwoType{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/get_two_type"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myCollectionView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            loadTypeCount++;
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [typeTwoDataSource removeAllObjects];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"SUBJECT_ID",@"学科",@"SUBJECT_NAME", nil];
//            [typeTwoDataSource addObject:dic];
            [typeTwoDataSource addObjectsFromArray:array];
            
            
            DLog(@"%@",responseObject);
            [self initTopView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
}

-(void)loadData{
    page = 1;
    
    [_myCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:type_one forKey:@"type_one"];
    [param setObject:type_two forKey:@"type_two"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    if (_top_search_key) {
        [param setObject:_top_search_key forKey:@"top_search_key"];
    }
    
    DLog(@"%@",param);
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
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/index"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:type_one forKey:@"type_one"];
    [param setObject:type_two forKey:@"type_two"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    if (_top_search_key) {
        [param setObject:_top_search_key forKey:@"top_search_key"];
    }
    
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
            
            
//            DLog(@"%@",responseObject);
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

-(void)initTopView{
    if (loadTypeCount == 2) {
        _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
        _menu.delegate = self;
        _menu.dataSource = self;
        [self.view addSubview:_menu];
        [_menu reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - LrdSuperMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 2;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return typeOneDataSource.count;
    }else if(column == 1) {
        return typeTwoDataSource.count;
    }else {
        return 0;
    }
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        NSDictionary *dic3 = [typeOneDataSource objectAtIndex:indexPath.row];
        NSString *name3 = [dic3 objectForKey:@"SUBJECT_NAME"];
        return name3;
    }else if(indexPath.column == 1) {
        NSDictionary *dic4 = [typeTwoDataSource objectAtIndex:indexPath.row];
        NSString *name4 = [dic4 objectForKey:@"SUBJECT_NAME"];
        return name4;
    }else {
        return @"";
    }
}

//- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
//    if (indexPath.column == 0 || indexPath.column == 1) {
//        return @"baidu";
//    }
//    return nil;
//}
//
//- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
//    if (indexPath.column == 0 && indexPath.item >= 0) {
//        return @"baidu";
//    }
//    return nil;
//}
//
//- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
//    return @"bbbbb";
//}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return @"";
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return nil;
}

#pragma mark - LrdSuperMenuDelegate

- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (indexPath.row > 0) {
            [self showHintInView:self.view hint:@"初中、小学部分即将推出"];
        }else{
            NSDictionary *dic3 = [typeOneDataSource objectAtIndex:indexPath.row];
            NSString *name3 = [dic3 objectForKey:@"SUBJECT_ID"];
            type_one = name3;
        }
        
        
    }
    if (indexPath.column == 1) {
        NSDictionary *dic4 = [typeTwoDataSource objectAtIndex:indexPath.row];
        NSString *name4 = [dic4 objectForKey:@"SUBJECT_ID"];
        type_two = name4;
    }
    [self loadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"teacherCell" forIndexPath:indexPath];
    
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.education.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = cell.education.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.education.layer.mask = maskLayer;
    
    ViewBorderRadius(cell, 0, 1, BORDER_COLOR);
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat imgWidth = width - 20;
    
    ViewBorderRadius(cell.headImageView, imgWidth/2, 0, BORDER_COLOR);

    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];

    NSString *img = [info objectForKey:@"PIC_PATH"];
    NSString *teacher_name = [info objectForKey:@"NAME"];
    NSString *f_type = [info objectForKey:@"f_type"];
//    NSString *subject_name = [info objectForKey:@"subject_name"];
    NSString *course_num = [info objectForKey:@"course_num"];
    NSString *study_num = [info objectForKey:@"study_num"];
    NSString *des = [info objectForKey:@"CAREER"];
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:img]];
    cell.name.text = teacher_name;
    cell.education.text = [NSString stringWithFormat:@"%@",f_type];
    
    if ([cell.education.text isEqualToString:@"高中数学"]) {
        cell.education.backgroundColor = RGB(245, 123, 40);
    }else if ([cell.education.text isEqualToString:@"高中英语"]) {
        cell.education.backgroundColor = RGB(223, 10, 200);
    }else if ([cell.education.text isEqualToString:@"高中物理"]) {
        cell.education.backgroundColor = RGB(34, 60, 170);
    }else if ([cell.education.text isEqualToString:@"高中化学"]) {
        cell.education.backgroundColor = RGB(48, 177, 136);
    }else if ([cell.education.text isEqualToString:@"高中生物"]) {
        cell.education.backgroundColor = RGB(154, 103, 37);
    }else if ([cell.education.text isEqualToString:@"高中政治"]) {
        cell.education.backgroundColor = RGB(133, 195, 6);
    }else if ([cell.education.text isEqualToString:@"高中历史"]) {
        cell.education.backgroundColor = RGB(234, 154, 39);
    }else if ([cell.education.text isEqualToString:@"高中地理"]) {
        cell.education.backgroundColor = RGB(160, 6, 16);
    }
    
    
    
    cell.des.text = des;
    
    
    cell.weike.text = [NSString stringWithFormat:@"%d节微课|%d人学习",[course_num intValue],[study_num intValue]];
    

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat imgWidth = width - 20;
    return CGSizeMake(width, 178 + imgWidth);
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
    NSString *teacherId = [info objectForKey:@"ID"];
    TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] init];
    vc.teacherId = teacherId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
