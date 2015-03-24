// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@interface YALPathFillAnimation : CABasicAnimation

- (instancetype)initWithPath:(CGPathRef)path andDirectionAngle:(CGFloat)directionAngle;
+ (instancetype)animationWithPath:(CGPathRef)path andDirectionAngle:(CGFloat)directionAngle;

@end
