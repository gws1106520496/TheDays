//
//  AddNewViewController.m
//  TheDays
//
//  Created by student on 16/2/21.
//  Copyright © 2016年 student. All rights reserved.
//

#import "AddNewViewController.h"
#import "GTFAccessoryView.h"
#import "Events.h"
#import "ListViewController.h"
@interface AddNewViewController ()<GTFAccessoryViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    NSString *date;
    NSTimer *timer;
    NSDateFormatter *formatter;
    BOOL before;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextField *classifyTF;
@property (weak, nonatomic) IBOutlet UISwitch *setCover;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)addCancelAction:(id)sender;
- (IBAction)addDownAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@property (nonatomic, copy) NSString *toDate;
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, copy) NSString *modifyDate;
@end

@implementation AddNewViewController

- (IBAction)addCancelAction:(id)sender {
    if (self.modify) {
        [self.navigationController popViewControllerAnimated:YES];
         self.modify = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)addDownAction:(id)sender {
    if (self.modify) {
        //修改数据库中的event
        Events *newEvent = [Events eventWithuId:0 andPhoneNum:self.eventEdit.phoneNum andTitle:self.titleTF.text andDate:[Utils getDistanceDayStr:[NSString stringWithFormat:@"%@",datePicker.date]] andClassify:self.classifyTF.text andImageNum:self.dic[@"imageNum"] andCreateDate:self.eventEdit.createDate andSetCover:self.eventEdit.setCover andFindTag:self.eventEdit.findTag];
        [Events editEvent:newEvent];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([self.titleTF.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入biaoti" duration:2.0 position:showPosition];
        }else{
            //保存到数据库
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *phone = [defaults objectForKey:@"phoneNum"];
            
            int cover;
            if (self.setCover.isOn) {
                cover = 1;
            }else{
                cover = 0;
            }
            NSDateFormatter *onceFormatter = [[NSDateFormatter alloc]init];
            [onceFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            //        [onceFormatter setTimeZone:timeZone];
            NSString *someDayStr = @"2000-01-01 00:00:00";//过去的某个时间点
            NSDate *someDayDate = [onceFormatter dateFromString:someDayStr];
            NSDate *compareDate = [onceFormatter dateFromString:self.toDate];
            NSTimeInterval flagTime = [compareDate timeIntervalSinceDate:someDayDate];
            Events *event = [Events eventWithuId:0 andPhoneNum:phone andTitle:self.titleTF.text andDate:[Utils getDistanceDayStr:[NSString stringWithFormat:@"%@",datePicker.date]] andClassify:self.classifyTF.text andImageNum:self.dic[@"imageNum"] andCreateDate:[NSString stringWithFormat:@"%@",datePicker.date] andSetCover:cover andFindTag:flagTime];
            BOOL insertResult = [Events insertEvent:event];
            if (insertResult) {
                if (self.setCover.isOn) {
                    //通知ListViewController 设为封面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCover" object:event userInfo:nil];
                    
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    
}

- (IBAction)deleteAction:(id)sender {
    [Events deleteEventWIthUId:self.eventEdit.findTag];
}

-(NSArray *)labelArray
{
    if (_labelArray == nil) {
        _labelArray = self.dic[@"labelArray"];
    }
    return _labelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datePicker = [[UIDatePicker alloc]init];
    pickerView = [[UIPickerView alloc]init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    self.classifyTF.text = self.dic[@"eventLabel"];
    self.classifyTF.inputView = pickerView;
  
    date = [NSString stringWithFormat:@"%@",datePicker.date];//日期
    
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkNil) userInfo:nil repeats:YES];
    //设置时区
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [datePicker setDate:[NSDate date] animated:YES];//设置默认时间为当前时间

    //mode属性
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    GTFAccessoryView *tfView = [[NSBundle mainBundle]loadNibNamed:@"GTFAccessoryView" owner:self options:nil].lastObject;
    tfView.GTFdelegate = self;
    self.dateTF.inputAccessoryView = tfView;
    self.dateTF.inputView = datePicker;
    self.dateTF.text = [date substringToIndex:10];
    self.toDate = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:19];
    if (self.modify) {
        self.deleteBtn.hidden = NO;
        self.modifyDate = self.eventEdit.createDate;
    }else{
        self.deleteBtn.hidden = YES;
    }
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSLog(@"%@",path);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GTFDelegate
- (void)tfAccessoryView:(GTFAccessoryView *)tfView didSelectedCancelButton:(UIButton *)button
{
    [self.view endEditing:YES];
}

- (void)tfAccessoryView:(GTFAccessoryView *)tfView didSelectedDownButton:(UIButton *)button
{
    [self.view endEditing:YES];
    self.toDate = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:19];
    date = [NSString stringWithFormat:@"%@",datePicker.date];
    self.dateTF.text = [date substringToIndex:10];
    if (self.modify) {
        self.modifyDate = date;
        self.eventEdit.createDate = [NSString stringWithFormat:@"%@",datePicker.date];
    }
}

#pragma mark  UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.labelArray.count;
}

#pragma mark UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.labelArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.classifyTF.text = self.labelArray[row];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)checkNil
{
    if(self.dic && !self.modify){
        self.classifyTF.text = self.dic[@"eventLabel"];
        [timer invalidate];
    }else if (self.modify){
        self.classifyTF.text = self.eventEdit.classify;
        self.titleTF.text = self.eventEdit.title;
        self.dateTF.text = [self.eventEdit.createDate substringToIndex:10];
        if (self.eventEdit.setCover == 1) {
            [self.setCover setOn:YES animated:YES];
        }else{
            [self.setCover setOn:NO animated:YES];
        }
        [timer invalidate];
    }
}
@end
