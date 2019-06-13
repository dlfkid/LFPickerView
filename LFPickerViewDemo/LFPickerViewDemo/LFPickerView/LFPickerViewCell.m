//
//  LFPickerViewCell.m
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFPickerViewCell.h"

@interface LFPickerViewCell()

@end

@implementation LFPickerViewCell

+ (CGSize)itemSize {
    return CGSizeMake(100, 44);
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] + 2];
        self.textLabel.alpha = 1;
    } else {
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textLabel.alpha = 0.7;
    }
    if (self.hasSelectionFrame) {
        self.contentView.layer.borderWidth = selected ? self.selectionFrameWdith : 0;
        self.contentView.layer.borderColor = self.selectionFrameColor ? self.selectionFrameColor.CGColor : [UIColor lightGrayColor].CGColor;
        self.contentView.layer.cornerRadius = self.selectionFrameCornerRadius;
    }
}

- (void)layoutSubviews {
    if (self.reuseableView) {
        self.reuseableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    }
    [super layoutSubviews];
}

- (void)setReuseableView:(UIView *)reuseableView {
    [self.reuseableView removeFromSuperview];
    _reuseableView = reuseableView;
    if (!self.reuseableView.superview) {
        [self.contentView addSubview:self.reuseableView];
    }
}

@end
