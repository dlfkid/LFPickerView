//
//  LFPickerViewCell.h
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFPickerViewCell : UITableViewCell
@property (nonatomic, strong) UIView *reuseableView;

+ (CGSize)itemSize;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
