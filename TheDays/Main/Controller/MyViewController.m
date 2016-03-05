//
//  MyViewController.m
//  TheDays
//
//  Created by student on 16/3/1.
//  Copyright © 2016年 student. All rights reserved.
//

#import "MyViewController.h"
#import "Events.h"
#import "AFNetworking.h"
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/Bmob.h>
@interface MyViewController ()
{
    NSUserDefaults *defaults;
}

- (IBAction)toBmob:(id)sender;
- (IBAction)fromBmob:(id)sender;
- (IBAction)contactUS:(id)sender;
- (IBAction)aboutUS:(id)sender;
- (IBAction)loginOUT:(id)sender;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MyViewController
-(NSArray *)dataArray
{
    if (_dataArray == nil) {
        Events *dataEvent = [[Events alloc] init];
        _dataArray = [dataEvent loadDataFromDB];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    defaults = [NSUserDefaults standardUserDefaults];
    
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

- (IBAction)toBmob:(id)sender {
    if ([[defaults objectForKey:@"phone"]isEqualToString:@"tourist"]) {
        [self.view makeToast:@"抱歉,游客登录不能同步" duration:1.5 position:showPosition];
    }else{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"Loading...";
        [hud show:YES];
//        hud.delegate = self;
//        [hud showWhileExecuting:@selector(refreshProgress:) onTarget:self withObject:nil animated:YES];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [path stringByAppendingString:@"/event.db"];
        NSLog(@"%@",filePath);
        [BmobProFile uploadFileWithPath:filePath block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
            if (isSuccessful) {
//                NSLog(@"filename:%@",filename);
//                NSLog(@"url:%@",url);
//                NSLog(@"bmobFile:%@\n",file);
                [self updateAccountInfo:file.url];
            }
        } progress:^(CGFloat progress) {
            //上传进度，此处可编辑进度条。
            hud.progress = progress;
            if (progress == 1.0) {
                [hud hide:YES];
            }
        }];
    }
}

//- (void)refreshProgress:(CGFloat)progress
//{
//    
//}
- (IBAction)fromBmob:(id)sender {
    [self searchAccountInfo];

}

- (IBAction)contactUS:(id)sender {
}

- (IBAction)aboutUS:(id)sender {
}

- (IBAction)loginOUT:(id)sender {
}

- (void)updateAccountInfo:(NSString *)updateStr
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccountInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"phoneNum"] isEqualToString:[defaults objectForKey:@"phoneNum"]]) {
//                NSString *objectID = [obj objectForKey:@"objectId"];
                [obj setObject:updateStr forKey:@"fileURL"];
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"少年你成功了");
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }
        }
    }];
}

- (void)searchAccountInfo
{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccountInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"fileURL"] length] > 0) {
                [self downLoadFile];
            }
        }
    }];
}

- (void)downLoadFile
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccountInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"phoneNum"] isEqualToString:[defaults objectForKey:@"phoneNum"]]) {
//                BmobObject *accountInfo = [BmobObject objectWithClassName:@"AccountInfo"];
                NSString *fileUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"fileURL"]];
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fileUrl]];
                NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    //下载进度
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    //返回指定下载的url路径
                    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    
                    NSString *filePath = [path stringByAppendingString:@"/event.db"];
                    return  [NSURL fileURLWithPath:filePath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    //下载完成后调用
                    if (error) {
                        NSLog(@"%@",error);
                    }else{
                        NSLog(@"%@",filePath);
                        [self.view makeToast:@"同步到本地成功" duration:2 position:showPosition];
                    }
                }];
                [task resume];

            }
        }
    }];
}
@end
