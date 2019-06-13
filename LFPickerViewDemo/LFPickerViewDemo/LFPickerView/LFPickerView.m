//
//  LFPickerView.m
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFPickerView.h"

#import "LFPickerViewCell.h"

@interface LFPickerView()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray <UITableView *> *components;
@property (nonatomic, strong) NSArray <UIView *> *supplymentViews;
@property (nonatomic, strong) UIView *commonSelectionFrame;

@end

static NSString * const kComponentsReuseIdentifier = @"kComponentsReuseIdentifier";

@implementation LFPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadData];
    }
    return self;
}

- (void)layoutSubviews {
    [self reloadData];
    __weak typeof(self) weakSelf = self;
    
    [self.components enumerateObjectsUsingBlock:^(UITableView * _Nonnull component, NSUInteger index, BOOL * _Nonnull stop) {
        CGFloat componentWidth = [weakSelf.delegate lf_pickerView:weakSelf WidthForComponent:index + 1];
        CGFloat supplymentWidth = [weakSelf.delegate respondsToSelector:@selector(lf_pickerView:widthOfSupplymentView:)] ? [weakSelf.delegate lf_pickerView:weakSelf widthOfSupplymentView:index] : 0;
        CGFloat originX = index * (componentWidth + supplymentWidth);
        component.frame = CGRectMake(originX + supplymentWidth, 0, componentWidth, CGRectGetHeight(weakSelf.frame));
        
        self.supplymentViews[index + 1].frame = CGRectMake((componentWidth + supplymentWidth) * (index + 1), 0, supplymentWidth, CGRectGetHeight(weakSelf.frame));
    }];
    
    if (self.supplymentViews.firstObject) {
        CGFloat supplymentWidth = [self.delegate lf_pickerView:self widthOfSupplymentView:0];
        self.supplymentViews.firstObject.frame = CGRectMake(0, 0, supplymentWidth, CGRectGetHeight(self.frame));
        
    }
    
    if (self.isAutoFillLastRow) {
        UITableView *lastComponent = self.components.lastObject;
        CGFloat lastOriginX = CGRectGetMinX(lastComponent.frame);
        CGFloat lastWidth = CGRectGetWidth(self.frame) - lastOriginX;
        CGFloat lastSupplymentWidth = [self.delegate lf_pickerView:self widthOfSupplymentView:self.supplymentViews.count - 1];
        self.components.lastObject.frame = CGRectMake(lastOriginX, 0, lastWidth - lastSupplymentWidth, CGRectGetHeight(self.frame));
        UIView *lastSupplymnet = self.supplymentViews.lastObject;
        lastSupplymnet.frame = CGRectMake(CGRectGetMaxX(lastComponent.frame), 0, lastSupplymentWidth, CGRectGetHeight(self.frame));
    }
    
    [self.supplymentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf bringSubviewToFront:obj];
    }];
    
    if (self.useCommomSelectionnFrame) {
        CGFloat selectionFrameHeight = [self.delegate lf_heightOfCommonSelectionFramePickerView:self];
        self.commonSelectionFrame.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - selectionFrameHeight) / 2, CGRectGetWidth(self.frame), selectionFrameHeight);
        [self bringSubviewToFront:self.commonSelectionFrame];
    }
    
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
        [component reloadData];
        [self addSubview:component];
    }
    [self.supplymentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull supplymentView, NSUInteger index, BOOL * _Nonnull stop) {
        [supplymentView removeFromSuperview];
    }];
    if (![self.delegate respondsToSelector:@selector(lf_pickerView:SupplymentView:)]) {
        return;
    }
    NSMutableArray *tempSupplymentViews = [NSMutableArray array];
    for (NSInteger i = 0; i < numberOfComponent + 1; i ++) {
        UIView *supplymentView = [self.delegate lf_pickerView:self SupplymentView:i];
        [tempSupplymentViews addObject:supplymentView];
    }
    self.supplymentViews = tempSupplymentViews;
    for (UIView *supplyment in self.supplymentViews) {
        [self addSubview:supplyment];
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

- (void)lf_pickerViweAutoCorrection:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    UITableView *component = (UITableView *)scrollView;
    NSInteger componentIndex = [self.components indexOfObject:component];
    
    NSInteger rowCount = [self.dataSource lf_pickerView:self numberOfRowsInComponent:componentIndex];
    CGFloat tempOffset = 0;
    NSInteger rowIndex = 0;
    for (NSInteger index = 0; index < rowCount; index ++) {
        CGFloat cellHeight = [self.delegate lf_pickerView:self HeightForComponent:componentIndex Row:index];
        tempOffset += cellHeight;
        if (tempOffset > offset) {
            rowIndex = index;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    [component selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [component.delegate tableView:component didSelectRowAtIndexPath:indexPath];
    LFPickerViewCell *cell = [component cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
}

- (void)selectRow:(NSInteger)row Component:(NSInteger)component Animated:(BOOL)animated {
    UITableView *componentTable = self.components[component];
    if (componentTable) {
        [componentTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:animated scrollPosition:UITableViewScrollPositionMiddle];
        [componentTable.delegate tableView:componentTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    }
}

- (void)setUseCommomSelectionnFrame:(BOOL)commomSelectionnFrame {
    _useCommomSelectionnFrame = commomSelectionnFrame;
    if (commomSelectionnFrame) {
        [self addSubview:self.commonSelectionFrame];
    } else {
        [self.commonSelectionFrame removeFromSuperview];
    }
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
        if ([self.delegate respondsToSelector:@selector(lf_pickerView:attributedTitleForRow:forComponent:)]) {
            NSAttributedString *attributeString = [self.delegate lf_pickerView:self attributedTitleForRow:indexPath.row forComponent:componentIndex];
            cell.textLabel.attributedText = attributeString;
        }
        if ([self.delegate respondsToSelector:@selector(lf_pickerView:viewForRow:forComponent:reusingView:)]) {
            UIView *reuseView = [self.delegate lf_pickerView:self viewForRow:indexPath.row forComponent:componentIndex reusingView:cell.reuseableView];
            cell.reuseableView = reuseView;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self lf_pickerViweAutoCorrection:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self lf_pickerViweAutoCorrection:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView *component = (UITableView *)scrollView;
    NSInteger componentIndex = [self.components indexOfObject:component];
    
    NSInteger rowCount = [self.dataSource lf_pickerView:self numberOfRowsInComponent:componentIndex];
    CGFloat tempOffset = 0;
    NSInteger rowIndex = 0;
    CGFloat offset = scrollView.contentOffset.y;
    for (NSInteger index = 0; index < rowCount; index ++) {
        CGFloat cellHeight = [self.delegate lf_pickerView:self HeightForComponent:componentIndex Row:index];
        tempOffset += cellHeight;
        rowIndex = index;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex + 1 inSection:0];
        LFPickerViewCell *cell = [component cellForRowAtIndexPath:indexPath];
        cell.selected = offset > tempOffset - cellHeight / 2 && offset < tempOffset + cellHeight /2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger compentIndex = [self.components indexOfObject:tableView];
    if ([self.delegate respondsToSelector:@selector(lf_pickerView:didSelectRow:inComponent:)]) {
       [self.delegate lf_pickerView:self didSelectRow:indexPath.row inComponent:compentIndex];
    }
}

#pragma mark - LazyLoads

- (UIView *)commonSelectionFrame {
    if (!_commonSelectionFrame) {
        _commonSelectionFrame = [[UIView alloc] initWithFrame:CGRectZero];
        _commonSelectionFrame.layer.borderWidth = 0.5;
        _commonSelectionFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commonSelectionFrame.layer.cornerRadius = 5;
        _commonSelectionFrame.userInteractionEnabled = NO;
    }
    return _commonSelectionFrame;
}

@end
