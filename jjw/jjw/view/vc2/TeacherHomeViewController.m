//
//  TeacherHomeViewController.m
//  jjw
//
//  Created by ylc on 2017/4/16.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "TeacherHomeTableViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+Category.h"
#import "ClassDetailViewController.h"

@interface TeacherHomeViewController (){
    NSDictionary *teacherInfo;
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation TeacherHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"讲师主页";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    dataSource = [NSMutableArray array];
    
    _myTableView.tableFooterView = [[UIView alloc] init];
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    [_myTableView.mj_header beginRefreshing];
    
    
    
}

-(void)loadData{
    page = 1;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/teacher_info"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_teacherId forKey:@"id"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    
    DLog(@"%@",param);
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [_myTableView.mj_header endRefreshing];
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            teacherInfo = [[result objectForKey:@"data_info"] cleanNull];
            
            [_myTableView.mj_footer resetNoMoreData];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            
            [self setHeaderView];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page == [pageTotal intValue]) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            //            DLog(@"%@",responseObject);
        }else{
            [_myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
    
}

-(void)loadMore{
    page ++;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObject:@"text/html"];
    [manager.responseSerializer setAcceptableContentTypes:set];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/teacher/teacher_info"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_teacherId forKey:@"id"];
    [param setObject:[NSNumber numberWithInt:page] forKey:@"page"];//当前第几页
    
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic= [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSArray *array = [result objectForKey:@"data_list"];
            
            [dataSource addObjectsFromArray:array];
            [_myTableView reloadData];
            
            NSNumber *pageTotal = [result objectForKey:@"page_total"];
            if (page >= [pageTotal intValue]) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_myTableView.mj_footer endRefreshing];
            }
            
            
            //            DLog(@"%@",responseObject);
        }else{
            [_myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView.mj_footer endRefreshing];
        [self showHintInView:self.view hint:error.description];
        DLog(@"%@",error.description);
    }];
    
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
    
    
    NSString *PIC_PATH = [teacherInfo objectForKey:@"PIC_PATH"];
    CGFloat imageWidth = (Main_Screen_Width - 20) * 0.4;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 10, imageWidth, imageWidth)];
    [headImageView setImageWithURL:[NSURL URLWithString:PIC_PATH]];
    ViewRadius(headImageView, imageWidth/2);
    [tableHeaderView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMinY(headImageView.frame), 0, 0)];
    nameLabel.font = SYSTEMFONT(16);
    nameLabel.text = [teacherInfo objectForKey:@"NAME"];
    [nameLabel sizeToFit];
    [tableHeaderView addSubview:nameLabel];
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 5, CGRectGetMinY(nameLabel.frame), 0, 0)];
    classLabel.font = SYSTEMFONT(14);
    classLabel.textColor = [UIColor whiteColor];
    classLabel.text = [NSString stringWithFormat:@"  %@%@",[teacherInfo objectForKey:@"f_type"],[teacherInfo objectForKey:@"subject_name"]];
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
    label2.text = [NSString stringWithFormat:@"%d节微课%d人学习",[[teacherInfo objectForKey:@"course_num"] intValue],[[teacherInfo objectForKey:@"student_num"] intValue]];
    [label2 sizeToFit];
    [tableHeaderView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(label2.frame) + 5, 0, 0)];
    label3.font = SYSTEMFONT(12);
    label3.textColor = RGB(153, 153, 153);
    label3.text = [NSString stringWithFormat:@"总播放数：%d",[[teacherInfo objectForKey:@"play_num"] intValue]];
    [label3 sizeToFit];
    [tableHeaderView addSubview:label3];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headImageView.frame) + 10, Main_Screen_Width - 20, 0)];
    desLabel.textColor = RGB(51, 51, 51);
    desLabel.text = [teacherInfo objectForKey:@"CAREER"];
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
    
    [_myTableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *COURSE_ID = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"COURSE_ID"];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = COURSE_ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"teacherTableViewCell";
    TeacherHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= (TeacherHomeTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TeacherHomeTableViewCell" owner:self options:nil]  lastObject];
        ViewRadius(cell.leftImageView, 5);
    }
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *LOGO = [info objectForKey:@"LOGO"];
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:LOGO]];
    cell.label1.text = [info objectForKey:@"TITLE"];
    cell.label2.text = [info objectForKey:@"COURSE_NAME"];
    return cell;
}

@end
