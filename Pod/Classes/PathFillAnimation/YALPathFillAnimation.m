// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPathFillAnimation.h"
#import "UIBezierPath+YAL_Utils.h"

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
    CGRect bounds = CGPathGetPathBoundingBox(path);
    CGRect rect = bounds;
    CGFloat diagonal = sqrt(pow((rect.size.width), 2.0) + pow((rect.size.height), 2.0));
    
    rect.size.height = [self heightWithRect:rect diagonal:diagonal andDirectionAngle:directionAngle];
    rect.size.width = diagonal;
    
    return rect;
}

- (CGFloat)heightWithRect:(CGRect)rect diagonal:(CGFloat)diagonal andDirectionAngle:(CGFloat)directionAngle {
    directionAngle = abs(directionAngle);
    CGFloat height = 0.f;
    
    if (directionAngle > 180.f) {
        directionAngle -= 180.f;
    }
    
    if (directionAngle <= 45.f) {
        height = yal_proportion(directionAngle, 0.f, 45.f, rect.size.height, diagonal);
    } else if (directionAngle <= 90.f) {
        height = yal_proportion(directionAngle, 45.f, 90.f, rect.size.width, diagonal);
    } else if (directionAngle <= 135.f) {
        height = yal_proportion(directionAngle, 135.f, 90.f, rect.size.width, diagonal);
    } else if (directionAngle <= 180.f) {
        height = yal_proportion(directionAngle, 180.f, 135.f, rect.size.height, diagonal);
    }
    
    return height;
}

- (CGRect)centerRect:(CGRect)rect inPath:(CGPathRef)path {
    CGRect centerRect = CGPathGetPathBoundingBox(path);
    CGFloat x = CGRectGetMidX(centerRect) - CGRectGetWidth(rect) / 2.f;
    CGFloat y = CGRectGetMidY(centerRect) - CGRectGetHeight(rect) / 2.f;
    return CGRectMake(x, y, rect.size.width, rect.size.height);
}

@end

CGFloat yal_proportion(CGFloat sourceValue, CGFloat sourceMinimal, CGFloat sourceMaximal, CGFloat destinationMinimal, CGFloat destinationMaximal) {
    CGFloat percent = (sourceValue - sourceMinimal) / (sourceMaximal - sourceMinimal);
    CGFloat value = percent * (destinationMaximal - destinationMinimal) + destinationMinimal;
    return MIN(destinationMaximal, MAX(destinationMinimal, value));
}
