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

@property (nonatomic, strong) NSMutableArray *eventArray;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    event = [[Events alloc]init];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
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
//    static NSString *identifier = @"cell";
//    Events *cellEvent = self.eventArray[indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        
//    }
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"btnbg%@",cellEvent.imageNum]];
//    cell.textLabel.text = cellEvent.title;
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 天",cellEvent.date];
//    return cell;
    Events *cellEvent = self.eventArray[indexPath.row];
    GTableViewCell *cell = [GTableViewCell createCell:tableView WithEvent:cellEvent];
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
    self.eventCreateDate.text = coverDic[@"createDate"];
}

- (void)setCoverWithEvent:(Events *)coverEvent
{
    self.eventTitle.text = coverEvent.title;
    self.eventDayStr.text = [NSString stringWithFormat:@"%@ 天",coverEvent.date];
    self.eventCreateDate.text = coverEvent.createDate;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
