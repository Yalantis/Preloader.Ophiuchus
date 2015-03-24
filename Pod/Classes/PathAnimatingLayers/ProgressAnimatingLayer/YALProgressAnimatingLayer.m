// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALProgressAnimatingLayer.h"

@interface YALProgressAnimatingLayer ()

@property (nonatomic, assign) BOOL isProgressAllowedToControlAnimations;

@end

@implementation YALProgressAnimatingLayer

#pragma mark - init

- (instancetype)initWithMask {
    if (self = [super init]) {
        self.mask = [self.class new];
    }
    return self;
}

+ (instancetype)layerWithMask {
    return [[self alloc] initWithMask];
}

#pragma mark - Helpers

+ (instancetype)layerWithPath:(CGPathRef)path
                    fillColor:(CGColorRef)fillColor
                  strokeColor:(CGColorRef)strokeColor
                    lineWidth:(CGFloat)lineWidht
                     andBlock:(void(^)(YALProgressAnimatingLayer *layer))block
{
    return ({
        YALProgressAnimatingLayer *layer = [self.class layerWithMask];
        CGRect rect = CGPathGetPathBoundingBox(path);
        rect = CGRectInset(rect, -lineWidht, -lineWidht);
        UIBezierPath *maskingPath = [UIBezierPath bezierPathWithRect:rect];
        
        layer.path = path;
        layer.fillColor = fillColor;
        layer.strokeColor = strokeColor;
        layer.lineWidth = lineWidht;
        layer.mask.path = maskingPath.CGPath;
        
        if (block) {
            block(layer);
        }
        
        layer;
    });
}

+ (instancetype)layerWithPath:(CGPathRef)path andBlock:(void(^)(YALProgressAnimatingLayer *layer))block {
    return [self layerWithPath:path
                     fillColor:NULL
                   strokeColor:NULL
                     lineWidth:0.f
                      andBlock:block];
}

#pragma mark - Mutators

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (self.isProgressAllowedToControlAnimations) {
        self.timeOffset = self.progress;
    }
}

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key {
    if (self.isProgressAllowedToControlAnimations) {
        animation.duration = self.duration;
        animation.timeOffset = self.timeOffset;
    }
    
    [super addAnimation:animation forKey:key];
}

#pragma mark -

- (void)allowProgressToControlAnimations {
    self.speed = 0.f;
    self.timeOffset = 0.0;
    self.isProgressAllowedToControlAnimations = YES;
}

@end
