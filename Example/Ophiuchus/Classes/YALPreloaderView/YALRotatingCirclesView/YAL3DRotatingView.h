// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@class YAL3DRotatingView;

@protocol YAL3DRotatingViewDelegate <NSObject>

@optional
- (void)rotatingViewDidStopAnimating:(YAL3DRotatingView *)rotatingView;

@end

@interface YAL3DRotatingView : UIView

@property (nonatomic, weak) id<YAL3DRotatingViewDelegate> delegate;
@property (nonatomic, strong) UIColor *fillColor;

- (void)startAnimating;
- (void)stopAnimating;

@end

