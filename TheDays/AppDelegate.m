//
//  AppDelegate.m
//  TheDays
//
//  Created by student on 16/1/28.
//  Copyright © 2016年 student. All rights reserved.
//

#import "AppDelegate.h"
#import "GTabBarController.h"
#import "GGuideVIewController.h"
#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <BmobSDK/Bmob.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [SMSSDK registerApp:@"f8cdd876123a" withSecret:@"71a1aac9c69b11070f551b210e22cbc9"];
    
    [Bmob registerWithAppKey:@"dc588dd2110ad1561ac8a143eea49796"];
    
    // Override point for customization after application launch.
    //创建window (通过Main 会自动创建一个Window  而且让主window能够显示)
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    GTabBarController *tabBarController = [[GTabBarController alloc]init];
    //判断是否是第一次启动，是就进入引导页
    if (GUserDefaults(GFirstLaunch)==nil){
        GGuideVIewController *guideVC = [[GGuideVIewController alloc] init];
        self.window.rootViewController = guideVC;
    }else if ([GUserDefaults(GFirstLaunch) isEqualToString:@"1"]){
        if ([GUserDefaults(GLoginStatus) isEqualToString:@"1"] || [GUserDefaults(GLoginStatus) isEqualToString:@"0"]) {
            //跳过登录，进入主界面
            self.window.rootViewController = tabBarController;
        }else{
            //进入登录界面
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            self.window.rootViewController =loginVC;
            NSLog(@"%@",self);
        }
    
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
