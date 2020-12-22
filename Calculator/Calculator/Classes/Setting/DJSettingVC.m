//
//  DJSettingVC.m
//  Calculator
//
//  Created by 程青松 on 2020/12/17.
//  Copyright © 2020 limingbo. All rights reserved.
//

#import "DJSettingVC.h"

@interface DJSettingVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UITableView *myTableView;

@end

@implementation DJSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.myTableView];
    
}


- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _myTableView.backgroundColor = UIColor.translucentColor;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"tableCell"];
    }
    return _myTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.backgroundColor = UIColor.clearColor;
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"选择图片";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"背景动画";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
        BOOL bgAnimation = [userDefault boolForKey:@"bgAnimation"];
        [userDefault setBool:!bgAnimation forKey:@"bgAnimation"];
        [userDefault synchronize];
        if (self.bgAnimationBlock) {
            self.bgAnimationBlock(!bgAnimation);
        }
    }
}





#pragma mark - 选择背景图片
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.selectImageBlock) {
        self.selectImageBlock(image);
    }
    [UIImageJPEGRepresentation(image, 0.9) writeToFile:BG_IMG_PATH atomically:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
