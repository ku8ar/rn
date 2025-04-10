#import "BridgeBundle.h"
#import "BridgeViewController.h"

@implementation BridgeBundle

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  NSBundle *bundle = [NSBundle mainBundle];
  return [bundle URLForResource:@"main" withExtension:@"jsbundle"];
}

@end
