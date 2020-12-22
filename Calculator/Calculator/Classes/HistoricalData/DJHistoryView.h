//
//  DJHistoryView.h
//  Calculator
//
//  Created by 程青松 on 2020/12/17.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCalculDataManager.h"


@interface DJHistoryView : UIView


- (void)showOrHidden;


@end



@interface DJHistoryCell : UITableViewCell

@property(nonatomic, strong) NSDictionary *dataDic;

@end
