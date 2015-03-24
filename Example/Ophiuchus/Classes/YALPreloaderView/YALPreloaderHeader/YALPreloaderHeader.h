// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

extern NSTimeInterval const kYALResizeDuration;

typedef struct {
    CGFloat min;
    CGFloat max;
} YALAlpha;
extern YALAlpha const kYALAlpha;

typedef struct {
    CGFloat two;
    CGFloat half;
} YALMathConstants;
extern YALMathConstants const kYALMathConstants;

extern UIColor *yal_rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
extern UIColor *yal_rgb(CGFloat r, CGFloat g, CGFloat b);




