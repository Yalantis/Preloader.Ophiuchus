// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALLabel.h"
#import "NSAttributedString+YAL_TextBezierPath.h"
#import "YALProgressAnimatingLayer.h"
#import "YALTextLayer.h"

@interface YALLabel ()

@property (nonatomic, weak) YALTextLayer *backgroundLayer;
@property (nonatomic, weak) YALTextLayer *fillLayer;
@property (nonatomic, weak) YALTextLayer *strokeLayer;
@property (nonatomic, strong) NSArray *bezierPaths;
@property (nonatomic, assign) CGFloat scaleFactor;

@end

@implementation YALLabel

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.strokeWidth = kDefaultStrokeWidth;
    
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self redraw];
}

- (void)redraw {
    [self redrawBackground];
    [self redrawFill];
    [self redrawStroke];
}

- (void)redrawBackground {
    if (self.backgroundFillColor) {
        self.backgroundLayer = [YALTextLayer layerWithPaths:self.bezierPaths
                                                  fillColor:self.backgroundFillColor.CGColor
                                                strokeColor:NULL
                                                  lineWidth:0.f
                                                   andBlock:^(YALProgressAnimatingLayer *layer) {
                                                       [self.layer addSublayer:layer];
                                                       [self.backgroundLayer removeFromSuperlayer];
                                                   }];
        CGRect frame = CGPathGetPathBoundingBox(self.backgroundLayer.path);
        self.backgroundLayer.position = (CGPoint){
            (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2.f,
            (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2.f
        };
    }
}

- (void)redrawFill {
    if (self.fillColor) {
        self.fillLayer = [YALTextLayer layerWithPaths:self.bezierPaths
                                            fillColor:self.fillColor.CGColor
                                          strokeColor:NULL
                                            lineWidth:0.f
                                             andBlock:^(YALProgressAnimatingLayer *layer) {
                                                 [self.layer addSublayer:layer];
                                                 [self.fillLayer removeFromSuperlayer];
                                             }];
        CGRect frame = CGPathGetPathBoundingBox(self.fillLayer.path);
        self.fillLayer.position = (CGPoint){
            (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2.f,
            (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2.f
        };
    }
}

- (void)redrawStroke {
    if (self.strokeColor) {
        self.strokeLayer = [YALTextLayer layerWithPaths:self.bezierPaths
                                              fillColor:NULL
                                            strokeColor:self.strokeColor.CGColor
                                              lineWidth:self.strokeWidth
                                               andBlock:^(YALProgressAnimatingLayer *layer) {
                                                   [self.layer addSublayer:layer];
                                                   [self.strokeLayer removeFromSuperlayer];
                                               }];
        CGRect frame = CGPathGetPathBoundingBox(self.strokeLayer.path);
        frame = CGRectInset(frame, self.strokeWidth, self.strokeWidth);
        self.strokeLayer.position = (CGPoint){
            (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2.f,
            (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2.f
        };
    }
}

#pragma mark - Mutators

- (void)setText:(NSString *)text {
    _text = [text copy];
    [self updatePaths];
}

- (void)setFontName:(NSString *)fontName {
    _fontName = [fontName copy];
    [self updatePaths];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updatePaths];
}

- (void)setBackgroundFillColor:(UIColor *)backgroundFillColor {
    _backgroundFillColor = [backgroundFillColor copy];
    [self redrawBackground];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = [fillColor copy];
    [self redrawFill];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = [strokeColor copy];
    [self redrawStroke];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    self.strokeLayer.lineWidth = strokeWidth;
}

#pragma mark - Private

- (void)updatePaths {
    CGFloat fontSize = (self.fontSize) ?: 0.38f;
    UIFont *font = [UIFont fontWithName:self.fontName size:fontSize];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}];
    
    self.bezierPaths = [attributedString yal_bezierPaths];
}

#pragma mark - Interface builder setup

- (void)prepareForInterfaceBuilder {
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
