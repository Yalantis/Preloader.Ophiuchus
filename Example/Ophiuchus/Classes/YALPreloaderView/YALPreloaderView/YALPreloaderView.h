// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@class YALLabel;
@class YALPreloaderViewModel;

@interface YALPreloaderView : UIView

@property (nonatomic, strong, readonly) YALLabel *letterView;
@property (nonatomic, copy) UIColor *fillColor;
@property (nonatomic, copy) UIColor *strokeColor;
@property (nonatomic, copy) UIColor *backgroundFillColor;
@property (nonatomic, copy) UIColor *circleBackgroundColor;
@property (nonatomic, assign) CGFloat sizeRatio;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL showsDots;

+ (instancetype)showPreloaderViewInView:(UIView *)view;
- (void)showPreloaderViewInView:(UIView *)view;
- (void)hide;
- (void)setProgress:(CGFloat)progress;
- (void)configureWithViewModel:(YALPreloaderViewModel *)viewModel;

@end
