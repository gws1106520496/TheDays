//
//  ListViewController.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "ListViewController.h"
#import "Events.h"
#import "AddNewViewController.h"
#import "EventScrollerViewController.h"
#import "GTableViewCell.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSDate *nowDate;
    BOOL before;
    NSTimer *timer;
    NSUserDefaults *defaults;
    Events *event;
    Events *eventA;
    NSDictionary *eventDic;

}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDayStr;
@property (weak, nonatomic) IBOutlet UILabel *eventCreateDate;

- (IBAction)clickAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *eventArray;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    event = [[Events alloc]init];
    
//    dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    nowDate = [NSDate date];
    
    UIView *footView = [[UIView alloc] init];
    self.listTableView.tableFooterView = footView;
    
    //接收到通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCover:) name:@"setCover" object:nil];
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.eventArray = [event loadDataFromDB];
    defaults = [NSUserDefaults standardUserDefaults];
    eventDic = [defaults objectForKey:@"coverEvent"];
    if (eventDic != nil) {
        [self setCoverWithDic:eventDic];
    }else if (self.eventArray.count > 0){
        eventA = self.eventArray[0];
        [self setCoverWithEvent:eventA];
    }
    [self.listTableView reloadData];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:indexPath.row],self.eventArray] forKeys:@[@"position",@"eventArray"]];
        EventScrollerViewController *eventSVC = [[EventScrollerViewController alloc]init];
    eventSVC.dic = dic;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"eventSVC" object:dic userInfo:nil];
    [self.navigationController pushViewController:eventSVC animated:YES];

}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Events *cellEvent = self.eventArray[indexPath.row];
    GTableViewCell *cell = [GTableViewCell createCell:tableView WithEvent:cellEvent];
//    long dd;
//    NSString *timeString = @"";
//    NSDateFormatter *onceFormatter = [[NSDateFormatter alloc]init];
//    [onceFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////    NSDate *now1 = [NSDate date];
//    NSString *dayStr;
//    
////    NSString *str1 = [cellEvent.createDate substringToIndex:10];
//    NSString *nowDateStr = [[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10] stringByAppendingString:@" 00:01:00"];
//    NSString *addDateStr = [[cellEvent.createDate substringToIndex:10] stringByAppendingString:@" 00:00:00"];
//    
//    NSDate *addDate = [onceFormatter dateFromString:addDateStr];
//    NSDate *now = [onceFormatter dateFromString:nowDateStr];
//
//    if ([now timeIntervalSince1970] > [addDate timeIntervalSince1970]) {
//        dd = (long)[now timeIntervalSince1970] - [addDate timeIntervalSince1970];
//        before = YES;
//    }else{
//        dd = (long)[addDate timeIntervalSince1970] - [now timeIntervalSince1970];
//        before = NO;
//    }
//    
//    if (dd/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%ld",dd/86400];
//        if (before) {
//            dayStr = [NSString stringWithFormat:@"+%@",timeString];
//        }else{
//            dayStr = [NSString stringWithFormat:@"-%@",timeString];
//        }
//        
//    }else{
//        dayStr = @"0";
//    }
    cell.detailLabel.text = [Utils getDistanceDayStr:cellEvent.createDate];

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)setCover:(NSNotification *)n
{
    eventA = (Events *)n.object;
    eventDic = [NSDictionary dictionaryWithObjects:@[eventA.title,eventA.date,eventA.createDate] forKeys:@[@"title",@"date",@"createDate"]];
    [self setCoverWithDic:eventDic];
    [defaults setObject:eventDic forKey:@"coverEvent"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)setCoverWithDic:(NSDictionary *)coverDic
{
    self.eventTitle.text = coverDic[@"title"];
    self.eventDayStr.text = [NSString stringWithFormat:@"%@ 天",coverDic[@"date"]];
    self.eventCreateDate.text = [coverDic[@"createDate"] substringToIndex:10];
}

- (void)setCoverWithEvent:(Events *)coverEvent
{
    self.eventTitle.text = coverEvent.title;
    NSString *s = [Utils getDistanceDayStr:coverEvent.createDate];
    self.eventDayStr.text = [NSString stringWithFormat:@"%@ 天",s];
    self.eventCreateDate.text = [coverEvent.createDate substringToIndex:10];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickAction:(id)sender {
    [self tableView:self.listTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
@end
