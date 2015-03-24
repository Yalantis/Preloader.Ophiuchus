// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@interface YALProgressAnimatingLayer : CAShapeLayer

@property (nonatomic, strong) YALProgressAnimatingLayer *mask;
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)layerWithMask;
+ (instancetype)layerWithPath:(CGPathRef)path
                     andBlock:(void(^)(YALProgressAnimatingLayer *layer))block;
+ (instancetype)layerWithPath:(CGPathRef)path
                    fillColor:(CGColorRef)color
                  strokeColor:(CGColorRef)strokeColor
                    lineWidth:(CGFloat)strokeWidth
                     andBlock:(void(^)(YALProgressAnimatingLayer *layer))block;

- (void)allowProgressToControlAnimations;

@end
