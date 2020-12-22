//
//  DJCalculatorVC.m
//  Calculator
//
//  Created by 程青松 on 2019/11/21.
//  Copyright © 2019 limingbo. All rights reserved.
//

#import "DJCalculatorVC.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DJCalculator.h"
#import "DJButtonCell.h"
#import "DJSettingVC.h"
#import "DJHistoryView.h"
#import "DJAnimationManager.h"


@interface DJCalculatorVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemHeight;
    NSString *_preStr;
}

@property (nonatomic, strong) NSMutableArray<NSArray *> *dataArray;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UILabel *result;
@property (nonatomic, strong) UITextView *expres;
@property (nonatomic, strong) DJHistoryView *history;

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation DJCalculatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.dataArray = NSMutableArray.array;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self orientChange:nil];
    } else {
        [self createCalculateUIForPhone];
    }
    
    NSLog(@"%@", HISTORY_DATA_PATH);
    [self.view sendSubviewToBack:self.bgImgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"bgAnimation"]) {
        [self.view.layer addSublayer:DJAnimationManager.shardManager.animationWithSnow];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 懒加载
- (UICollectionView *)myCollectionView {
    if (_myCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myCollectionView.backgroundColor = UIColor.clearColor;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[DJButtonCell class] forCellWithReuseIdentifier:@"DJButtonCell"];
        [self.view addSubview:_myCollectionView];
        _myCollectionView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
    }
    return _myCollectionView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        NSFileManager *manager = NSFileManager.defaultManager;
        if ([manager fileExistsAtPath:BG_IMG_PATH]) {
            UIImage *img = [UIImage imageWithContentsOfFile:BG_IMG_PATH];
            _bgImgView.image = img;
        } else {
            _bgImgView.image = [UIImage imageNamed:@"bgimg.jpg"];
        }
        [self.view addSubview:self.bgImgView];
        _bgImgView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
    }
    return _bgImgView;
}

- (UILabel *)result {
    if (!_result) {
        _result = [[UILabel alloc] init];
        _result.backgroundColor = UIColor.translucentColor;
        _result.text = @"";
        _result.font = [UIFont systemFontOfSize:60];
        _result.textColor = UIColor.textColor;
        _result.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_result];
    }
    return _result;
}

- (UITextView *)expres {
    if (!_expres) {
        _expres = [[UITextView alloc] init];
        _expres.backgroundColor = UIColor.translucentColor;
        // 去掉textview内边距
        _expres.textContainer.lineFragmentPadding = 0.0;
        _expres.textContainerInset = UIEdgeInsetsZero;
        // textview 阻止键盘弹起
        _expres.inputView = UIView.new;
        _expres.inputView.hidden = YES;
        _expres.text = @"";
        _expres.font = [UIFont systemFontOfSize:48];
        _expres.textColor = UIColor.textColor;
        _expres.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_expres];
    }
    return _expres;
}

- (DJHistoryView *)history {
    if (!_history) {
        _history = DJHistoryView.new;
        _history.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _history;
}



#pragma mark - layout
- (void)layoutViews {
    self.result.sd_resetLayout
    .leftSpaceToView(self.view, 5)
    .rightSpaceToView(self.view, 5)
    .bottomSpaceToView(self.myCollectionView, 5)
    .heightIs(100);
    self.expres.sd_resetLayout
    .leftSpaceToView(self.view, 5)
    .rightSpaceToView(self.view, 5)
    .bottomSpaceToView(self.result, 5)
    .heightIs(60);
}


#pragma mark - --collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DJButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJButtonCell" forIndexPath:indexPath];
    cell.itemHeight = _itemHeight;
    cell.title = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.dataArray[indexPath.section][indexPath.row];
    [self keyboldClickWithString:str];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((int)_itemHeight, (int)_itemHeight);
}

// 四边边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.1, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}


