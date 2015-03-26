// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPathFillAnimation.h"
#import "UIBezierPath+YAL_Utils.h"

CGFloat yal_cropAngleToHalfCircle(CGFloat angle);
CGFloat yal_proportion(CGFloat sourceValue, CGFloat sourceMinimal, CGFloat sourceMaximal, CGFloat destinationMinimal, CGFloat destinationMaximal);

@implementation YALPathFillAnimation

- (instancetype)initWithPath:(CGPathRef)path andDirectionAngle:(CGFloat)directionAngle {
    YALPathFillAnimation *animation = [YALPathFillAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id)[self pathWithPath:path directionalAngle:directionAngle andCutoffPercent:0.f];
    animation.toValue = (id)[self pathWithPath:path directionalAngle:directionAngle andCutoffPercent:1.f];
    
    return animation;
}

+ (instancetype)animationWithPath:(CGPathRef)path andDirectionAngle:(CGFloat)directionAngle {
    return [[self alloc] initWithPath:path andDirectionAngle:directionAngle];
}

#pragma mark - private

- (CGPathRef)pathWithPath:(CGPathRef)path directionalAngle:(CGFloat)directionalAngle andCutoffPercent:(CGFloat)cutoffPercent {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    CGPoint center = (CGPoint) {CGRectGetMidX(bounds), CGRectGetMidY(bounds)};
    CGRect rect = [self rectWithPath:path andDirectionAngle:directionalAngle];
    rect = [self centerRect:rect inPath:path];
    
    CGFloat cutoff = yal_proportion(cutoffPercent, 0.f, 1.f, 0.f, CGRectGetHeight(rect));
    
    rect.origin.y += rect.size.height - cutoff;
    rect.size.height = cutoff;

    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:rect];
    [newPath yal_rotateWithAngle:directionalAngle aroundPoint:center];
    return newPath.CGPath;
}

- (CGRect)rectWithPath:(CGPathRef)path andDirectionAngle:(CGFloat)directionAngle {
    CGRect rect = CGPathGetBoundingBox(path);
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat alpha = [self properRadianFromAngle:directionAngle];
    
    rect.size.height = height * cosf(alpha) + width * sinf(alpha);
    rect.size.width = sqrt(pow((width), 2.0) + pow((height), 2.0));
    
    return rect;
}

- (CGFloat)properRadianFromAngle:(CGFloat)angle {
    angle = yal_cropAngleToHalfCircle(fabsf(angle));
    
    if (angle > 90) {
        angle = 180 - angle;
    }
    
    return angle * M_PI / 180.f;
}

- (CGRect)centerRect:(CGRect)rect inPath:(CGPathRef)path {
    CGRect centerRect = CGPathGetPathBoundingBox(path);
    CGFloat x = CGRectGetMidX(centerRect) - CGRectGetWidth(rect) / 2.f;
    CGFloat y = CGRectGetMidY(centerRect) - CGRectGetHeight(rect) / 2.f;
    return CGRectMake(x, y, rect.size.width, rect.size.height);
}

@end

CGFloat yal_cropAngleToHalfCircle(CGFloat angle) {
    if (angle > 180) {
        return yal_cropAngleToHalfCircle(angle - 180);
    } else {
        return angle;
    }
}

CGFloat yal_proportion(CGFloat sourceValue, CGFloat sourceMinimal, CGFloat sourceMaximal, CGFloat destinationMinimal, CGFloat destinationMaximal) {
    CGFloat percent = (sourceValue - sourceMinimal) / (sourceMaximal - sourceMinimal);
    CGFloat value = percent * (destinationMaximal - destinationMinimal) + destinationMinimal;
    return MIN(destinationMaximal, MAX(destinationMinimal, value));
}
