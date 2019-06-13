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

/// reuseAbleView when using customized view as cells
@property (nonatomic, strong) UIView *reuseableView;

/// show selection frame for each cell
@property (nonatomic, assign, getter = hasSelectionFrame) BOOL selectionFrame;
@property (nonatomic, assign) CGFloat selectionFrameCornerRadius;
@property (nonatomic, assign) CGFloat selectionFrameWdith;
@property (nonatomic, strong) UIColor *selectionFrameColor;

+ (CGSize)itemSize;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
