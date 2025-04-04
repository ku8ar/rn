import UIKit

@objc public class RNBridgeViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let vc = BridgeWrapperViewController()
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}
