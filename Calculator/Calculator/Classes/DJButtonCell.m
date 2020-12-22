//
//  DJButtonCell.m
//  Calculator
//
//  Created by 程青松 on 2020/12/15.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "DJButtonCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface DJButtonCell ()
{
    UILabel *_label;
}
@end

@implementation DJButtonCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    
    
    _label = UILabel.new;
    _label.backgroundColor = UIColor.translucentColor;
    _label.font = [UIFont systemFontOfSize:30];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = UIColor.textColor;
    _label.layer.cornerRadius = 5;
    [self.contentView addSubview:_label];
    _label.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
}


#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
    self.layer.cornerRadius = self.itemHeight / 3;
    self.layer.masksToBounds = YES;
}




@end
