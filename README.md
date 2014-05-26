CGFlowController v4.0.0
=======================

Version 4.0.0 of CGFlowController. Redesigned from the ground up to incorporate iOS 7's new UIAnimationDelegate set up, UIViewControllerInteractiveTransition and incorporates custom storyboard segues. This library is designed as an easy drag and drop library to be used in any current storyboard project with very little set up necessary. Demo code is provided to show how to incorporate it into any project.

I started by creating a custom container which is CGFlowController itself so that I could swap out the root view. To use the new interactive transitioning delegate I needed to force a presentation of the controller. So using my own percent driven interaction controller that ties into CADisplayLink I can control animations by tieing into the CALayer. The interactive delegate handles the actual animation. Using custom added gesture controllers and an objective-c category I am able to make a very versatile, near drag and drop solution. That helps with easier custom modal view appearences that, without damaging any view appearences or without the need of any custom view appearence call backs.


Current Version
===============
This version supports all devices on iOS 7 for iOS 5/6 support check out the old CGFlowController v2.0.0. This version only currently supports pan gesture and pinch gestures, but I will be adding more gestures. This version has interactive slide and flip animations, and panel animations, with more coming soon. Also added modal support for iPhone.

ToDo
====
- Tutorial/Better Documentation
- Add better gesture support
- Add more animations
- Multiple orientation support


Considerations:
===============
As always have fun use at your own risk and don't blame me if things don't work. This is just a side project for learning.
If you actually need help with anything feel free to contact me and I'll gladly try to help. I am sublicensing this under
an MIT license, so go out use it and have fun.