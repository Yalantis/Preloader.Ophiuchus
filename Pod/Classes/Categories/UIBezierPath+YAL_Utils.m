// For License please refer to LICENSE file in the root of Ophiuchus project

#import "UIBezierPath+YAL_Utils.h"

@implementation UIBezierPath (YAL_Utils)

#pragma mark - Turn upside down

- (void)yal_turnUpsideDown {
    CGRect boundingBox = CGPathGetBoundingBox(self.CGPath);
    [self yal_turnUpsideDownInRect:boundingBox];
}

- (void)yal_turnUpsideDownInRect:(CGRect)rect {
    [self applyTransform:CGAffineTransformMakeScale(1.f, -1.f)];
    [self applyTransform:CGAffineTransformMakeTranslation(0.f, rect.size.height)];
}

#pragma mark - Fit in rect

- (void)yal_fitInRect:(CGRect)rect {
    [self yal_scaleToFitInRect:rect];
    [self yal_translateToCenterInRect:rect];
}

#pragma mark - Scale to fit in rect

- (void)yal_scaleToFitInRect:(CGRect)rect {
    CGFloat scaleFactor = [self yal_scaleFactorToFitInRect:rect];
    [self yal_scaleWithFactor:scaleFactor];
}

- (void)yal_scaleWithFactor:(CGFloat)scaleFactor {
    CGRect boundingBox = self.bounds;
    CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, scaleFactor, scaleFactor);
    scaleTransform = CGAffineTransformTranslate(scaleTransform, - CGRectGetMinX(boundingBox), - CGRectGetMinY(boundingBox));
    [self applyTransform:scaleTransform];
}

#pragma mark - Translate to center in rect

- (void)yal_translateToPoint:(CGPoint)point {
    CGAffineTransform translateTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, point.x, point.y);
    [self applyTransform:translateTransform];
}

- (void)yal_translateToCenterInRect:(CGRect)rect {
    CGFloat scaleFactor = [self yal_scaleFactorToFitInRect:rect];
    [self yal_translateToCenterInRect:rect withFactor:scaleFactor];
}

- (void)yal_translateToCenterInRect:(CGRect)rect withFactor:(CGFloat)scaleFactor {
    CGRect boundingBox = self.bounds;
    CGSize scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGPoint centerOffset = CGPointMake((CGRectGetWidth(rect) - scaledSize.width) / (scaleFactor * 2.f),
                                     (CGRectGetHeight(rect) - scaledSize.height) / (scaleFactor * 2.f));
    [self yal_translateToPoint:centerOffset];
}

#pragma mark - Rotate

- (void)yal_rotateWithAngle:(CGFloat)degree aroundPoint:(CGPoint)point {
    CGFloat radians = M_PI * degree / 180.f;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformTranslate(transform, point.x, point.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -point.x, -point.y);
    
    [self applyTransform:transform];
}

#pragma mark - Scale factor to fit rect

- (CGFloat)yal_scaleFactorToFitInRect:(CGRect)rect {
    CGRect boundingBox = self.bounds;
    CGFloat boundingBoxAspectRation = CGRectGetWidth(boundingBox) / CGRectGetHeight(boundingBox);
    CGFloat rectAspectRatio = CGRectGetWidth(rect) / CGRectGetHeight(rect);
    CGFloat scaleFactor;
    
    if (boundingBoxAspectRation > rectAspectRatio) {
        scaleFactor = CGRectGetWidth(rect) / CGRectGetWidth(boundingBox);
    } else {
        scaleFactor = CGRectGetHeight(rect) / CGRectGetHeight(boundingBox);
    }
    
    return scaleFactor;
}

#pragma mark - Bezier path with paths

+ (UIBezierPath *)yal_bezierPathWithPaths:(NSArray *)paths {
    UIBezierPath *path = [UIBezierPath new];
    
    for (UIBezierPath *subpath in paths) {
        [path appendPath:subpath];
    }
    
    return path;
}

@end
