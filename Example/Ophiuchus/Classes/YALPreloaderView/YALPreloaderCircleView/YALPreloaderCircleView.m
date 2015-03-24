// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPreloaderCircleView.h"
#import "YALPreloaderHeader.h"

@implementation YALPreloaderCircleView

#pragma mark - Class methods

+ (Class)layerClass {
    return [CAShapeLayer class];
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
}

#pragma mark - Public

- (void)animateToRect:(CGRect)rect completion:(void (^)(void))completion {
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:completion];
        CABasicAnimation *animation = [self scalingAnimationForRect:[self centeredRectFromRect:rect]];
        [self.layer addAnimation:animation forKey:nil];
    } [CATransaction commit];
}

#pragma mark - Property

- (UIColor *)layerFillColor {
    return [UIColor colorWithCGColor:[(CAShapeLayer *)self.layer fillColor]];
}

- (void)setLayerFillColor:(UIColor *)layerFillColor {
    [(CAShapeLayer *)self.layer setFillColor:layerFillColor.CGColor];
}

#pragma mark - Private

- (CGRect)centeredRectFromRect:(CGRect)rect {
    CGRect layerRect = self.layer.bounds;
    CGFloat xInset = (CGRectGetWidth(layerRect) - CGRectGetWidth(rect)) * kYALMathConstants.half;
    CGFloat yInset = (CGRectGetHeight(layerRect) - CGRectGetHeight(rect)) * kYALMathConstants.half;
    return CGRectInset(layerRect, xInset, yInset);
}

- (CABasicAnimation *)scalingAnimationForRect:(CGRect)rect {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = kYALResizeDuration;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    return animation;
}

@end