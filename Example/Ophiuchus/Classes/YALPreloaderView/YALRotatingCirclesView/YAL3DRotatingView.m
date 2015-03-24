// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YAL3DRotatingView.h"
#import "YALPreloaderHeader.h"

@interface YAL3DRotatingView ()

@property (nonatomic, strong) CAShapeLayer *leftCircle;
@property (nonatomic, strong) CAShapeLayer *rightCircle;
@property (nonatomic, assign, getter = isHidingAnimationsOnLastTick) BOOL hidingAnimationsOnLastTick;

@end

static CGFloat const kYALLetterOffsetCoef = .2f;
static CGFloat const kYALLetterLengthCoef = .2275f;
static CGFloat const kYALCircleSizeCoef = .08f;
static CGFloat const kYALCircleXOffsetCoef = .25f;
static CGFloat const kYALM34 = -1.f / 1000.f;
static CGFloat const kYALRotatingMaxZ = 400.f;
static NSTimeInterval const kYALSemiRotationAnimationDuration = 1.31;
static NSTimeInterval const kYALAppearDuration = .45;
static NSTimeInterval const kYALHideAnimationDelay = .2;

typedef struct {
    __unsafe_unretained NSString *key;
    __unsafe_unretained NSString *leftValue;
    __unsafe_unretained NSString *rightValue;
} YALRotatingAnimationKeys;
YALRotatingAnimationKeys const kYALRotatingAnimationKeys = (YALRotatingAnimationKeys) {
    .key = @"customKey",
    .leftValue = @"LEFT",
    .rightValue = @"RIGHT"
};

@implementation YAL3DRotatingView

#pragma mark - Initialization + Helpers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect bounds = self.bounds;
        CGFloat width = CGRectGetWidth(bounds);
        CGFloat height = CGRectGetHeight(bounds);
        
        CGFloat circleWidth = width * kYALCircleSizeCoef;
        CGFloat circleHeight = height * kYALCircleSizeCoef;
        CGFloat circleY = height * (1 - kYALLetterOffsetCoef - kYALLetterLengthCoef);
        CGFloat circleXOffset = width * kYALCircleXOffsetCoef;
        
        CGRect leftRect = CGRectMake(circleXOffset, circleY, circleWidth, circleHeight);
        CGRect rightRect = CGRectMake(width - circleXOffset - circleWidth, circleY, circleWidth, circleHeight);
        
        _leftCircle = [self circleLayerWithFrame:leftRect];
        _rightCircle = [self circleLayerWithFrame:rightRect];
        
        [self.layer addSublayer:_leftCircle];
        [self.layer addSublayer:_rightCircle];
        [self hideDotsWithDuration:0.0];
        
        _hidingAnimationsOnLastTick = NO;
    }
    
    return self;
}

- (CAShapeLayer *)circleLayerWithFrame:(CGRect)frame {
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.frame = frame;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds].CGPath;
    layer.doubleSided = YES;
    return layer;
}

#pragma mark - Public

- (void)startAnimating {
    [self showDots];
    self.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYALAppearDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupLeftAnimation];
        [self setupRightAnimation];
    });
}

- (void)stopAnimating {
    self.hidingAnimationsOnLastTick = YES;
}

#pragma mark - Property

- (void)setFillColor:(UIColor *)fillColor {
    if (fillColor != _fillColor) {
        _fillColor = fillColor;
        CGColorRef color = self.fillColor.CGColor;
        self.leftCircle.fillColor = color;
        self.rightCircle.fillColor = color;
    }
}

#pragma mark - Private (animation creation)

- (void)setupLeftAnimation {
    CALayer *layer = self.leftCircle;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = kYALM34;
    
    CGFloat leftX = self.leftCircle.frame.origin.x;
    CGFloat rightX = self.rightCircle.frame.origin.x;
    CGFloat deltaX = rightX - leftX;
    CGFloat midX = deltaX / kYALMathConstants.two;
    CGFloat width = CGRectGetWidth(self.leftCircle.frame);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, 0.0, 0.0, 0.0)],
                         [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, midX - width, 0.0, kYALRotatingMaxZ)],
                         [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, deltaX, 0.0, 0.0)],
                         [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, midX + width, 0.0, -kYALRotatingMaxZ)],
                         [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, 0.0, 0.0, 0.0)]
                         ];
    animation.duration = kYALSemiRotationAnimationDuration;
    animation.autoreverses = NO;
    animation.delegate = self;
    [animation setValue:kYALRotatingAnimationKeys.leftValue forKey:kYALRotatingAnimationKeys.key];
    [layer addAnimation:animation forKey:animation.keyPath];
}

- (void)setupRightAnimation {
    CALayer *layer = self.rightCircle;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = kYALM34;
    
    CGFloat leftX = self.leftCircle.frame.origin.x;
    CGFloat rightX = self.rightCircle.frame.origin.x;
    CGFloat deltaX = rightX - leftX;
    CGFloat midX = deltaX / kYALMathConstants.two;
    CGFloat width = CGRectGetWidth(self.rightCircle.frame);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, 0, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, -midX - width, 0, -kYALRotatingMaxZ)],
                        [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, -deltaX, 0, 0)],
                        [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, -midX + width, 0, kYALRotatingMaxZ)],
                        [NSValue valueWithCATransform3D:CATransform3DTranslate(transform, 0, 0, 0)],
                        nil];
    animation.duration = kYALSemiRotationAnimationDuration;
    animation.autoreverses = NO;
    animation.delegate = self;
    [animation setValue:kYALRotatingAnimationKeys.rightValue forKey:kYALRotatingAnimationKeys.key];
    [layer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark - Private (animating)

- (void)showDots {
    NSArray *layers = @[self.leftCircle, self.rightCircle];
    
    for (CALayer *layer in layers) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0., 0.f, 1.0)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        [animation setDuration:kYALAppearDuration];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [layer addAnimation:animation forKey:@"zoom"];
    }
}

- (void)hideDotsWithDuration:(NSTimeInterval)duration {
    NSArray *layers = @[self.leftCircle, self.rightCircle];
    
    for (CALayer *layer in layers) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0., 0., 1.0)];
        animation.fillMode = kCAFillModeForwards;
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        [layer addAnimation:animation forKey:@"zoom"];
    }
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!self.isHidingAnimationsOnLastTick) {
        
        if ([[anim valueForKey:kYALRotatingAnimationKeys.key] isEqualToString:kYALRotatingAnimationKeys.leftValue]) {
            [self setupLeftAnimation];
        } else if ([[anim valueForKey:kYALRotatingAnimationKeys.key] isEqualToString:kYALRotatingAnimationKeys.rightValue]) {
            [self setupRightAnimation];
        }
        
    } else {
        
        [self hideDotsWithDuration:kYALAppearDuration];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYALHideAnimationDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(rotatingViewDidStopAnimating:)]) {
                [self.delegate rotatingViewDidStopAnimating:self];
            }
        });
    }
}

@end
