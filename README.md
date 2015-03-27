# Ophiuchus

![Yalantis](https://raw.githubusercontent.com/Yalantis/Ophiuchus/master/Example/Ophiuchus/Resources/yalantistwodirections.gif)
![Preview](https://raw.githubusercontent.com/Yalantis/Ophiuchus/master/Example/Ophiuchus/Resources/animation.gif)
![The Green Horse](https://raw.githubusercontent.com/Yalantis/Ophiuchus/master/Example/Ophiuchus/Resources/thegreenhorse.gif)

Custom Label to apply animations on whole text or letters.

Made in [Yalantis](http://yalantis.com/).

Inspired by [this project on Dribble](https://dribbble.com/shots/1938357-Preloader-For-Yalantis?list=users&offset=3)

## Installation

####[CocoaPods](http://cocoapods.org)
```ruby
pod 'Ophiuchus', '~> 1.0.2'
```

####Manual Installation

Alternatively you can directly add all the source files from Ophiuchus to your project.

1. Download the [latest code version](https://github.com/Yalantis/Ophiuchus/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop all folders directories in Pods/Classes/ onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include YALLabel wherever you need it with `#import "YALLabel.h"`.

##Introduction

####YALProgressAnimatingLayer
`YALProgressAnimatingLayer` is a subclass of `CAShapeLayer` designed to control animations with progress. This feature is disabled until you invoke `[layer allowProgressToControlAnimations]`, after that `duration` and `timeOffset` properties of the layer will be passed to any animation added to the layer. Thus you gain control over animations added to the layer by passing values to `progress` property (varies from 0.f to 1.f). `YALProgressAnimatingLayer` mask is of same type as the layer.

####YALTextLayer
`YALTextLayer` is a subclass of `YALProgressAnimatingLayer` designed to display array of `UIBezierPath` instances as `YALProgressAnimatingLayer` sublayers. You can access and manipulate each letter sublayer. `YALTextLayer` constructs sublayers with mask of bounding box of shapes they have by default.

####YALLabel
`YALLabel` is a custom label consisting of three `YALTextLayer` instances to draw background fill, stroke and fill of text.

##Usage

Drop a `UIView` on a storyboard and set it's class to `YALLabel` and configure `fontName`, `fontSize`, `text`, `strokeWidth` and colors.

You can `#import "YALLabel.h"` in your view controller and create it from code :
```objective-c
self.yalLabel = [[YALLabel alloc] initWithFrame:frame];
self.yalLabel.text = @"AnyText";
self.yalLabel.fontName = @"FontName";
self.yalLabel.fontSize = 60.f;
self.yalLabel.fillColor = [UIColor redColor];
self.yalLabel.backgroundFillColor = [UIColor blackColor];
self.yalLabel.strokeColor = [UIColor blackColor];
self.yalLabel.strokeWidth = 1.2f;

```

After `self.yalLabel` is drawn you can add any animations to any sublayer you want.

Example: add fill animation to mask as in example but only to first letter:
Don't forget to import `YALPathFillAnimation.h`.
```objective-c
YALProgressAnimatingLayer *firstLetter = [self.yalLabel.fillLayer.sublayers firstObject];
CABasicAnimation *fillAnimation = [YALPathFillAnimation animationWithPath:fillLayer.mask.path andDirectionAngle:0];
fillAnimation.duration = 3.0;

[firstLetter.mask addAnimation:fillAnimation forKey:@"fillAnimation"];

```

You can also animate layer with progress:
```
YALProgressAnimatingLayer *secondLetter = self.yalLabel.fillLayer.sublayers[1];
CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];

colorAnimation.fromValue = (id)[UIColor redColor].CGColor;
colorAnimation.toValue = (id)[UIColor blueColor].CGColor;

[secondLetter allowProgressToControlAnimations];
[secondLetter addAnimation:colorAnimation forKey:@"colorAnimation"];

secondLetter.progress = 0.f;
```

And then when you need to update progress:
```
YALProgressAnimatingLayer *secondLetter = self.yalLabel.fillLayer.sublayers[1];
secondLetter.progress = value;
```

##License

    The MIT License (MIT)

    Copyright © 2015 Yalantis

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
