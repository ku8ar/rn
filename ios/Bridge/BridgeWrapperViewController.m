#import "BridgeWrapperViewController.h"
#import <React/RCTRootView.h>

@implementation BridgeWrapperViewController

NSString *const BridgeForceSwiftExport = @"Force Swift Symbol Export";

- (void)viewDidLoad {
  [super viewDidLoad];

  NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"rnbridge"
                                               initialProperties:nil
                                                   launchOptions:nil];
  rootView.frame = self.view.bounds;
  [self.view addSubview:rootView];
}

@end
