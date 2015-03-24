// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALTextLayer.h"
#import "UIBezierPath+YAL_Utils.h"

@implementation YALTextLayer

+ (instancetype)layerWithPaths:(NSArray *)paths
                     fillColor:(CGColorRef)fillColor
                   strokeColor:(CGColorRef)strokeColor
                     lineWidth:(CGFloat)lineWidth
                      andBlock:(void(^)(YALProgressAnimatingLayer *layer))block
{
    UIBezierPath *compoundPath = [UIBezierPath yal_bezierPathWithPaths:paths];
    CGRect bounds = CGPathGetPathBoundingBox(compoundPath.CGPath);
    void (^sublayersCosntruction)(YALProgressAnimatingLayer *layer) = [self sublayersConstructionBlockWithPaths:paths
                                                                                         fillColor:fillColor
                                                                                       strokeColor:strokeColor
                                                                                         lineWidth:lineWidth];
    
    bounds = CGRectInset(bounds, -lineWidth, -lineWidth);
    compoundPath = [UIBezierPath bezierPathWithRect:bounds];
    
    YALTextLayer *layer = [self.class layerWithPath:compoundPath.CGPath
                                          fillColor:NULL
                                        strokeColor:NULL
                                          lineWidth:0.f
                                           andBlock:sublayersCosntruction];
    
    if (block) {
        block(layer);
    }
    
    return layer;
}

+ (void(^)(YALProgressAnimatingLayer *))sublayersConstructionBlockWithPaths:(NSArray *)paths
                                                    fillColor:(CGColorRef)fillColor
                                                  strokeColor:(CGColorRef)strokeColor
                                                    lineWidth:(CGFloat)lineWidth
{
    return ^(YALProgressAnimatingLayer *layer) {
        for (UIBezierPath *path in paths) {
            [YALProgressAnimatingLayer layerWithPath:path.CGPath
                              fillColor:fillColor
                            strokeColor:strokeColor
                              lineWidth:lineWidth
                               andBlock:^(YALProgressAnimatingLayer *sublayer) {
                                   [layer addSublayer:sublayer];
                               }];
        }
    };
}

@end
