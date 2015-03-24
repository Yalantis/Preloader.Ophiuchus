// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPreloaderViewModel.h"
#import "YALPreloaderHeader.h"

@implementation YALPreloaderViewModel

#pragma mark - Static

+ (NSArray *)globalViewModelsArray {
    static NSArray *globalViewModelsArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *array = [NSArray arrayWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Example"
                                                                                        ofType:@"plist"]];
        NSMutableArray *mutableModels = [NSMutableArray new];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [mutableModels addObject:[[self alloc] initWithDictionary:obj]];
        }];
        globalViewModelsArray = [mutableModels copy];
    });
    return globalViewModelsArray;
}

#pragma mark - Init

UIColor *yal_colorFromString(NSString *array);

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.viewBackgroundColor = yal_colorFromString(dict[@"viewBackgroundColor"]);
        self.fillColor = yal_colorFromString(dict[@"fillColor"]);
        self.strokeColor = yal_colorFromString(dict[@"strokeColor"]);
        self.text = dict[@"text"];
        self.fontName = dict[@"fontName"];
        self.fontSize = [dict[@"fontSize"] floatValue];
        self.contentMode = [dict[@"contentMode"] integerValue];
        self.showingDots = [dict[@"showingDots"] boolValue];
    }
    return self;
}

#pragma mark - Private

UIColor *yal_colorFromString(NSString *string) {
    NSArray *array = [string componentsSeparatedByString:@" "];
    return yal_rgb([array[0] floatValue],
                   [array[1] floatValue],
                   [array[2] floatValue]);
}

@end
