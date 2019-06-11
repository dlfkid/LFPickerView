//
//  LFPickerView.m
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFPickerView.h"

#import "LFPickerViewCell.h"

@interface LFPickerView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LFPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _collectionView = [[UICollectionView alloc] initWithFrame:frame];
        [_collectionView registerClass:[LFPickerViewCell class] forCellWithReuseIdentifier:[LFPickerViewCell reuseIdentifier]];
    }
    return self;
}

- (void)layoutSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [super layoutSubviews];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataSource lf_numberOfComponentsInPickerView:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource lf_pickerView:self numberOfRowsInComponent:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LFPickerViewCell reuseIdentifier] forIndexPath:indexPath];
    // 按照顺序响应协议方法
    if ([self.delegate respondsToSelector:@selector(lf_pickerView:titleForRow:forComponent:)]) {
        NSString *title = [self.delegate lf_pickerView:self titleForRow:indexPath.row forComponent:indexPath.section];
        cell.textLabel.text = title;
    }
    if ([self.delegate respondsToSelector:@selector(lf_pickerView:attributedTitleForRow:forComponent:)]) {
        NSAttributedString *attributeTitle = [self.delegate lf_pickerView:self attributedTitleForRow:indexPath.row forComponent:indexPath.section];
        cell.textLabel.attributedText = attributeTitle;
    }
    if ([self.delegate respondsToSelector:@selector(lf_pickerView:viewForRow:forComponent:reusingView:)]) {
        UIView *view = [self.delegate lf_pickerView:self viewForRow:indexPath.row forComponent:indexPath.section reusingView:cell.reuseableView];
        cell.reuseableView = view;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate lf_pickerView:self SizeOfCellInRow:indexPath.row Component:indexPath.section];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(22, CGRectGetHeight(self.frame));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(22, CGRectGetHeight(self.frame));
}

@end
