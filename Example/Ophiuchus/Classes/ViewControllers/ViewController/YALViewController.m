// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALViewController.h"
#import "YALPreloaderView.h"
#import "YALPreloaderHeader.h"
#import "YALInterfaceManager.h"
#import "YALPreloaderViewModel.h"
#import <Ophiuchus/YALLabel.h>
#import <Ophiuchus/YALPathFillAnimation.h>

@interface YALViewController ()

@property (nonatomic, weak) YALPreloaderView *preloaderView;

@end

@implementation YALViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    self.view.backgroundColor = [YALInterfaceManager yal_orange];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupPreloaderView];
        self.preloaderView.progress = 0.f;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performTaskWithProgress];
        [self addAnimationToLetterView];
    });
}

- (void)addAnimationToLetterView {
    YALTextLayer *fillLayer = self.preloaderView.letterView.fillLayer;
    CABasicAnimation *fillAnimation = [YALPathFillAnimation animationWithPath:fillLayer.mask.path andDirectionAngle:[self angle]];
    
    [fillLayer.mask allowProgressToControlAnimations];
    [fillLayer.mask addAnimation:fillAnimation forKey:@"fillAnimation"];
    self.preloaderView.progress = 0.f;
}

#pragma mark - Private

- (NSTimeInterval)endingTime {
    if (self.index == [YALPreloaderViewModel globalViewModelsArray].count - 1) {
        return 2.3;
    }
    return 1.7;
}

- (void)setupPreloaderView {
    YALPreloaderView *preloaderView = [YALPreloaderView showPreloaderViewInView:self.view];
    [preloaderView configureWithViewModel:[YALPreloaderViewModel globalViewModelsArray][self.index]];
    preloaderView.progress = 0.f;
    self.preloaderView = preloaderView;
}

- (double)angle {
    CGFloat angles[6] = {0.f, 220.f, 12.f, 90.f, 12.f, 170.f};
    return angles[self.index];
}

- (void)performTaskWithProgress {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        usleep(25000);
        
        for (CGFloat i = 0.f; i < 1.f; i += .001f) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.preloaderView setProgress:i];
            });
            
            usleep(2050);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.preloaderView hide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self endingTime] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"forward" sender:nil];
            });
        });
    });
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"forward"] &&
        [destinationViewController isMemberOfClass:[YALViewController class]]) {
        YALViewController *destinationController = destinationViewController;
        destinationController.index = self.index + 1;
    }
}

@end
