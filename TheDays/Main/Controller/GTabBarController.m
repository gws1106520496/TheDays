//
//  GTabBarController.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "GTabBarController.h"
#import "UIImage+GImage.h"
#import "ListViewController.h"
#import "MyViewController.h"
#import "GTabBar.h"
#import "GNavgationController.h"
#import "AddNewViewController.h"
@interface GTabBarController ()<UITabBarControllerDelegate,GTabBarDelegate>
{
    GTabBar *GtabBar;
    UIViewController *listVC;
    UIViewController *myVC;
    int currentTabIndex;
    UIView *chooseView;
    int Tag;
}
@property (nonatomic, strong) NSArray *labelArray;
@end

@implementation GTabBarController

-(NSArray *)labelArray
{
    if(_labelArray == nil)
    {
        _labelArray=@[@"纪念",@"生日",@"节日",@"生活",@"娱乐",@"工作",@"学校",@"其他"];
    }
    return _labelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置代理
    self.delegate = self;
    
    currentTabIndex = 0;
    Tag = 0;
    //更改GTabBarController(self).tabBar 变成自定义的tabBar
    GtabBar = [[GTabBar alloc]init];
    GtabBar.gDelegate = self;
    //KVC赋值， 修改只读属性
    [self setValue:GtabBar forKey:@"tabBar"];
    
    [self setUpchildViewController];
    
    
    chooseView = [[UIView alloc]initWithFrame:CGRectMake((winWidth-220*winWidth/320)/2, winHeight-49-130*winHeight/568, 220*winWidth/320, 130*winHeight/568)];
    [self.view addSubview:chooseView];

    [chooseView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
//    chooseView.alpha = 0.5;
    [self setUpChooseUI];
    chooseView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    chooseView.hidden = YES;
    GtabBar.addButton.selected = NO;
    
}
- (void)didSelectedAddButton:(GTabBar *)tabBar
{
    chooseView.hidden = !chooseView.hidden;
    tabBar.addButton.selected = !chooseView.hidden;
}

- (void)setUpChooseUI
{
    UILabel *catageryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, chooseView.frame.size.width, 10*winHeight/568)];
    catageryLabel.tag = 101;
    catageryLabel.text = @"请选择分类";
    catageryLabel.textAlignment = NSTextAlignmentCenter;
    [chooseView addSubview:catageryLabel];
    float margin = 10;
    float btnW = 40*winWidth/320;
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 4; j ++) {
            UIButton *catageryBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*margin + j*(margin+btnW), 2*margin + i*(2*margin+btnW)+10, btnW, btnW)];
            [catageryBtn addTarget:self action:@selector(addNewRecord:) forControlEvents:UIControlEventTouchUpInside];
            [catageryBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnbg%d",Tag]] forState:UIControlStateNormal];
            catageryBtn.layer.cornerRadius = catageryBtn.frame.size.width/2.0;
            catageryBtn.layer.masksToBounds = YES;
            catageryBtn.tag = Tag;
            Tag ++ ;
            [chooseView addSubview:catageryBtn];
        }
        
    }
    
    for (UIView *btn in [chooseView subviews]) {
        if (btn.tag>=0 && btn.tag < 8) {
            [(UIButton *)btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [(UIButton *)btn setTitle:self.labelArray[btn.tag] forState:UIControlStateNormal];
        }
    }
}

- (void)addNewRecord:(UIButton *)button
{
    AddNewViewController *newVC = [[AddNewViewController alloc]init];
    NSNumber *imageNum = [NSNumber numberWithInteger:button.tag];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[button.titleLabel.text,self.labelArray,imageNum] forKeys:@[@"eventLabel",@"labelArray",@"imageNum"]];

    [self presentViewController:newVC animated:YES completion:^{
        newVC.dic = dic;
    }];

}

- (void)setUpchildViewController{
    listVC = [[ListViewController alloc]init];
    
    [self initChildViewController:listVC title:nil unSelectedImageName:@"shouyeUn" selectedImageName:@"shouye"];
    
    myVC = [[UIViewController alloc]init];
    [self initChildViewController:myVC title:@"设置" unSelectedImageName:@"wodeUn" selectedImageName:@"wode"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"%@",path);
    
}

- (void)initChildViewController:(UIViewController *)viewController title:(NSString *)title unSelectedImageName:(NSString *)unSelectedImage selectedImageName:(NSString *)selectImag{
    static int currentIndex = 0;
    //设置image的偏移量
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    viewController.tabBarItem.tag = currentIndex;
    
    currentIndex ++;
    
    viewController.tabBarItem.selectedImage = [UIImage imageWithRenderingOriginal:selectImag];
    viewController.tabBarItem.image = [UIImage imageNamed:unSelectedImage];
    
    GNavgationController *navController = [[GNavgationController alloc]initWithRootViewController:viewController];
    
    [self addChildViewController:navController];
    
}


@end
