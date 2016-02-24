//
//  LoginViewController.m
//  TheDays
//
//  Created by student on 16/1/28.
//  Copyright © 2016年 student. All rights reserved.
//

#import "LoginViewController.h"
#import "GTabBarController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()<GLoginDelegate>
{
    RegisterViewController *registerVC;
    NSUserDefaults *defaults;
    BOOL loginSuccess;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UISwitch *pwSwitch;
@property (weak, nonatomic) IBOutlet UIButton *accountLogin;
- (IBAction)pwSwitch:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)accountLoginAction:(id)sender;
- (IBAction)touristLoginAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountLogin.layer.cornerRadius = self.accountLogin.frame.size.height/3.0;
    self.accountLogin.layer.masksToBounds = YES;
    registerVC = [[RegisterViewController alloc]init];
    registerVC.gLoginDelegate = self;
    defaults = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pwSwitch:(id)sender {
    self.pwTextField.secureTextEntry = !self.pwSwitch.isOn;
}

- (IBAction)registerAction:(id)sender {
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (IBAction)accountLoginAction:(id)sender {
    [self.view endEditing:YES];
    //判断手机号是否已被注册
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccountInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"phoneNum"] isEqualToString:self.phoneTF.text] && [[obj objectForKey:@"password"] isEqualToString:self.pwTextField.text]) {
                //登录成功，跳转
                loginSuccess = YES;
                [defaults setObject:@"1" forKey:@"ID"];
                [defaults setObject:self.phoneTF.text forKey:@"phoneNum"];
                [defaults synchronize];
                [self jumpToTabBar];
            }
        }
        if (!loginSuccess) {
            [self.view makeToast:@"账号不存在或密码错误" duration:2 position:showPosition];
        }
    }];

}

- (IBAction)touristLoginAction:(id)sender {
    [defaults setObject:@"0" forKey:@"ID"];
    [defaults setObject:@"tourist" forKey:@"phoneNum"];
    [defaults synchronize];
    [self jumpToTabBar];
}
- (void)jumpToTabBar
{
    GTabBarController *tabBar = [[GTabBarController alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appDelegate = app.delegate;
    appDelegate.window.rootViewController = tabBar;
}
#pragma mark GLoginDelegate
- (void)didRegister:(NSDictionary *)infoDic
{
    self.phoneTF.text = infoDic[@"phoneNum"];
    self.pwTextField.text = infoDic[@"password"];
    [self accountLoginAction:nil];
}
@end
