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

@interface ViewController2 ()

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
    
    
    [self initUI];
}

-(void)initUI{
    
    CGFloat barContentHeight = self.navigationController.navigationBar.frame.size.height - 20;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 60, barContentHeight + 4)];
    [btn1 setTitle:@"高中" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMFONT(13);
    [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn1, 5, 0, [UIColor whiteColor]);
    [self.navigationController.navigationBar addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, 8, 60, barContentHeight + 4)];
    [btn2 setTitle:@"课程" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = SYSTEMFONT(13);
    [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn2, 5, 0, [UIColor whiteColor]);
    [self.navigationController.navigationBar addSubview:btn2];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, 10, Main_Screen_Width - CGRectGetMaxX(btn2.frame) - 20, barContentHeight)];
    [self.navigationController.navigationBar addSubview:searchBar];
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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell2" forIndexPath:indexPath];
    ViewBorderRadius(cell, 0, 1, BORDER_COLOR);
 
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat imgWidth = width - 10;
    CGFloat imgHeight = imgWidth * 2 / 3;
    return CGSizeMake(width, 5 + imgHeight + 85);
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
    
    
}

@end