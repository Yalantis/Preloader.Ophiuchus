// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>
#import "YALTextLayer.h"

static const CGFloat kDefaultStrokeWidth = 1.f;

@class YALTextLayer;

IB_DESIGNABLE

@interface YALLabel : UIView

@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;
@property (nonatomic, strong) IBInspectable UIColor *backgroundFillColor;
@property (nonatomic, assign) IBInspectable CGFloat strokeWidth;

@property (nonatomic, assign) IBInspectable CGFloat fontSize;
@property (nonatomic, copy) IBInspectable NSString *fontName;
@property (nonatomic, copy) IBInspectable NSString *text;

@property (nonatomic, weak, readonly) YALTextLayer *backgroundLayer;
@property (nonatomic, weak, readonly) YALTextLayer *fillLayer;
@property (nonatomic, weak, readonly) YALTextLayer *strokeLayer;

@property (nonatomic, readonly) NSArray *bezierPaths;
@property (nonatomic, readonly) UIBezierPath *compoundBezierPath;

@end
