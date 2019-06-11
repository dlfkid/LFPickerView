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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.contentView.frame) - self.textLabel.intrinsicContentSize.height) / 2, self.textLabel.intrinsicContentSize.width, self.textLabel.intrinsicContentSize.height)];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        
        _reuseableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        [self.contentView addSubview:self.reuseableView];
    }
    return self;
}

@end
