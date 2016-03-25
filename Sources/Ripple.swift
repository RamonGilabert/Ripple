import UIKit

public func ripple(center: CGPoint, view: UIView) {

  let ripple = Ripple()
  ripple.activate(center, view: view)
}

class Ripple: NSObject {

  let size = CGSizeMake(50, 50)
  let multiplier: CGFloat = 3

  var ripples: [UIView] = []

  func activate(center: CGPoint, view: UIView) {
    let ripple = UIView()

    view.addSubview(ripple)

    ripple.frame.origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    ripple.frame.size = size
    ripple.layer.borderColor = UIColor.whiteColor().CGColor
    ripple.layer.borderWidth = 2
    ripple.layer.cornerRadius = size.width / 2

    let animation = CABasicAnimation(keyPath: "cornerRadius")
    animation.fromValue = ripple.layer.cornerRadius
    animation.toValue = size.width * multiplier / 2
    animation.delegate = self

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.fromValue = NSValue(CGSize: ripple.layer.bounds.size)
    boundsAnimation.toValue = NSValue(CGSize: CGSize(width: size.width * multiplier, height: size.height * multiplier))

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation, boundsAnimation]
    animationGroup.duration = 0.6
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.22, 0.54, 0.15, 0.47)

    ripples.append(ripple)
    ripple.layer.addAnimation(animationGroup, forKey: "ripple")
  }

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    guard let ripple = ripples.first else { return }

    ripple.layer.cornerRadius = size.width * multiplier / 2
    ripple.bounds.size = CGSize(width: size.width * multiplier, height: size.height * multiplier)

    UIView.animateWithDuration(0.15, animations: {
      ripple.alpha = 0
      }, completion: { _ in
        ripple.layer.removeAnimationForKey("ripple")
        ripple.removeFromSuperview()

        self.ripples.removeFirst()
    })
  }
}
