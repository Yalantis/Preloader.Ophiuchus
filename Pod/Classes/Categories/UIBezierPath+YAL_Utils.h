// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@interface UIBezierPath (YAL_Utils)

- (void)yal_turnUpsideDown;
- (void)yal_turnUpsideDownInRect:(CGRect)rect;

- (void)yal_fitInRect:(CGRect)rect;

- (void)yal_scaleToFitInRect:(CGRect)rect;
- (void)yal_scaleWithFactor:(CGFloat)scaleFactor;

- (void)yal_translateToPoint:(CGPoint)point;
- (void)yal_translateToCenterInRect:(CGRect)rect;
- (void)yal_translateToCenterInRect:(CGRect)rect withFactor:(CGFloat)scaleFactor;

- (void)yal_rotateWithAngle:(CGFloat)degree aroundPoint:(CGPoint)point;

- (CGFloat)yal_scaleFactorToFitInRect:(CGRect)rect;

+ (UIBezierPath *)yal_bezierPathWithPaths:(NSArray *)paths;

@end
