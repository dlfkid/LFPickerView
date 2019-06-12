//
//  ViewController.m
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
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
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pickerView];
}

- (NSInteger)lf_numberOfComponentsInPickerView:(LFPickerView *)pickerView {
    return 3;
}

- (NSInteger)lf_pickerView:(LFPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)lf_pickerView:(LFPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"R: %ld C: %ld", (long)row, (long)component];
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView WidthForComponent:(NSInteger)component {
    return 100;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView HeightForComponent:(NSInteger)component Row:(NSInteger)row {
    return 44;
}

@end
