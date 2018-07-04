import UIKit

/**
 Ripple makes a ripple effect like when you drop a droplet in the water.

 - Parameter center: The center point where the ripple should start.
 - Parameter view: The view the ripple should be applied to.
 - Parameter times: (Optional) The number of times the ripple should repeat, Infinity by default.
 - Parameter duration: (Optional) The duration of each ripple effect, 2 by default.
 - Parameter size: (Optional) The initial size of the ripple, 50 by default.
 - Parameter multiplier: (Optional) The multiplier that should apply to know the end size, 4 by default.
 - Parameter divider: (Optional) The divider for the timer to apply the next ripple, 2 by default.
 - Parameter color: (Optional) The color of the ripple, white by default.
 - Parameter border: (Optional) The border width of the ripple, 2.25 by default.
 */
public func ripple(_ center: CGPoint, view: UIView, times: Float = Float.infinity,
                   duration: TimeInterval = 2,
                   size: CGFloat = 50,
                   multiplier: CGFloat = 4,
                   divider: CGFloat = 2,
                   color: UIColor = UIColor.white,
                   border: CGFloat = 2.25) {

  let ripple = droplet(center, view: view, duration: duration,
                       size: size, multiplier: multiplier, color: color, border: border)
  let timer = Timer.scheduledTimer(timeInterval: duration / Double(divider),
                                                     target: ripple,
                                                     selector: #selector(Ripple.timerDidFire),
                                                     userInfo: nil, repeats: true)

  timers.append(timer)

  guard times != Float.infinity && times > 0 else { return }

  let denominator = Double(times - 1) * Double(duration) / Double(divider) * Double(NSEC_PER_SEC)
  let deadline = DispatchTime.now() + denominator
  DispatchQueue.main.asyncAfter(deadline: deadline) {
    timer.invalidate()
  }
}

/**
 Droplet makes a just once ripple effect like when you drop a droplet in the water.

 - Parameter center: The center point where the ripple should start.
 - Parameter view: The view the ripple should be applied to.
 - Parameter duration: (Optional) The duration of each ripple effect, 2 by default.
 - Parameter size: (Optional) The initial size of the ripple, 50 by default.
 - Parameter multiplier: (Optional) The multiplier that should apply to know the end size, 4 by default.
 - Parameter color: (Optional) The color of the ripple, white by default.
 - Parameter border: (Optional) The border width of the ripple, 2.25 by default.

 - Returns: A ripple object, you can't do much with it though, it's just for internal use.
 */
public func droplet(_ center: CGPoint, view: UIView,
                    duration: TimeInterval = 2,
                    size: CGFloat = 50, multiplier: CGFloat = 4,
                    color: UIColor = UIColor.white, border: CGFloat = 2.25) -> Ripple {

  let ripple = Ripple(center: center, view: view,
                      duration: duration,
                      size: CGSize(width: size, height: size),
                      multiplier: multiplier,
                      color: color,
                      border: border)

  ripple.activate()

  return ripple
}

/**
 Calm stops all your current timers.
 */
public func calm() {
  timers.forEach { $0.invalidate() }
  timers.removeAll()
}

var timers: [Timer] = []

/**
 The ripple creator
 */
open class Ripple: NSObject {

  var center: CGPoint
  var view: UIView
  var duration: TimeInterval
  var size: CGSize
  var multiplier: CGFloat
  var color: UIColor
  var border: CGFloat
  var ripples: [UIView] = []

  init(center: CGPoint, view: UIView,
       duration: TimeInterval, size: CGSize,
       multiplier: CGFloat, color: UIColor, border: CGFloat) {

    self.center = center
    self.view = view
    self.duration = duration
    self.size = size
    self.multiplier = multiplier
    self.color = color
    self.border = border
  }

  func activate() {
    let ripple = UIView()

    if let subview = view.subviews.first {
      view.insertSubview(ripple, aboveSubview: subview)
    } else {
      view.insertSubview(ripple, at: 0)
    }

    ripple.frame.origin = CGPoint(x: center.x - size.width / 2,
                                  y: center.y - size.height / 2)
    ripple.frame.size = size
    ripple.layer.borderColor = color.cgColor
    ripple.layer.borderWidth = border
    ripple.layer.cornerRadius = ripple.bounds.width / 2

    let animation = CABasicAnimation(keyPath: "cornerRadius")
    animation.fromValue = ripple.layer.cornerRadius
    animation.toValue = size.width * multiplier / 2

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.fromValue = NSValue(cgSize: ripple.layer.bounds.size)
    boundsAnimation.toValue = NSValue(cgSize: CGSize(width: size.width * multiplier, height: size.height * multiplier))

    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.values = [0, 1, 1, 1, 0]

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation, boundsAnimation, opacityAnimation]
    animationGroup.duration = duration
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.22, 0.54, 0.2, 0.47)
    animationGroup.isRemovedOnCompletion = false
    animationGroup.fillMode = kCAFillModeForwards

    ripples.append(ripple)
    ripple.layer.add(animationGroup, forKey: "ripple")
  }
  
  @objc func timerDidFire() {
    activate()
  }
}

extension Ripple: CAAnimationDelegate {

  /**
   The animation delegate method that helps to do better ripples.
   */
  open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard let ripple = ripples.first else { return }

    ripple.alpha = 0
    ripple.removeFromSuperview()
    ripple.layer.removeAnimation(forKey: "ripple")

    ripples.removeFirst()
  }
}
