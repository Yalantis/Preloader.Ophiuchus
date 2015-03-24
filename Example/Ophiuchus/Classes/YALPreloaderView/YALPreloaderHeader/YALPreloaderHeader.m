// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPreloaderHeader.h"

NSTimeInterval const kYALResizeDuration = 0.8;

YALAlpha const kYALAlpha = (YALAlpha) {
    .min = 0.f,
    .max = 1.f
};

YALMathConstants const kYALMathConstants = (YALMathConstants) {
    .two = 2.f,
    .half = .5f
};

UIColor *yal_rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:a];
};

extern UIColor *yal_rgb(CGFloat r, CGFloat g, CGFloat b) {
    return yal_rgba(r, g, b, 1.f);
};