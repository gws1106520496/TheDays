//
//  GTabBar.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "GTabBar.h"

@implementation GTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIButton *)addButton{
    if (_addButton == nil) {
        //添加按钮
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_gerenzhongxin"] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"selectedBtn"] forState:UIControlStateSelected];
        [_addButton addTarget:self action:@selector(addButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_addButton];
    }
    return _addButton;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]];
    }
    return self;
}
//重新调整子视图的位置
-(void)layoutSubviews{
    float itemWidth = self.bounds.size.width/((self.items.count)+1);
    int index = 0;
    //  self.tabBar.items 只是item的模型 （只有属性）
    for (UIView *itemView in self.subviews) {
        if ([itemView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == 1) {
                index = 2;
            }
            itemView.frame = CGRectMake(index*itemWidth, 0, itemWidth, self.frame.size.height);
            index ++;
        }
    }
    [self.addButton setCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5)];
}

- (void)addButtonSelected{
    if ([self.gDelegate respondsToSelector:@selector(didSelectedAddButton:)]) {
        [self.gDelegate didSelectedAddButton:self];
    }
}
@end
