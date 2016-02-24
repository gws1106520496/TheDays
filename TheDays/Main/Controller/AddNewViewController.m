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
@interface AddNewViewController ()<GTFAccessoryViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    NSString *date;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextField *classifyTF;

- (IBAction)addCancelAction:(id)sender;
- (IBAction)addDownAction:(id)sender;


@property (nonatomic, strong)NSArray *labelArray;
@end

@implementation AddNewViewController

- (IBAction)addCancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addDownAction:(id)sender {
    if ([self.titleTF.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入biaoti" duration:2.0 position:showPosition];
    }else{
             //保存到数据库
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phone = [defaults objectForKey:@"phoneNum"];
        Events *event = [Events eventWithuId:0 andPhoneNum:phone andTitle:self.titleTF.text andDate:self.dateTF.text andClassify:self.classifyTF.text andImageNum:self.dic[@"imageNum"]];
        BOOL result = [Events insertEvent:event];
        if (result) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
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
  
    date = [NSString stringWithFormat:@"%@",datePicker.date];
    
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkNil) userInfo:nil repeats:YES];
    //设置时区
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [datePicker setDate:[NSDate date] animated:YES];//设置默认时间为当前时间

    //mode属性
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    GTFAccessoryView *tfView = [[NSBundle mainBundle]loadNibNamed:@"GTFAccessoryView" owner:self options:nil].lastObject;
    tfView.GTFdelegate = self;
    self.dateTF.inputAccessoryView = tfView;
    self.dateTF.inputView = datePicker;
    self.dateTF.text = [date substringToIndex:10];
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
    date = [NSString stringWithFormat:@"%@",datePicker.date];
    self.dateTF.text = [date substringToIndex:10];
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
    if(self.dic){
        self.classifyTF.text = self.dic[@"eventLabel"];
        [timer invalidate];
    }
}
@end
