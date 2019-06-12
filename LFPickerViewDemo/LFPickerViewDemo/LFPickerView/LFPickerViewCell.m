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
        _reuseableView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.reuseableView];
    }
    return self;
}

- (void)layoutSubviews {
    self.reuseableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    [super layoutSubviews];
}

@end
