// For License please refer to LICENSE file in the root of Ophiuchus project

#import <UIKit/UIKit.h>

@class YALPreloaderView;

@interface YALViewController : UIViewController

@property (nonatomic, weak, readonly) YALPreloaderView *preloaderView;
@property (nonatomic, assign) NSInteger index;

@end
