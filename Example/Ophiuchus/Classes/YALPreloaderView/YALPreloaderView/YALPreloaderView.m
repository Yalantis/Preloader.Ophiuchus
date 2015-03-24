// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALPreloaderView.h"
#import "YALPreloaderHeader.h"
#import "YALPreloaderCircleView.h"
#import <Ophiuchus/YALLabel.h>
#import "YALInterfaceManager.h"
#import "YAL3DRotatingView.h"
#import "YALPathFillAnimation.h"
#import "YALPreloaderViewModel.h"

typedef struct {
    NSTimeInterval startCircleResizeDuration;
    NSTimeInterval startContentFadeDuration;
    NSTimeInterval hideContentFadeDuration;
} YALPreloaderViewDurations;

static YALPreloaderViewDurations const kYALPreloaderViewDurations = (YALPreloaderViewDurations) {
    .startCircleResizeDuration = .2,
    .startContentFadeDuration = .1,
    .hideContentFadeDuration = .3
};

@interface YALPreloaderView ()<YAL3DRotatingViewDelegate>

@property (nonatomic, strong) YALPreloaderCircleView *circleView;
@property (nonatomic, strong) YAL3DRotatingView *rotatingView;
@property (nonatomic, strong) YALLabel *letterView;

@end

@implementation YALPreloaderView

#pragma mark - Class methods

+ (instancetype)showPreloaderViewInView:(UIView *)view {
    YALPreloaderView *preloader = [[self alloc] initWithFrame:view.bounds];
    [preloader showPreloaderViewInView:view];
    return preloader;
}

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init

- (void)commonInit {
    self.sizeRatio = .75;
    self.fillColor = [YALInterfaceManager yal_black];
    self.strokeColor = [YALInterfaceManager yal_black];
    self.circleBackgroundColor = [YALInterfaceManager yal_orange];
    self.rotatingView.hidden = YES;
    
    [self setupCircleView];
    [self setupLetterView];
    [self setupRotatingView];
}

#pragma mark - Setup

- (void)setupCircleView {
    self.circleView = ({
        CGRect rect = [self initialCircleRect];
        YALPreloaderCircleView *circleView = [[YALPreloaderCircleView alloc] initWithFrame:rect];
        circleView.alpha = kYALAlpha.max;
        circleView.layerFillColor = self.circleBackgroundColor;
        [self addSubview:circleView];
        circleView;
    });
}

- (void)setupLetterView {
    self.letterView = ({
        CGRect rect = [self destinationCircleRect];
        YALLabel *letterView =  [[YALLabel alloc] initWithFrame:rect];
        letterView.alpha = kYALAlpha.min;
        letterView.fillColor = self.fillColor;
        letterView.strokeColor = self.strokeColor;
        letterView.backgroundFillColor = self.backgroundFillColor;
        [self addSubview:letterView];
        letterView;
    });
}

- (void)setupRotatingView {
    self.rotatingView = ({
        CGRect rect = [self destinationCircleRect];
        YAL3DRotatingView *rotatingView = [[YAL3DRotatingView alloc] initWithFrame:rect];
        rotatingView.alpha = self.showsDots ? kYALAlpha.max : kYALAlpha.min;
        [self addSubview:rotatingView];
        rotatingView.delegate = self;
        rotatingView.fillColor = self.strokeColor;
        rotatingView.hidden = YES;
        rotatingView;
    });
}

#pragma mark - Mutators

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.letterView.fillLayer.mask.progress = progress;
}

- (void)setShowsDots:(BOOL)showsDots {
    if (_showsDots != showsDots) {
        _showsDots = showsDots;
        self.rotatingView.alpha = self.showsDots ? kYALAlpha.max : kYALAlpha.min;
    }
}

#pragma mark - Public

- (void)configureWithViewModel:(YALPreloaderViewModel *)viewModel {
    self.fillColor = viewModel.fillColor;
    self.strokeColor = viewModel.strokeColor;
    self.backgroundColor = viewModel.viewBackgroundColor;
    self.showsDots = viewModel.isShowingDots;
    self.letterView.contentMode = viewModel.contentMode;
    self.letterView.text = viewModel.text;
    self.letterView.fontName = viewModel.fontName;
    self.letterView.fontSize = viewModel.fontSize;
}

- (void)showPreloaderViewInView:(UIView *)view {
    [view addSubview:self];
    [self animateInitialSizeChange];
}

- (void)hide {
    [self.rotatingView stopAnimating];
}

#pragma mark - YAL3DRotatingViewDelegate

- (void)rotatingViewDidStopAnimating:(YAL3DRotatingView *)rotatingView {
    [self animateContentHiding];
}

#pragma mark - Private (animations)

- (void)animateInitialSizeChange {
    [self.circleView animateToRect:[self destinationCircleRect]
                        completion:^{
                            [self.rotatingView startAnimating];
                            self.rotatingView.hidden = NO;
                            [self animateContent:nil];
                        }];
}

- (void)animateContent:(void(^)(void))completion; {
    [self animateLetterViewOnStart];
    [UIView animateWithDuration:kYALPreloaderViewDurations.startContentFadeDuration
                     animations:^{
                         self.letterView.alpha = kYALAlpha.max;
                     } completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)animateContentHiding {
    [UIView animateWithDuration:kYALPreloaderViewDurations.hideContentFadeDuration
                     animations:^{
                         self.letterView.alpha = kYALAlpha.min;
                     } completion:^(BOOL finished) {
                         [self.circleView animateToRect:[self initialCircleRect]
                                             completion:nil];
                     }];
}

#pragma mark - Private (rects and sizes)

- (void)animateLetterViewOnStart {
    self.letterView.fillLayer.mask.progress = 0.f;
    static NSTimeInterval const kYALStartAnimationDuration = .0;
    static NSString * const kYALStartAnimationKey = @"zoom";
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:[self startScale]];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setDuration:kYALStartAnimationDuration];
    animation.fillMode = kCAFillModeForwards;    
    animation.removedOnCompletion = NO;
    [self.letterView.layer addAnimation:animation forKey:kYALStartAnimationKey];
}

- (CATransform3D)startScale {
    return CATransform3DMakeScale(0.1, 0.1, 1.0);
}

- (CGRect)initialCircleRect {
    CGRect preloaderBounds = self.bounds;
    CGFloat preloaderWidth = CGRectGetWidth(preloaderBounds);
    CGFloat preloaderHeight = CGRectGetHeight(preloaderBounds);
    CGFloat startCircleSide = MAX(preloaderWidth, preloaderHeight) * kYALMathConstants.two;
    CGFloat startX = (preloaderWidth - startCircleSide) * kYALMathConstants.half;
    CGFloat startY = (preloaderHeight - startCircleSide) * kYALMathConstants.half;
    return CGRectMake(startX, startY, startCircleSide, startCircleSide);
}

- (CGRect)destinationCircleRect {
    CGRect preloaderBounds = self.bounds;
    CGFloat preloaderWidth = CGRectGetWidth(preloaderBounds);
    CGFloat preloaderHeight = CGRectGetHeight(preloaderBounds);
    CGFloat destinationSize = MIN(preloaderWidth, preloaderHeight) * self.sizeRatio;
    CGFloat destinationX = (preloaderWidth - destinationSize) * kYALMathConstants.half;
    CGFloat destinationY = (preloaderHeight - destinationSize) * kYALMathConstants.half;
    return CGRectMake(destinationX, destinationY, destinationSize, destinationSize);
}

@end
