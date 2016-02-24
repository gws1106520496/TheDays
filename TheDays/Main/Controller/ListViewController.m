//
//  ListViewController.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "ListViewController.h"
#import "Events.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSDate *nowDate;
    BOOL before;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray *eventArray;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    nowDate = [NSDate date];
    
    UIView *footView = [[UIView alloc] init];
    self.listTableView.tableFooterView = footView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Events *event = [[Events alloc]init];
    self.eventArray = [event loadDataFromDB];
    [self.listTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    Events *event = self.eventArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"btnbg%@",event.imageNum]];
    cell.textLabel.text = event.title;
    
    NSDate *addDate = [dateFormatter dateFromString:event.date];
    long dd;
    NSString *timeString = @"";
    if ([nowDate timeIntervalSince1970] > [addDate timeIntervalSince1970]) {
        dd = (long)[nowDate timeIntervalSince1970] - [addDate timeIntervalSince1970];
        before = YES;
    }else{
        dd = (long)[addDate timeIntervalSince1970] - [nowDate timeIntervalSince1970];
        before = NO;
    }
    
    
    if (dd/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%ld",dd/86400];
        if (before) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@天",timeString];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-%@天",timeString];
        }
           
    }else{
        cell.detailTextLabel.text = @"0天";
    }
    
//    NSLog(@"%ld,%f,%f",dd,[nowDate timeIntervalSince1970],[addDate timeIntervalSince1970]);
//    NSLog(@"%@,,,%@,,,%@",timeString,event.date,[NSString stringWithFormat:@"%@",nowDate]);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
