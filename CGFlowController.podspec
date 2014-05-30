Pod::Spec.new do |s|
  s.name             = "CGFlowController"
  s.version          = "4.0.0"
  s.summary          = "Version 4.0.0 of CGFlowController. Redesigned from the ground up to incorporate iOS 7's new UIAnimationDelegate."
  s.description      = <<-DESC
                       Version 4.0.0 of CGFlowController. Redesigned from the ground up to incorporate iOS 7's new UIAnimationDelegate set up, UIViewControllerInteractiveTransition and incorporates custom storyboard segues. This library is designed as an easy drag and drop library to be used in any current storyboard project with very little set up necessary. Demo code is provided to show how to incorporate it into any project.

I started by creating a custom container which is CGFlowController itself so that I could swap out the root view. To use the new interactive transitioning delegate I needed to force a presentation of the controller. So using my own percent driven interaction controller that ties into CADisplayLink I can control animations by tieing into the CALayer. The interactive delegate handles the actual animation. Using custom added gesture controllers and an objective-c category I am able to make a very versatile, near drag and drop solution. That helps with easier custom modal view appearences that, without damaging any view appearences or without the need of any custom view appearence call backs.
                       DESC
  s.license          = 'MIT'
  s.homepage         = 'http://www.revision-works.com/'
  s.author           = { "Chase Gorectke" => "nbvikingsidiot001@gmail.com" }
  s.source           = { :git => "https://github.com/CGDevHusky92/CGFlowController.git", :tag => "4.0.0" }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/'
  s.ios.exclude_files = 'Classes/pubheaders'
  s.osx.exclude_files = 'Classes/pubheaders'
  s.public_header_files = 'Classes/pubheaders/*.h'
  s.frameworks = 'QuartzCore', 'Foundation'
end
