import UIKit

public func ripple(center: CGPoint, view: UIView,
                   size: CGFloat = 75, multiplier: CGFloat = 4,
                   color: UIColor = UIColor.whiteColor()) {

  let ripple = Ripple(size: CGSize(width: size, height: size), multiplier: multiplier, color: color)
  ripple.activate(center, view: view)
}

class Ripple: NSObject {

  var size: CGSize
  var multiplier: CGFloat
  var color: UIColor
  var ripples: [UIView] = []

  init(size: CGSize, multiplier: CGFloat, color: UIColor) {
    self.size = size
    self.multiplier = multiplier
    self.color = color
  }

  func activate(center: CGPoint, view: UIView) {
    let ripple = UIView()

    view.addSubview(ripple)

    ripple.frame.origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    ripple.frame.size = size
    ripple.layer.borderColor = UIColor.whiteColor().CGColor
    ripple.layer.borderWidth = 3
    ripple.layer.cornerRadius = size.width / 2

    let animation = CABasicAnimation(keyPath: "cornerRadius")
    animation.fromValue = ripple.layer.cornerRadius
    animation.toValue = size.width * multiplier / 2

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.fromValue = NSValue(CGSize: ripple.layer.bounds.size)
    boundsAnimation.toValue = NSValue(CGSize: CGSize(width: size.width * multiplier, height: size.height * multiplier))

    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.values = [1, 1, 0]

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation, boundsAnimation, opacityAnimation]
    animationGroup.duration = 1.5
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.22, 0.54, 0.2, 0.47)

    ripples.append(ripple)
    ripple.layer.addAnimation(animationGroup, forKey: "ripple")
  }

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    guard let ripple = ripples.first else { return }

    ripple.removeFromSuperview()
    ripple.layer.removeAnimationForKey("ripple")
    
    ripples.removeFirst()
  }
}
