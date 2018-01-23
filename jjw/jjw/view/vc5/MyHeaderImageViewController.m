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
#import "NSObject+Blocks.h"
#import "UIImageView+AFNetworking.h"

@interface MyHeaderImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImageView *headImageView;
    UIImage *headImage;
}

@end

@implementation MyHeaderImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jz_navigationBarBackgroundAlpha = 1;
    self.jz_navigationBarTintColor = RGB(69, 179, 230);
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
    
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    
    
    NSString *pic = [userInfo objectForKey:@"PIC_IMG"];
    [headImageView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_avatar.jpeg"]];
}

-(void)chooseImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"用户相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.allowsEditing = YES;
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
        imagePicker1.allowsEditing = YES;
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
    
    if (!headImage) {
        [self showHintInView:self.view hint:@"请选择照片"];
        return;
    }
    [self showHudInView:self.view];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"上传中";
    });
    
    AFHTTPRequestOperationManager* _manager = [AFHTTPRequestOperationManager manager];
    
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST,@"/user/update_avatar"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [ud objectForKey:LOGINED_USER];
    [parameters setObject:[userInfo objectForKey:@"USER_ID"] forKey:@"uid"];
    
    NSMutableURLRequest* request = [_manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data1 = UIImageJPEGRepresentation(headImage,0.5f);
        [formData appendPartWithFileData:data1 name:@"avatar_file" fileName:@"1.png" mimeType:@"image/png"];
        
        
    } error:nil];
    
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        
        DLog(@"%@",dic);
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = [dic objectForKey:@"msg"];

            });
            [hud hideAnimated:YES afterDelay:1.5];
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadUserInfo2" object:nil userInfo:nil]];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
        }else{
            [self hideHud];
            [self showHintInView:self.view hint:[dic objectForKey:@"msg"]];
        }
        
        
        
//        NSNumber *code = [dic objectForKey:@"code"];
//        
//        if ([code intValue] == 0) {
//            [self clearInput];
//            
//            //删除文件
//            NSString *aPath1=[NSString stringWithFormat:@"%@/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],[param objectForKey:@"pic1"]];
//            NSString *aPath2=[NSString stringWithFormat:@"%@/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],[param objectForKey:@"pic2"]];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            BOOL deleteFlag1 = [fileManager removeItemAtPath:aPath1 error:nil];
//            BOOL deleteFlag2 = [fileManager removeItemAtPath:aPath2 error:nil];
//            if (deleteFlag1) {
//                DLog(@"%@ 文件删除成功",aPath1);
//            }else{
//                DLog(@"%@ 文件删除失败",aPath1);
//            }
//            if (deleteFlag2) {
//                DLog(@"%@ 文件删除成功",aPath2);
//            }else{
//                DLog(@"%@ 文件删除失败",aPath2);
//            }
//            
//            //删除数据库
//            if ([param objectForKey:@"id"]) {
//                BOOL deleteDbFlag = [DBUtil deleteData:param];
//                if (deleteDbFlag) {
//                    DLog(@"数据库 删除成功");
//                }else{
//                    DLog(@"数据库 删除失败");
//                }
//            }
//            
//            [self setCount];
//            
//            NSNumber *num1 = [NSNumber numberWithInt:index];
//            NSNumber *num2 = [NSNumber numberWithLong:array.count];
//            DLog(@"index:%d count:%d",[num1 intValue],[num2 intValue]);
//            if ([num1 intValue] < [num2 intValue]-1) {
//                [self submitToServer:array index:index+1];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//                    hud.customView = imageView;
//                    hud.mode = MBProgressHUDModeCustomView;
//                    hud.label.text = [NSString stringWithFormat:@"提交完成"];
//                    
//                });
//                [hud hideAnimated:YES afterDelay:1.5];
//            }
//        }else{
//            [self hideHud];
//            [self showHintInView:self.view hint:@"提交失败"];
//        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
    }];
    //进度条要做修改
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //        DLog(@"%f",(float)totalBytesWritten/totalBytesExpectedToWrite);
        float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }];
    
    [operation start];
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
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        headImage = image;
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
