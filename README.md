CGFlowAnimation v0.7.9b
=======================

Version 3.0.0 of CGFlowController. Redesigned from the ground up to incorporate iOS 7's new UIAnimationDelegate set up, UIViewControllerInteractiveTransition and incorporates custom storyboard segues. This library is designed as an easy drag and drop library to be used in any current storyboard project with very little set up necessary. Demo code is provided to show how to incorporate it into any project.


Current Version
===============
This version supports all devices on iOS 7. Has multiple orientation support.
This version only currently supports pan gesture, but will add as many gestures when all the bugs are worked out of pan.
This version has interactive slide and flip animations, but more are coming.
Support for segues is limited to slide transitions only right now.


ToDo
====
Add better gesture support, 
Add more animations, 
Update segues as animations are finished, 
Clear frame transitions?, 
Navigation Panel?


Initial Work
============
Broken into three categories. Animations, Interactions with animations, and segues with custom animations.
Taking it one step further ideally separate a push/pop animation from a segue that fully transitions to the
root controller.


Naming Conventions
==================
CGFlowAnimation
that are used by CGFlowSegue and CGFlowAnimationSlideLeft... etc.
Interactions are defined by kCGFlowInteractionType and Animations are defined by kCGFlowAnimationType.


Considerations:
===============
As always have fun use at your own risk and don't blame me if things don't work. This is just a side project for learning.
If you actually need help with anything feel free to contact me and I'll gladly try to help. I am sublicensing this under
an MIT license, so go out use it and have fun.