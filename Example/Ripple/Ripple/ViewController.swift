import UIKit
import Ripple

class ViewController: UIViewController {

  lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGesture))

    return gesture
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(red:0.12, green:0.57, blue:0.96, alpha:1.00)
    view.addGestureRecognizer(tapGesture)
  }

  // MARK: - Action methods

  func handleTapGesture() {
    ripple(tapGesture.locationInView(view), view: view)
  }

  // MARK: - Helper methods

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
