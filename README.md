CGFlowController v3.0.0
=======================

Version 3.0.0 of CGFlowController. Redesigned from the ground up to incorporate iOS 7's new UIAnimationDelegate set up, UIViewControllerInteractiveTransition and incorporates custom storyboard segues. This library is designed as an easy drag and drop library to be used in any current storyboard project with very little set up necessary. Demo code is provided to show how to incorporate it into any project.

I started by creating a custom container which is CGFlowController itself so that I could swap out the root view. To use the new interactive transitioning delegate I needed to force a presentation of the controller. So I use presentViewController:animated:completion: the problem is I can't capture the viewAppearence call backs even though my controller is in theory the root controller. The modal view seems to mess with this paradigm no matter I believe I am presenting the controller. I then dismiss it quickly after grabbing the reference to the instantiated controller and manually add it to my flow controller at the end of the visual transition, so it seemlessly ends on the new controller. One issue when transforming a view is that the gestures can no longer detect the translation within that view. So to overcome that issue I detect the translation within the superview that isn't being transformed. Also after a transform due to the root controller being moved with its subview I need to reset the bounds and the frame. The bounds height would continually be set to 0. This doesn't seem to have any memory leaks at this point the last one was due to returning whether the context transitioning was cancelled or not, as long as I passed YES to the didContextT


Current Version
===============
This version supports all devices on iOS 7 for iOS 5/6 support check out the old CGFlowController v2.0.0. This version only currently supports pan gesture and pinch gestures, but I will be adding more gestures. This version has interactive slide and flip animations, but more are coming. Also added modal support for iPhone. Support for segues is limited to slide transitions only right now.


ToDo
====
- Add better gesture support
- Add more animations
- Multiple orientation support
- Update segues as animations are finished
- Navigation Panel?


Initial Work
============
Broken into three categories. Animations, Interactions with animations, and segues with custom animations.
Taking it one step further ideally separate a push/pop animation from a segue that fully transitions to the
root controller. Plug and play interaction and animations for UINavigationController and UITabBarController.


Considerations:
===============
As always have fun use at your own risk and don't blame me if things don't work. This is just a side project for learning.
If you actually need help with anything feel free to contact me and I'll gladly try to help. I am sublicensing this under
an MIT license, so go out use it and have fun.