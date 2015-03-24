// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALProgressAnimatingLayer.h"

@interface YALTextLayer : YALProgressAnimatingLayer

+ (instancetype)layerWithPaths:(NSArray *)paths
                     fillColor:(CGColorRef)fillColor
                   strokeColor:(CGColorRef)strokeColor
                     lineWidth:(CGFloat)lineWidth
                      andBlock:(void(^)(YALProgressAnimatingLayer *layer))block;

@end
