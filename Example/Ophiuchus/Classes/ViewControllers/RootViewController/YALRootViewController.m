// For License please refer to LICENSE file in the root of Ophiuchus project

#import "YALRootViewController.h"
#import "YALInterfaceManager.h"

@implementation YALRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [YALInterfaceManager yal_orange];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSegueWithIdentifier:@"forward" sender:nil];
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)sender {
    return;
}

@end
