import UIKit

public func ripple(center: CGPoint, view: UIView, times: Float = Float.infinity,
                   duration: NSTimeInterval = 2,
                   size: CGFloat = 50,
                   multiplier: CGFloat = 4,
                   divider: CGFloat = 2,
                   color: UIColor = UIColor.whiteColor()) {

  let ripple = droplet(center, view: view, duration: duration,
                       size: size, multiplier: multiplier, color: color)
  let timer = NSTimer.scheduledTimerWithTimeInterval(duration / 2,
                                                     target: ripple,
                                                     selector: #selector(Ripple.timerDidFire),
                                                     userInfo: nil, repeats: true)

  guard times != Float.infinity else { return }

  dispatch_after(
  dispatch_time(DISPATCH_TIME_NOW, Int64(Double(times) * Double(duration) / 2 * Double(NSEC_PER_SEC))),
  dispatch_get_main_queue()) {
    timer.invalidate()
  }
}

public func droplet(center: CGPoint, view: UIView, duration: NSTimeInterval = 1.5,
                   size: CGFloat = 50, multiplier: CGFloat = 4,
                   color: UIColor = UIColor.whiteColor()) -> Ripple {

  let ripple = Ripple(center: center, view: view,
                      duration: duration,
                      size: CGSize(width: size, height: size),
                      multiplier: multiplier,
                      color: color)

  ripple.activate()

  return ripple
}

public class Ripple: NSObject {

  var center: CGPoint
  var view: UIView
  var duration: NSTimeInterval
  var size: CGSize
  var multiplier: CGFloat
  var color: UIColor
  var ripples: [UIView] = []

  init(center: CGPoint, view: UIView,
       duration: NSTimeInterval, size: CGSize,
       multiplier: CGFloat, color: UIColor) {

    self.center = center
    self.view = view
    self.duration = duration
    self.size = size
    self.multiplier = multiplier
    self.color = color
  }

  func activate() {
    let ripple = UIView()

    view.addSubview(ripple)

    ripple.frame.origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    ripple.frame.size = size
    ripple.layer.borderColor = color.CGColor
    ripple.layer.borderWidth = 2.5
    ripple.layer.cornerRadius = size.width / 2

    let animation = CABasicAnimation(keyPath: "cornerRadius")
    animation.fromValue = ripple.layer.cornerRadius
    animation.toValue = size.width * multiplier / 2

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.fromValue = NSValue(CGSize: ripple.layer.bounds.size)
    boundsAnimation.toValue = NSValue(CGSize: CGSize(width: size.width * multiplier, height: size.height * multiplier))

    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.values = [1, 1, 1, 0]

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation, boundsAnimation, opacityAnimation]
    animationGroup.duration = duration
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.22, 0.54, 0.2, 0.47)
    animationGroup.removedOnCompletion = false
    animationGroup.fillMode = kCAFillModeForwards

    ripples.append(ripple)
    ripple.layer.addAnimation(animationGroup, forKey: "ripple")
  }

  override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    guard let ripple = ripples.first else { return }

    ripple.alpha = 0
    ripple.removeFromSuperview()
    ripple.layer.removeAnimationForKey("ripple")
    
    ripples.removeFirst()
  }

  func timerDidFire() {
    activate()
  }
}
