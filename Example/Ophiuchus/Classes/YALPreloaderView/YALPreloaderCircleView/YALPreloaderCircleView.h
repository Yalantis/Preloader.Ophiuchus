// For License please refer to LICENSE file in the root of Ophiuchus projects

#import <UIKit/UIKit.h>

@interface YALPreloaderCircleView : UIView

@property (nonatomic, strong) UIColor *layerFillColor;

- (void)animateToRect:(CGRect)rect completion:(void(^)(void))completion;

@end
