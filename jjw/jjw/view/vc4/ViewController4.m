//
//  ViewController4.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController4.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"
#import "TeacherViewController.h"

@interface ViewController4 ()<UISearchBarDelegate>{
    UISearchBar *_searchBar;
    UIButton *nbtn1;
    UIButton *nbtn2;
    UIView *popView;
    UIView *maskView;
    
    int action2Tag;
}

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    ViewBorderRadius(_topView, 0, 1, RGB(223, 223, 223));
    ViewBorderRadius(_contentView, 0, 1, RGB(223, 223, 223));
    
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 133, 204) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ViewBorderRadius(_submitBtn, 5, 0, [UIColor whiteColor]);
    [_submitBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self initUI];
}

-(void)initUI{
    
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
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [navView addSubview:_searchBar];
    self.navigationItem.titleView = navView;
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

-(void)search{
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"searchValue":_keyWordTextField.text,@"a":@"1"}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    _keyWordTextField.text = @"";
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

@end
