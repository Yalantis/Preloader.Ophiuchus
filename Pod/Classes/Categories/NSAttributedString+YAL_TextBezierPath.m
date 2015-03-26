// For License please refer to LICENSE file in the root of Ophiuchus project

#import "NSAttributedString+YAL_TextBezierPath.h"
#import "UIBezierPath+YAL_Utils.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (YAL_TextBezierPath)

- (UIBezierPath *)yal_bezierPath {
    NSArray *paths = [self yal_bezierPaths];
    return [self yal_bezierPathFromPaths:paths WithRange:NSMakeRange(0, paths.count)];
}

- (UIBezierPath *)yal_bezierPathWithRange:(NSRange)range {
    NSArray *paths = [self yal_bezierPaths];
    return [self yal_bezierPathFromPaths:paths WithRange:range];
}

- (UIBezierPath *)yal_bezierPathFromPaths:(NSArray *)paths WithRange:(NSRange)range {
    NSArray *reducedPaths = [paths subarrayWithRange:range];
    return [UIBezierPath yal_bezierPathWithPaths:reducedPaths];
}

- (NSArray *)yal_bezierPaths {
    NSMutableArray *letters = [NSMutableArray new];
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    CGRect biggestBoundingBox = CGRectZero;
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            CFRange range = CFRangeMake(glyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, range, &glyph);
            CTRunGetPositions(run, range, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            
            if (!letter) {
                continue;
            }
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letter];
            CGRect boundingBox = CGPathGetBoundingBox(letter);
            
            if (CGRectGetHeight(boundingBox) > CGRectGetHeight(biggestBoundingBox)) {
                biggestBoundingBox = boundingBox;
            }
            
            CGPathRelease(letter);
            [path applyTransform:transform];
            [letters addObject:path];
        }
    }
    
    for (UIBezierPath *letter in letters) {
        [letter yal_turnUpsideDownInRect:biggestBoundingBox];
    }
    
    CFRelease(line);
    return [NSArray arrayWithArray:letters];
}

@end
