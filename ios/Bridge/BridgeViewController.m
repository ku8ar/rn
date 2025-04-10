#import "BridgeViewController.h"
#import "BridgeBundle.h"

#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

@implementation BridgeViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  BridgeBundle *delegate = [BridgeBundle new];
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:delegate launchOptions:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"rnbridge"
                                            initialProperties:nil];
  rootView.frame = self.view.bounds;
  rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:rootView];
}

@end
