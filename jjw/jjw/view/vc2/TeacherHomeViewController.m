//
//  TeacherHomeViewController.m
//  jjw
//
//  Created by ylc on 2017/4/16.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "TeacherHomeTableViewCell.h"

@interface TeacherHomeViewController ()

@end

@implementation TeacherHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"讲师主页";
    [self setHeaderView];
}

-(void)setHeaderView{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0)];
    _myTableView.tableHeaderView = tableHeaderView;
    _myTableView.tableFooterView = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    label.font = SYSTEMFONT(20);
    label.text = @"讲师个人主页";
    [label sizeToFit];
    [tableHeaderView addSubview:label];
    
    CGFloat imageWidth = (Main_Screen_Width - 20) * 0.4;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 10, imageWidth, imageWidth)];
    headImageView.image = [UIImage imageNamed:@"1481518277839.png"];
    ViewRadius(headImageView, imageWidth/2);
    [tableHeaderView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMinY(headImageView.frame), 0, 0)];
    nameLabel.font = SYSTEMFONT(16);
    nameLabel.text = @"吴清华";
    [nameLabel sizeToFit];
    [tableHeaderView addSubview:nameLabel];
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 5, CGRectGetMinY(nameLabel.frame), 0, 0)];
    classLabel.font = SYSTEMFONT(14);
    classLabel.textColor = [UIColor whiteColor];
    classLabel.text = @"  高中数学";
    classLabel.backgroundColor = RGB(0, 149, 229);
    [classLabel sizeToFit];
    ViewRadius(classLabel, 5);
    CGRect rect = classLabel.frame;
    rect.size.width +=6;
    rect.size.height +=4;
    rect.origin.y -= 2;
    [classLabel setFrame:rect];
    [tableHeaderView addSubview:classLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame) + 5, 0, 0)];
    label2.font = SYSTEMFONT(12);
    label2.textColor = RGB(153, 153, 153);
    label2.text = @"21节微课2人学习";
    [label2 sizeToFit];
    [tableHeaderView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(label2.frame) + 5, 0, 0)];
    label3.font = SYSTEMFONT(12);
    label3.textColor = RGB(153, 153, 153);
    label3.text = @"总播放数：4";
    [label3 sizeToFit];
    [tableHeaderView addSubview:label3];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headImageView.frame) + 10, Main_Screen_Width - 20, 0)];
    desLabel.textColor = RGB(51, 51, 51);
    desLabel.text = @"（数学必修1）湖北省优秀数学教师，宜昌市数学学科带头人，宜昌市数学会理事，宜昌市优秀青年教书育人能手，宜昌市首届明星班主任。屡获国家级、湖北省高中数学优质课竞赛一等奖，多次获得各类国家级高中数学竞赛优秀指导教师。多次获得宜昌市高考质量奖，已培养20余位清华、北大、港大学子，毕业生中有多人考取牛津大学、耶鲁大学、哥伦比亚大学等世界名校";
    desLabel.numberOfLines = 0;
    desLabel.font = SYSTEMFONT(14);
    [desLabel sizeToFit];
    [tableHeaderView addSubview:desLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(desLabel.frame) + 10, Main_Screen_Width - 20, 1)];
    line.backgroundColor = RGB(223, 223, 223);
    [tableHeaderView addSubview:line];
    
    CGRect frame = tableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(line.frame) + 10;
    [tableHeaderView setFrame:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat imgWidth = (Main_Screen_Width - 40)*0.35*2/3;
    return imgWidth + 10;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"teacherTableViewCell";
    TeacherHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (TeacherHomeTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TeacherHomeTableViewCell" owner:self options:nil]  lastObject];
        ViewRadius(cell.leftImageView, 5);
    }
    cell.leftImageView.image = [UIImage imageNamed:@"1475988005412.jpeg"];
    cell.label1.text = @"函数基本性质之3-函数单调性的应用";
    cell.label2.text = @"函数的表示法之1：如何求函数解析式？（代入法、换元法、配凑法）";
    return cell;
}

@end
