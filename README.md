![Ripple](https://github.com/RamonGilabert/Ripple/blob/master/Resources/cover.png)

<div align = "center">
<a href="https://github.com/Carthage/Carthage" target="blank"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" /></a>
<a href="http://cocoadocs.org/docsets/Ripple" target="blank"><img src="https://img.shields.io/cocoapods/v/Ripple.svg?style=flat" /></a>
<a href="http://cocoadocs.org/docsets/Ripple" target="blank"><img src="https://img.shields.io/cocoapods/l/Ripple.svg?style=flat" /></a>
<a href="http://cocoadocs.org/docsets/Ripple" target="blank"><img src="https://img.shields.io/cocoapods/p/Ripple.svg?style=flat" /></a>
<a href="http://cocoadocs.org/docsets/Ripple" target="blank"><img src="https://img.shields.io/cocoapods/metrics/doc-percent/Ripple.svg?style=flat" /></a>
<img src="https://img.shields.io/badge/%20in-swift%203.0-orange.svg" />
<br><br>
</div>

Ripple is a small convenience to create ripples in your app. With just a line of code, you can do beautiful things.

## Code

There are two types of ripples, the one times ones, or the repeated ones:

![Ripple](https://github.com/RamonGilabert/Ripple/blob/master/Resources/example.png)

#### Droplets

By just setting the center and the view the droplet should be added to, you are going to have a droplet effect.

```swift
droplet(center: CGPoint, view: UIView)
```

#### Ripples

There are many ways to customize the ripple effect, the simplest one of all is just calling the following lines, which will repeat infinite times.

```swift
ripple(center: CGPoint, view: UIView)
```

There is, in both cases some configuration you can find, read the documentation for more information. :) Here's the gif of the demo for you to have an idea of what Ripple is:

![Ripple](https://github.com/RamonGilabert/Ripple/blob/master/Resources/demo.gif)

## Installation

**Ripple** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Ripple'
```

**Ripple** is also available through [Carthage](https://github.com/Carthage/Carthage). To install just write into your Cartfile:

```ruby
github 'RamonGilabert/Ripple'
```

## Author

Ramon Gilabert with ♥️

## Contribute

I would love you to contribute to **Ripple**, check the [CONTRIBUTING](https://github.com/RamonGilabert/Ripple/blob/master/CONTRIBUTING.md) file for more information.

## License

**Ripple** is available under the MIT license. See the [LICENSE](https://github.com/RamonGilabert/Ripple/blob/master/LICENSE.md) file for more info.
