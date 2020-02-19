# LFPickerView
Customizable UIPicker View
![alt text](/demoPic.png)
## Features

When I was trying to use UIPicker View to implenment an apple's stopwatch I was shocked... THERE IS NO WAY YOU CAN DO THAT Cause UIPickeView doesn't support supplyment views. So I intent to make my own widgets;

1. Supports supplymnet views & headers, you can put any view you want in the middle of the revolvers.

2. 2 styles of selection frame, if you use a picker view which has the same row height for every components, you can choose a common selection frame. Otherwise, customize your selection frame in each components.

3. Auto fill, it's annoying that your components didn't fill the whole view, you can fix it through fill the space with your last components.

## Usage

1. import "LFPickerView.h"

2. Initialize

```objc

self.pickerView = [[LFPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    self.pickerView.backgroundColor = [UIColor blackColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoFillLastRow = YES;
    self.pickerView.useCommomSelectionFrame = YES;
    [self.view addSubview:self.pickerView];

```

3. Implenment DataSource & Delegate

```objc
- (UIView *)lf_pickerView:(LFPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%02zd", row];
    label.frame = CGRectMake(0, 0, 60, 50);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView WidthForComponent:(NSInteger)component {
    return 60;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView HeightForComponent:(NSInteger)component Row:(NSInteger)row {
    return 50;
}

- (UIView *)lf_pickerView:(LFPickerView *)pickerView SupplymentView:(NSInteger)index {
    UILabel *indicateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *supplymentText = nil;
    if (index == 0) {
        supplymentText = @"Hour";
    } else if (index == 1) {
        supplymentText = @"Min";
    } else if (index == 2) {
        supplymentText = @"Sec";
    } else {
        supplymentText = @"";
    }
    indicateLabel.text = supplymentText;
    indicateLabel.textColor = [UIColor whiteColor];
    indicateLabel.textAlignment = NSTextAlignmentCenter;
    return indicateLabel;
}

- (CGFloat)lf_pickerView:(LFPickerView *)pickerView widthOfSupplymentView:(NSInteger)index {
    if (index == 0) {
        return 50;
    } else if (index == 1) {
        return 50;
    } else if (index == 2) {
        return 50;
    } else {
        return 0;
    }
}

- (CGFloat)lf_heightOfCommonSelectionFramePickerView:(LFPickerView *)pickerView {
    return 56;
}
```

## License

**LFPickerView** is released under the MIT License. See LICENSE for details.
