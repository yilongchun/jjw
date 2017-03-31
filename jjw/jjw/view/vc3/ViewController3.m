//
//  ViewController3.m
//  jjw
//
//  Created by Stephen Chin on 2017/3/30.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "ViewController3.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
    self.view.backgroundColor = RGB(245, 245, 245);
    [self initUI];
}

-(void)initUI{
    
    CGFloat barContentHeight = self.navigationController.navigationBar.frame.size.height - 20;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 60, barContentHeight + 4)];
    [btn1 setTitle:@"课程" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMFONT(13);
    [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(btn1, 5, 0, [UIColor whiteColor]);
    [self.navigationController.navigationBar addSubview:btn1];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, 10, Main_Screen_Width - CGRectGetMaxX(btn1.frame) - 20, barContentHeight)];
    [self.navigationController.navigationBar addSubview:searchBar];

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 42)];
    topLabel.backgroundColor = [UIColor whiteColor];
    topLabel.font = SYSTEMFONT(17);
    topLabel.textColor = [UIColor blackColor];
    topLabel.text = @"  我要点播";
    ViewBorderRadius(topLabel, 0, 1, RGB(223, 223, 223));
    [_myScrollView addSubview:topLabel];
    
    CGFloat maxY;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topLabel.frame) + 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(contentView.frame) - 20, 0)];
    l.numberOfLines = 0;
    l.font = SYSTEMFONT(15);
    l.text = @"如果你在本网站没有找到学习相关知识的微课，请在点播内容输入你想学习的内容描述，并留下联系方式，我们会根据你点播内容尽快录制好微课并联系你观看";
    [contentView addSubview:l];
    [l sizeToFit];
    
    maxY = CGRectGetMaxY(l.frame);
    CGRect frame = contentView.frame;
    frame.size.height = maxY + 10;
    contentView.frame = frame;

    
    
    
    [_myScrollView addSubview:contentView];
    
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

@end
