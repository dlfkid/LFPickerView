//
//  LFPickerView.m
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFPickerView.h"

#import "LFPickerViewCell.h"

@interface LFPickerView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray <UITableView *> *components;
@property (nonatomic, strong) UIView *selectionFrame;

@end

static NSString * const kComponentsReuseIdentifier = @"kComponentsReuseIdentifier";

@implementation LFPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadData];
        [self addSubview:self.selectionFrame];
    }
    return self;
}

- (void)layoutSubviews {
    [self reloadData];
    __weak typeof(self) weakSelf = self;
    [self.components enumerateObjectsUsingBlock:^(UITableView * _Nonnull component, NSUInteger index, BOOL * _Nonnull stop) {
        CGFloat componentWidth = [weakSelf.delegate lf_pickerView:weakSelf WidthForComponent:index];
        CGFloat originX = 0;
        for (NSInteger i = 0; i < index; i ++) {
            originX += [weakSelf.delegate lf_pickerView:weakSelf WidthForComponent:i];
        }
        component.frame = CGRectMake(originX, 0, componentWidth, CGRectGetHeight(weakSelf.frame));
    }];
    
    self.selectionFrame.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame), 1);
    [self bringSubviewToFront:self.selectionFrame];
    
    [super layoutSubviews];
}

#pragma mark - Actions

- (void)reloadData {
    [self.components enumerateObjectsUsingBlock:^(UITableView * _Nonnull component, NSUInteger index, BOOL * _Nonnull stop) {
       // 移除所有的tableView
        [component removeFromSuperview];
    }];
    NSMutableArray *tempComponents = [NSMutableArray array];
    NSInteger numberOfComponent = [self.dataSource lf_numberOfComponentsInPickerView:self];
    for (NSInteger i = 0; i < numberOfComponent; i ++) {
        UITableView *componentTable = [self componentsInit];
        [tempComponents addObject:componentTable];
    }
    self.components = tempComponents;
    for (UITableView *component in self.components) {
        [component registerClass:[LFPickerViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%ld", [LFPickerViewCell reuseIdentifier], (long)[self.components indexOfObject:component]]];
        [self addSubview:component];
    }
    
}

- (UITableView *)componentsInit {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource lf_pickerView:self numberOfRowsInComponent:(NSInteger)[self.components indexOfObject:tableView]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger componentIndex = (NSInteger)[self.components indexOfObject:tableView];
    if (componentIndex < self.components.count) {
        LFPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@_%ld", [LFPickerViewCell reuseIdentifier], (long)componentIndex]];
        if ([self.delegate respondsToSelector:@selector(lf_pickerView:titleForRow:forComponent:)]) {
            NSString *title = [self.delegate lf_pickerView:self titleForRow:indexPath.row forComponent:componentIndex];
            cell.textLabel.text = title;
        }
        return cell;
    } else {
        return [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate lf_pickerView:self HeightForComponent:(NSInteger)[self.components indexOfObject:tableView] Row:indexPath.row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger componentIndex = [self.components indexOfObject:tableView];
    CGFloat firstCellHeight = [self.delegate lf_pickerView:self HeightForComponent:componentIndex Row:0];
    return (CGRectGetHeight(self.frame) - firstCellHeight) / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSInteger componentIndex = [self.components indexOfObject:tableView];
    CGFloat lastCellHeight = [self.delegate lf_pickerView:self HeightForComponent:componentIndex Row:[self.dataSource lf_pickerView:self numberOfRowsInComponent:componentIndex] - 1];
    return (CGRectGetHeight(self.frame) - lastCellHeight) / 2 ;
}

#pragma mark - LazyLoads

- (UIView *)selectionFrame {
    if (!_selectionFrame) {
        _selectionFrame = [[UIView alloc] initWithFrame:CGRectZero];
        _selectionFrame.layer.borderWidth = 0.5;
        _selectionFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _selectionFrame.layer.cornerRadius = 5;
    }
    return _selectionFrame;
}

@end
