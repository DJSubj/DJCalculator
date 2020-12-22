//
//  ViewController.m
//  Calculator
//
//  Created by 程青松 on 2019/11/7.
//  Copyright © 2019 limingbo. All rights reserved.
//

#import "ViewController.h"
#import "DJCalculator.h"
#import "DJCalculatorVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSLog(@"%f--%f", kScreenWidth, kScreenHeight);
    
//    [DJCalculator calculator:@""];
    
//    [self calculationAction];
    
//    [self createViews];
    
    UITextView *textview = [UITextView new];
    textview.frame = CGRectMake(80, 200, 300, 50);
    textview.backgroundColor = UIColor.whiteColor;
    textview.inputView = UIView.new;
    textview.inputView.hidden = YES;
    [self.view addSubview:textview];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DJCalculatorVC *normalVC = [[DJCalculatorVC alloc] init];
    [self.navigationController pushViewController:normalVC animated:YES];
}


/*
 
 (  )   7   8   9   +   off
 ^  ^   4   5   6   -   %
 /  /   1   2   3   *   del
 AC +-  0   00  .   /   =

 
 */

/*
 
 1 计算历史
    > 表达式
    > 结果
    > 删除计算历史
 
 2 计算器设置
    > 背景图片
    > 背景色
    > 文字颜色
    > 文字字号
 
 3 逻辑
    > 下次计算需要清空？
    > 本次结果怎样使用
 
 
 */

- (void)createViews {
    
    NSArray *arr = @[@"ON", @"7", @"8", @"9",
                     @"AC", @"4", @"5", @"6",
                     @"+/-", @"1", @"2", @"3",
                     @"C", @"0", @"00", @"."];
    
    for (int i = 0; i < arr.count; i++) {
        
        UILabel *lab = [[UILabel alloc] init];
        int x = i % 4;
        int y = i / 4;
        lab.frame = CGRectMake(105*x+25, 105*y+328, 100, 100);
        lab.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        lab.text = arr[i];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:32];
        lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lab];
        
    }
    
}





@end
