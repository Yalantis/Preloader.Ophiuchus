// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@interface NSAttributedString (YAL_TextBezierPath)

- (UIBezierPath *)yal_bezierPath;
- (UIBezierPath *)yal_bezierPathWithRange:(NSRange)range;
- (NSArray *)yal_bezierPaths;

@end
