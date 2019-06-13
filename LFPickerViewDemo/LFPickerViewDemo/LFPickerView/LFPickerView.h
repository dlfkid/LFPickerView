//
//  LFPickerView.h
//  LFPickerViewDemo
//
//  Created by LeonDeng on 2019/6/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

@class LFPickerView;

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFPickerViewDelegate

@required

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView WidthForComponent:(NSInteger)component;

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView HeightForComponent:(NSInteger)component Row:(NSInteger)row;

@optional

/// Title for earch row in a component
/// @param pickerView the pickerview
/// @param row the row
/// @param component the component
- (NSString *)lf_pickerView:(LFPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

/// AtrributeTitle for earch row in a component
/// @param pickerView the picker view
/// @param row the row
/// @param component the component
- (NSAttributedString *)lf_pickerView:(LFPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

/// View for each row in component
/// @param pickerView the pickerview
/// @param row the row
/// @param component the component
/// @param view the view cached for reuse
- (UIView *)lf_pickerView:(LFPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

/// Called when row is selected
/// @param pickerView the picker view
/// @param row the row
/// @param component the component
- (void)lf_pickerView:(LFPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


/// the view work as supplyment view
/// @param pickerView the pickerview
/// @param index position of the supplymentView
- (UIView *)lf_pickerView:(LFPickerView *)pickerView SupplymentView:(NSInteger)index;

/// Return Size of the supplyMentView
/// @param pickerView the pickerView
/// @param index position of the supplymentView
- (CGFloat)lf_pickerView:(LFPickerView *)pickerView widthOfSupplymentView:(NSInteger)index;

/// Return height of the common selectionFrame your must set useCommonSelectionframe to YES before the delegate can work
/// @param pickerView the pickerView
- (CGFloat)lf_heightOfCommonSelectionFramePickerView:(LFPickerView *)pickerView;

@end

@protocol LFPickerViewDataSource

@required

/// Indicate how many sections the pickerview should have;
/// @param pickerView PickerView
- (NSInteger)lf_numberOfComponentsInPickerView:(LFPickerView *)pickerView;

/// Indicate that hou many rows each component should have;
/// @param pickerView PickerView
/// @param component component
- (NSInteger)lf_pickerView:(LFPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@interface LFPickerView : UIView

@property (nonatomic, weak) NSObject<LFPickerViewDelegate> *delegate;
@property (nonatomic, weak) NSObject<LFPickerViewDataSource> *dataSource;


/// Determin whether the picker view should filled it's frame with last row;
@property (nonatomic, assign, getter = isAutoFillLastRow) BOOL autoFillLastRow;

/// Determin whether the picker view use a common selection frame, better use when each row shares the same height
@property (nonatomic, assign) BOOL useCommomSelectionnFrame;
@property (nonatomic, strong, readonly) UIView *commonSelectionFrame;

/// ReloadAllData
- (void)reloadData;

/// Select sepcific row in given component
/// @param row the row you want to selected
/// @param component the component
/// @param animated need animation or not
- (void)selectRow:(NSInteger)row Component:(NSInteger)component Animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
