//
//  ViewController.m
//  PickerViewDemo
//
//  Created by Ivan_deng on 2019/6/23.
//  Copyright © 2019 SealDevelopmentTeam. All rights reserved.
//

#import "ViewController.h"

#import "LFPickerView.h"

@interface ViewController ()<LFPickerViewDelegate, LFPickerViewDataSource>

@property (nonatomic, strong) LFPickerView *pickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[LFPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    self.pickerView.backgroundColor = [UIColor blackColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoFillLastRow = YES;
    self.pickerView.useCommomSelectionFrame = YES;
    [self.view addSubview:self.pickerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.pickerView selectRow:3 Component:1 Animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 3), dispatch_get_main_queue(), ^{
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        headerView.text = @"Header";
        headerView.textColor = [UIColor whiteColor];
        self.pickerView.pickerHeader = headerView;
    });
}

- (NSInteger)lf_numberOfComponentsInPickerView:(LFPickerView *)pickerView {
    return 3;
}

- (NSInteger)lf_pickerView:(LFPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else if (component == 1) {
        return 60;
    } else if (component == 2) {
        return 60;
    } else {
        return 0;
    }
}

//- (NSString *)lf_pickerView:(LFPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [NSString stringWithFormat:@"R: %ld C: %ld", (long)row, (long)component];
//}

- (UIView *)lf_pickerView:(LFPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%02zd", row];
    label.frame = CGRectMake(0, 0, 60, 50);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView WidthForComponent:(NSInteger)component {
    return 60;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView HeightForComponent:(NSInteger)component Row:(NSInteger)row {
    return 50;
}

- (UIView *)lf_pickerView:(LFPickerView *)pickerView SupplymentView:(NSInteger)index {
    UILabel *indicateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *supplymentText = nil;
    if (index == 0) {
        supplymentText = @"Hour";
    } else if (index == 1) {
        supplymentText = @"Min";
    } else if (index == 2) {
        supplymentText = @"Sec";
    } else {
        supplymentText = @"";
    }
    indicateLabel.text = supplymentText;
    indicateLabel.textColor = [UIColor whiteColor];
    indicateLabel.textAlignment = NSTextAlignmentCenter;
    return indicateLabel;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView widthOfSupplymentView:(NSInteger)index {
    if (index == 0) {
        return 50;
    } else if (index == 1) {
        return 50;
    } else if (index == 2) {
        return 50;
    } else {
        return 0;
    }
}

- (CGFloat)lf_heightOfCommonSelectionFramePickerView:(LFPickerView *)pickerView {
    return 56;
}

@end
