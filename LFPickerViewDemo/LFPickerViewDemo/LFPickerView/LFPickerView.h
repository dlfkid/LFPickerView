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


/// Returen Size of earch cell
/// @param pickerView the picker view
/// @param row cell row
/// @param componen cell component
- (CGSize)lf_pickerView:(LFPickerView *)pickerView SizeOfCellInRow:(NSInteger)row Component:(NSInteger)componen;

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

@end

@protocol LFPickerViewDataSource

@required

/// Indicate how many sections the pickerview should have;
/// @param pickerView PickerView
- (NSInteger)lf_numberOfComponentsInPickerView:(LFPickerView *)pickerView;

/// Indicate that hou many rows each component should have;
/// @param pickerView PickerView
/// @param component the compont index
- (NSInteger)lf_pickerView:(LFPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@interface LFPickerView : UIView

@property (nonatomic, weak) NSObject<LFPickerViewDelegate> *delegate;
@property (nonatomic, weak) NSObject<LFPickerViewDataSource> *dataSource;

@end

NS_ASSUME_NONNULL_END
