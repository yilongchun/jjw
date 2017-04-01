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



@interface ViewController1 (){
    UIScrollView *myScrollView;//主界面滚动视图
    
    UIScrollView *bixiuScrollView;//必修滚动界面
}

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.jz_navigationBarBackgroundHidden = YES;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    CGFloat maxY;
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:myScrollView];
    
    //广告图片
    CGFloat imageViewHeight = Main_Screen_Width * 296 / 640;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, imageViewHeight)];
    imageview.image = [UIImage imageNamed:@"1484533496_919.jpg"];
    [myScrollView addSubview:imageview];
    
    //必修
    bixiuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), Main_Screen_Width, 114)];
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
    for (int i = 0; i < 4; i++) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50)];
        cellView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50)];
        cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
        [cellView addSubview:cellImage];
        ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
        cellLabel.font = SYSTEMFONT(13);
        cellLabel.numberOfLines = 2;
        cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
        [cellView addSubview:cellLabel];
        [dongtaiContent addSubview:cellView];
        
        if ((i+1) % 2 == 0) {
            cellX = 0;
            cellY += CGRectGetHeight(cellView.frame) + 5;
        }else{
            cellX += CGRectGetWidth(cellView.frame) + 5;
        }
    }

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(zxdtView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
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
    for (int i = 0; i < 4; i++) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50 + 20)];
        cellView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50 - 20)];
        cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
        [cellView addSubview:cellImage];
        
        ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
        cellLabel.font = SYSTEMFONT(13);
        cellLabel.numberOfLines = 2;
        cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
        [cellView addSubview:cellLabel];
        
        UILabel *clickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellLabel.frame), CGRectGetWidth(cellView.frame) - 10, 20)];
        clickLabel.font = SYSTEMFONT(11);
        clickLabel.textColor = [UIColor lightGrayColor];
        clickLabel.text = @"江艳  点击44次";
        [cellView addSubview:clickLabel];
        
        [content addSubview:cellView];
        if ((i+1) % 2 == 0) {
            cellX = 0;
            cellY += CGRectGetHeight(cellView.frame) + 5;
        }else{
            cellX += CGRectGetWidth(cellView.frame) + 5;
        }
    }
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(jptjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
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
    for (int i = 0; i < 4; i++) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight + 50 + 20)];
        cellView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cellView.frame) - 10, CGRectGetHeight(cellView.frame) - 50 - 20)];
        cellImage.image = [UIImage imageNamed:@"1484533496_919.jpg"];
        [cellView addSubview:cellImage];
        
        ViewBorderRadius(cellImage, 5, 0, BORDER_COLOR);
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame), CGRectGetWidth(cellView.frame) - 10, 46)];
        cellLabel.font = SYSTEMFONT(13);
        cellLabel.numberOfLines = 2;
        cellLabel.text = @"5建议、6妙招，助你笑傲2017高考数学!";
        [cellView addSubview:cellLabel];
        
        UILabel *clickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellLabel.frame), CGRectGetWidth(cellView.frame) - 10, 20)];
        clickLabel.font = SYSTEMFONT(11);
        clickLabel.textColor = [UIColor lightGrayColor];
        clickLabel.text = @"江艳  点击44次";
        [cellView addSubview:clickLabel];
        
        [content addSubview:cellView];
        if ((i+1) % 2 == 0) {
            cellX = 0;
            cellY += CGRectGetHeight(cellView.frame) + 5;
        }else{
            cellX += CGRectGetWidth(cellView.frame) + 5;
        }
    }
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(jptjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
    [mftyView addSubview:moreBtn];
    
    
    [myScrollView addSubview:mftyView];
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mftyView.frame), Main_Screen_Width, 0.5)];
    line.backgroundColor = BORDER_COLOR;
    [myScrollView addSubview:line];
    
    //图片
    UIImage *image = [UIImage imageNamed:@"1484533489_1588.jpg"];
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), Main_Screen_Width, image.size.height/image.size.width*Main_Screen_Width)];
    imageview2.image = image;
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
    for (int i = 0; i < 4; i++) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX + 5, cellY +5, cellWidth, cellHeight)];
        cellView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(cellView, 0, 0.5, BORDER_COLOR);
        
        UILabel *kLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 60, 26)];
        
        kLabel.font = SYSTEMFONT(12);
        kLabel.textColor = [UIColor whiteColor];
        if (i == 1 || i ==2) {
            kLabel.backgroundColor = RGB(39, 68, 179);
            kLabel.text = @"高中物理";
        }
        if (i == 0) {
            kLabel.backgroundColor = RGB(242, 120, 120);
            kLabel.text = @"高中";
        }
        if (i == 3) {
            kLabel.backgroundColor = RGB(164, 114, 41);
            kLabel.text = @"高中生物";
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
        cellImage.image = [UIImage imageNamed:@"1484533489_1588.jpg"];
        [cellView addSubview:cellImage];
        //姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(cellImage.frame) + 5, cellImageWidth, 20)];
        nameLabel.text = @"陈治勇";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:nameLabel];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(nameLabel.frame) + 5, cellImageWidth, 0.5)];
        line.backgroundColor = BORDER_COLOR;
        [cellView addSubview:line];
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(line.frame) + 5, cellImageWidth, CGRectGetHeight(cellView.frame) - CGRectGetMaxY(line.frame) - 5)];
        bottomLabel.text = @"7节微课 | 338人学习";
        bottomLabel.font = SYSTEMFONT(11);
        bottomLabel.textColor = [UIColor lightGrayColor];
        [cellView addSubview:bottomLabel];
        
        [content addSubview:cellView];
        if ((i+1) % 2 == 0) {
            cellX = 0;
            cellY += CGRectGetHeight(cellView.frame) + 5;
        }else{
            cellX += CGRectGetWidth(cellView.frame) + 5;
        }
    }
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setFrame:CGRectMake(5, CGRectGetHeight(mstjView.frame) - 5 - 38, Main_Screen_Width - 10, 38)];
    [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = SYSTEMFONT(15);
    [moreBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(moreBtn, 5, 0.5, BORDER_COLOR);
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
    
    CGFloat x = 0;
    for (int i = 0; i < 10; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + 5, 10, 130, 80)];
        [btn setTitle:@"必修1\n共21节" forState:UIControlStateNormal];
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
        
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 8, CGRectGetWidth(btn.frame), 11)];
        btnLabel.text = @"暂时没有打包";
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.font = SYSTEMFONT(14);
        [bixiuScrollView addSubview:btnLabel];
        
        x = CGRectGetMaxX(btn.frame) + 5;
    }
    [bixiuScrollView setContentSize:CGSizeMake(x, CGRectGetHeight(bixiuScrollView.frame))];
    
}

//必修点击
-(void)bixiuClick:(UIButton *)btn{
    NSNotification *notification =[NSNotification notificationWithName:@"setTab" object:nil userInfo:@{@"a":@"1"}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
