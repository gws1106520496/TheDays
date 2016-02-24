//
//  RegisterViewController.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <BmobSDK/Bmob.h>

@interface RegisterViewController ()
{
    BOOL everRegister;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *checkTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;

- (IBAction)registerAction:(id)sender;
- (IBAction)getCheckAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.phoneNumTF becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
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

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    if ([self checkPassword:self.pwTF.text]) {
        [SMSSDK commitVerificationCode:self.checkTF.text phoneNumber:self.phoneNumTF.text zone:@"86" result:^(NSError *error) {
            if (error) {
                //验证成功  此处应是 !error /////////////////////////////////////
                BmobObject *accountInfo = [BmobObject objectWithClassName:@"AccountInfo"];
                [accountInfo setObject:self.phoneNumTF.text forKey:@"phoneNum"];
                [accountInfo setObject:self.pwTF.text forKey:@"password"];
                [accountInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error2) {
                    if (isSuccessful) {
                        //注册成功
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumTF.text,@"phoneNum",self.pwTF.text,@"password", nil];
//                        [self.view makeToast:@"注册成功" duration:1.5 position:showPosition];
                        if ([self.gLoginDelegate respondsToSelector:@selector(didRegister:)]) {
                            [self.gLoginDelegate didRegister:dic];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                    }else{
                        [self.view makeToast:[NSString stringWithFormat:@"%@",error2] duration:1.5 position:@"CSToastPositionCenter"];
                    }

                }];
            }else{
                //验证失败
                [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:1.5 position:@"CSToastPositionCenter"];
            }
        }];
    }else{
        [self.view makeToast:@"密码格式错误" duration:1.5 position:@"CSToastPositionCenter"];
    }
}

- (IBAction)getCheckAction:(id)sender {
    [self.view endEditing:YES];
    if ([self checkTelNumber:self.phoneNumTF.text]) {
        //手机号合法
        //判断手机号是否已被注册
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccountInfo"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                if ([[obj objectForKey:@"phoneNum"] isEqualToString:self.phoneNumTF.text]) {
                    everRegister = YES;
                    [self.view makeToast:@"该手机号已被注册" duration:1.5 position:showPosition];
                    self.phoneNumTF.text = @"";
                }
            }
        }];
        if (!everRegister) {
            //手机号未被注册
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (!error) {
                    //成功
                    [self.view makeToast:@"获取验证码成功" duration:1.5 position:@"CSToastPositionCenter"];
                }else{
                    //失败
                    [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:1.5 position:@"CSToastPositionCenter"];
                }
            }];
        }

    }else{
        [self.view makeToast:@"手机号不合法" duration:1.5 position:@"CSToastPositionCenter"];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//匹配手机号
-(BOOL)checkTelNumber:(NSString *)telNumber
{
    NSString *pattern=@"^0{0,1}(13[0-9]|15[3-9]|15[0-2]|18[0-9]|17[5-8]|145|147|170)[0-9]{8}$";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch=[pred evaluateWithObject:telNumber];
    return isMatch;
}
//匹配用户密码6-18位数字和字母组合
-(BOOL)checkPassword:(NSString *)password
{
    //    NSString *pattern=@"/^({9,16})|((?! )(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[a-zA-Z0-9_]{6,16})$/";
    NSString *pattern=@"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch=[pred evaluateWithObject:password];
    return isMatch;
}
@end
