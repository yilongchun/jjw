//
//  MyHeaderImageViewController.m
//  jjw
//
//  Created by ylc on 2017/4/24.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "MyHeaderImageViewController.h"
#import "JZNavigationExtension.h"
#import "UIImage+Color.h"

@interface MyHeaderImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImageView *headImageView;
}

@end

@implementation MyHeaderImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.title = @"个人头像";
    
    [self initUI];
}

-(void)initUI{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 64 + 10, Main_Screen_Width - 20, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 0, 1, RGB(223, 223, 223));
    [self.view addSubview:contentView];
    
    //上传头像
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 0, 0)];
    accountLabel.text = @"上传头像:";
    accountLabel.font = SYSTEMFONT(15);
    [accountLabel sizeToFit];
    [contentView addSubview:accountLabel];
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [uploadBtn setFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 20, CGRectGetMinY(accountLabel.frame) - 8, CGRectGetWidth(contentView.frame) - CGRectGetMaxX(accountLabel.frame) - 50, CGRectGetHeight(accountLabel.frame) + 18)];
    ViewBorderRadius(uploadBtn, 5, 1, BORDER_COLOR);
    uploadBtn.titleLabel.font = SYSTEMFONT(15);
    [uploadBtn setTitle:@"选择文件" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:uploadBtn];
    
    CGFloat width = CGRectGetWidth(contentView.frame)/3;
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentView.frame) - width)/2, CGRectGetMaxY(uploadBtn.frame) + 20, width, width)];
    headImageView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:headImageView];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(headImageView.frame) + 20, CGRectGetWidth(contentView.frame) - 60, 35)];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [submitBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 149, 229) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    ViewBorderRadius(submitBtn, 5, 0, [UIColor whiteColor]);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    
    CGRect frame = contentView.frame;
    frame.size.height = CGRectGetMaxY(submitBtn.frame) + 20;
    [contentView setFrame:frame];
}

-(void)chooseImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"用户相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.allowsEditing = NO;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker2.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
        [[imagePicker2 navigationBar] setTintColor:RGB(67,216,230)];
        [[imagePicker2 navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
        [self presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检查相机模式是否可用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"sorry, no camera or camera is unavailable.");
            return;
        }
        UIImagePickerController  *imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.allowsEditing = NO;
        imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
        [self presentViewController:imagePicker1 animated:YES completion:nil];
    }];
    [alert addAction:action2];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)submit{
    
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

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData* data = UIImageJPEGRepresentation(image,1.0f);
        DLog(@"%lu",(unsigned long)data.length);
        [headImageView setImage:image];
//        if (type == 1) {
//            avatar = [UIImage imageWithData:data];
//        }
        //        if (type == 2) {
        //            backgroundImage = [UIImage imageWithData:data];
        //        }
        
//        [self getToken:data];
        //        [self uploadImage];
        
        
        //        [self.chooseBtn setImage:choosedImage forState:UIControlStateNormal];
        
        //        NSData* data = UIImageJPEGRepresentation(img,0.7f);
        //        DLog(@"type:%d",type);
        //[self uploadImage:data];
        
        
        
        
        
        //        NSData *fildData = UIImageJPEGRepresentation(img, 0.5);//UIImagePNGRepresentation(img); //
        //照片
        //        [self uploadImg:fildData];
        //        self.fileData = UIImageJPEGRepresentation(img, 1.0);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        
        navigationController.navigationBar.tintColor = [UIColor whiteColor];//左右侧按钮颜色
        [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//标题颜色
        navigationController.navigationBar.barTintColor = RGB(69, 179, 230);//背景颜色
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    //    if([viewController isKindOfClass:[SettingViewController class]]){
    //        NSLog(@"返回");
    //        return;
    //    }
}


@end
