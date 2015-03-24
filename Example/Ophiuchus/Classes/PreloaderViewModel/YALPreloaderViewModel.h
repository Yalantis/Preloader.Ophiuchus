// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@interface YALPreloaderViewModel : NSObject

@property (nonatomic, copy) UIColor *viewBackgroundColor;
@property (nonatomic, copy) UIColor *fillColor;
@property (nonatomic, copy) UIColor *strokeColor;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, assign, getter = isShowingDots) BOOL showingDots;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)globalViewModelsArray;

@end
