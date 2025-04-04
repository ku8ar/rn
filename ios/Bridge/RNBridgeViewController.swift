import UIKit
import React

public class RNBridgeViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

      guard let jsCodeLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackExtension: nil) else {
            print("Cannot load RN JS bundle.")
            return
        }

        let rootView = RCTRootView(
            bundleURL: jsCodeLocation,
            moduleName: "rnbridge", // << -- here
            initialProperties: nil,
            launchOptions: nil
        )
      rootView.frame = view.bounds
      rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.addSubview(rootView)
    }
}
