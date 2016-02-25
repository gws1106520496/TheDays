//
//  EventScrollerViewController.m
//  TheDays
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 student. All rights reserved.
//

#import "EventScrollerViewController.h"
#import "Events.h"
#import "AddNewViewController.h"
@interface EventScrollerViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *eventScrollerView;

@property (nonatomic, strong) NSArray *eventArray;
@property (nonatomic, assign) int currentIndex;
@end

@implementation EventScrollerViewController

//- (instancetype)init{
//    if (self= [super init]){
//            //接收到通知
//       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUI:) name:@"eventSVC" object:nil];
//    }
//    return self;
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUI:) name:@"eventSVC" object:nil];
    [self setUpUI:self.dic];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
//    [self.eventScrollerView reloadInputViews];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)setUpUI:(NSNotification *)n
- (void)setUpUI:(NSDictionary *)dic
{
    self.eventArray = dic[@"eventArray"];
    self.currentIndex = [dic[@"position"] intValue];
    for (int i = 0; i < self.eventArray.count;  i++) {
        Events *event = self.eventArray[i];
        
        UIView *eventView = [[UIView alloc]initWithFrame:CGRectMake(0 + i*winWidth, 0, winWidth, winHeight)];
        
        UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((winWidth-40*winWidth/320)/2, winHeight*100/568, 40*winWidth/320, 30*winHeight/568)];
        distanceLabel.text = @"距离";
        [eventView addSubview:distanceLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((winWidth-200*winWidth/320)/2, winHeight*150/568, 200*winWidth/320, 30*winHeight/568)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = event.title;
        [eventView addSubview:titleLabel];
        
//        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake((winWidth-200*winWidth/320)/2, winHeight*200/568, 200*winWidth/320, 80*winHeight/568)];
//        dayLabel.textAlignment = NSTextAlignmentCenter;
//        dayLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:38.0];
//        dayLabel.text = event.date;
//        [eventView addSubview:dayLabel];
        
        //使用UIButton
        UIButton *dayButton = [[UIButton alloc]initWithFrame:CGRectMake((winWidth-200*winWidth/320)/2, winHeight*200/568, 200*winWidth/320, 120*winHeight/568)];
        dayButton.titleLabel.font= [UIFont fontWithName:@"MarkerFelt-Wide" size:45.0];
        dayButton.titleLabel.text = @"sdfsdfsd";
        [dayButton setTitle:event.date forState:UIControlStateNormal];
        dayButton.titleLabel.textColor = [UIColor blueColor];
        [eventView addSubview:dayButton];
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((winWidth-200*winWidth/320)/2, winHeight*350/568, 200*winWidth/320, 30*winHeight/568)];
        dateLabel.text = event.createDate;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [eventView addSubview:dateLabel];
        [self.eventScrollerView addSubview:eventView];
    }
    //设置能滚多远 显示的大小
    [self.eventScrollerView setContentSize:CGSizeMake(self.eventArray.count*winWidth, 0)];
    //设置分页滚动
    self.eventScrollerView.pagingEnabled = YES;
    self.eventScrollerView.delegate = self;
    self.eventScrollerView.bounces = NO;
    self.eventScrollerView.showsVerticalScrollIndicator = NO;
    self.eventScrollerView.showsHorizontalScrollIndicator = NO;
    self.eventScrollerView.contentOffset = CGPointMake(self.currentIndex*winWidth, 0);
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"scrBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(winWidth-40, 20, 40, 40)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"scrEdit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
}

#pragma  mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editAction
{
    AddNewViewController *addNewVC = [[AddNewViewController alloc]init];
    addNewVC.eventEdit = self.eventArray[self.currentIndex];
    addNewVC.modify = YES;
    [self.navigationController pushViewController:addNewVC animated:YES];
}
@end