#pragma mark - 自定键盘输入逻辑
- (void)keyboldClickWithString:(NSString *)string {
    
    if ([_preStr isEqualToString:@"="]) {
        NSArray *nums = @[@"0", @"00", @".", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"(", @")"];
        if ([nums containsObject:string]) {
            self.expres.text = @"";
            self.result.text = @"";
        }
        NSArray *oprations = @[@"+", @"-", @"*", @"/", @"%", @"^", @"√", @"+-", @"x^2", @"2√x"];
        if ([oprations containsObject:string]) {
            self.expres.text = self.result.text;
            self.result.text = @"";
        }
    }
    
    if ([string isEqualToString:@"设置"]) {
        DJSettingVC *setting = DJSettingVC.new;
        __weak typeof(self) weakSelf = self;
        setting.selectImageBlock = ^(UIImage *img) {
            weakSelf.bgImgView.image = img;
        };
        setting.bgAnimationBlock = ^(BOOL bgAnimation) {
            if (bgAnimation) {
                [DJAnimationManager.shardManager.animationWithSnow removeFromSuperlayer];
            } else {
                [self.view.layer addSublayer:DJAnimationManager.shardManager.animationWithSnow];
            }
        };
        [self presentViewController:setting animated:YES completion:nil];
    } else if ([string isEqualToString:@"历史"]) {
        [self.view addSubview:self.history];
        [self.history showOrHidden];
    } else if ([string isEqualToString:@"x^2"]) {
        self.expres.text = [NSString stringWithFormat:@"%@%@", self.expres.text, @"^2"];
    } else if ([string isEqualToString:@"2√x"]) {
        self.expres.text = [NSString stringWithFormat:@"%@%@", self.expres.text, @"2√"];
    } else if ([string isEqualToString:@"off"]) {
        [self clickOffAction];
    } else if ([string isEqualToString:@"AC"]) {
        self.expres.text = @"";
        self.result.text = @"";
    } else if ([string isEqualToString:@"Del"]) {
        [self clickDeleteAction];
        self.result.text = @"";
    } else if ([string isEqualToString:@"="]) {
        self.expres.text = [NSString stringWithFormat:@"%@%@", self.expres.text, string];
        self.result.text = [DJCalculator calculator:self.expres.text];
        DJCalculDataManager *manager = DJCalculDataManager.sharedManager;
        [manager addCalculate:self.expres.text result:self.result.text];
    } else {
        self.expres.text = [NSString stringWithFormat:@"%@%@", self.expres.text, string];
    }

    _preStr = string;
}

- (void)clickOffAction {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    maskView.backgroundColor = UIColor.blackColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewClickAction:)];
    [maskView addGestureRecognizer:tap];
    [UIApplication.sharedApplication.keyWindow addSubview:maskView];
}

- (void)clickDeleteAction {
    NSString *text = self.expres.text;
    if (!text.length) return;
    NSRange range = self.expres.selectedRange;
    if (range.location == 0) {
        return;
    } else if (range.location == NSNotFound) {
        range.location = text.length;
    }
    NSString *before = [text substringToIndex:range.location - 1];
    NSString *after = [text substringFromIndex:range.location];
    self.expres.text = [NSString stringWithFormat:@"%@%@", before, after];
    self.expres.selectedRange = NSMakeRange(range.location - 1, 0);
}

- (void)maskViewClickAction:(UIGestureRecognizer *)ges {
    [ges.view removeFromSuperview];
}


#pragma mark - 屏幕旋转
- (void)orientChange:(NSNotification *)noti {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createOrUpdateCalculateUIForPad];
        });
    }
}

static NSInteger count = 6;
- (void)createOrUpdateCalculateUIForPad {
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    if (orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight) {
        // 横向 32
        NSArray *arr = @[@[@"",      @"%",   @"+-",  @"7",   @"8",   @"9",   @"+",   @"off"],
                         @[@"",      @"(",   @")",   @"4",   @"5",   @"6",   @"-",   @"AC"],
                         @[@"设置",   @"^",   @"x^2", @"1",   @"2",   @"3",   @"*",   @"Del"],
                         @[@"历史",   @"√",   @"2√x", @"0",   @"00",  @".",   @"/",   @"="]];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        count = 8;
    } else if (orient == UIDeviceOrientationPortrait || orient == UIDeviceOrientationPortraitUpsideDown) {
        NSArray *arr = @[@[@"+-",  @"(",   @")",   @"%",   @"设置", @"历史"],
                         @[@"^",   @"7",   @"8",   @"9",   @"+",   @"off"],
                         @[@"x^2", @"4",   @"5",   @"6",   @"-",   @"AC"],
                         @[@"√",   @"1",   @"2",   @"3",   @"*",   @"Del"],
                         @[@"2√x", @"0",   @"00",  @".",   @"/",   @"="]];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        count = 6;
    }
    
    
    _itemHeight = (kScreenWidth - 5 * (count + 1)) / count;
    
    CGFloat collectionViewHeight = (_itemHeight + 5) * self.dataArray.count;
    NSLog(@"collectionViewHeight:%f", collectionViewHeight);
    self.myCollectionView.sd_layout.heightIs(collectionViewHeight);
    
    [self.myCollectionView reloadData];
    
    [self layoutViews];
}

- (void)createCalculateUIForPhone {
    NSArray *arr = @[@[@"√",   @"2√x", @"^",   @"x^2", @"设置"],
                     @[@"(",   @")",   @"%",   @"+-",  @"历史"],
                     @[@"7",   @"8",   @"9",   @"+",   @"off"],
                     @[@"4",   @"5",   @"6",   @"-",   @"AC"],
                     @[@"1",   @"2",   @"3",   @"*",   @"Del"],
                     @[@"0",   @"00",  @".",   @"/",   @"="]];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    count = 5;
    
    _itemHeight = (kScreenWidth - 5 * (count + 1)) / count;
    
    CGFloat collectionViewHeight = (_itemHeight + 5) * self.dataArray.count;
    NSLog(@"collectionViewHeight:%f", collectionViewHeight);
    self.myCollectionView.sd_layout.heightIs(collectionViewHeight);
    
    [self.myCollectionView reloadData];
    
    [self layoutViews];
}


@end
