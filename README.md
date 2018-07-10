<img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/Banner.png">

# InputBarAccessoryView

[![CocoaPods](https://img.shields.io/cocoapods/dt/InputBarAccessoryView.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/dw/InputBarAccessoryView.svg)]()
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/nathantannar)

### Features

- [x] A growing `UITextView` with optional fixed height
- [x] Image paste support   
- [x] RxSwift inspired reactive components that respond to given events
- [x] Top/Bottom/Left/Right `UIStackView`s that act as toolbars to place buttons
- [x] Drop in autocomplete for any given prefix
- [x] Autocomplete attributed text highlighting
- [x] Drop in attachment view for file/photo management
- [x] Drop in Slack style `TypingIndicator`
- [x] Plugin support for your own `InputPlugin`s
- [x] iPhone X Support
- [x] RTL Support

### Installation via CocoaPods

```ruby
pod 'InputBarAccessoryView'
```

### Installation via Carthage

```ruby
github "nathantannar4/InputBarAccessoryView"
```

### Requirements

iOS 9.0+
Swift 4
XCode 9.0+

### Documentation

[Getting Started](./GETTING_STARTED.md)

[Jazzy Generated Docs](https://nathantannar.me/InputBarAccessoryView/docs/)

> See the Example project to see how you can make the iMessage, Slack, Facebook and GitHawk input bars!

### Demo

<img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/Demo.gif" width="275" height="600">

### Screenshots

<img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotA.png" width="242" height="432"> <img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotB.png" width="242" height="432"> <img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotC.png" width="242" height="432"> <img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotD.png" width="242" height="432"> <img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotE.png" width="242" height="432"> <img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/ScreenshotF.png" width="242" height="432">

### Featured In

Add your app to the list of apps using this library and make a pull request.

- [MessageKit](https://github.com/MessageKit/MessageKit) *(renamed to MessageInputBar)*
<p>
  <img src="https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/mklogo.png" title="MessageKit Logo" height="50">
</p>

- [MessageViewController](https://github.com/GitHawkApp/MessageViewController) *(Autocomplete Highlighting Algorithm)*
<p>
  <img src="https://avatars3.githubusercontent.com/u/32285710?s=200&v=4" title="GitHawk Logo" height="50">
</p>

## Layout

The layout of the `InputBarAccessoryView` is made of of 4  `InputStackView`'s and an `InputTextView`. The padding of the subviews can be easily adjusted by changing the `padding` and `textViewPadding` properties. The constraints will automatically be updated.

<img src="https://raw.githubusercontent.com/nathantannar4/InputBarAccessoryView/master/Screenshots/Layout.png">

It is important to note that each of the `InputStackView `'s to the left and right of the `InputTextView` are anchored by a width constraint. This way the `InputTextView` will always fill the space inbetween in addition to providing methods that can easily be called to hide all buttons to the right or left of the `InputTextView` by setting the width constraint constant to 0. The bottom and top stack views are not height constraint and rely on their `intrinsicContentSize`

```swift
func setLeftStackViewWidthConstant(to newValue: CGFloat, animated: Bool)

func setRightStackViewWidthConstant(to newValue: CGFloat, animated: Bool)
```

### Reactive Hooks

Each `InputBarButtonItem` has properties that can hold actions that will be executed during various hooks such as the button being touched, the `UITextView `text changing and more! Thanks to these easy hooks with a few lines of code the items can be easily resized and animated similar to that of the Facebook messenger app.

```swift
// MARK: - Hooks
    
public typealias InputBarButtonItemAction = ((InputBarButtonItem) -> Void)    
    
private var onTouchUpInsideAction: InputBarButtonItemAction?
private var onKeyboardEditingBeginsAction: InputBarButtonItemAction?
private var onKeyboardEditingEndsAction: InputBarButtonItemAction?
private var onKeyboardSwipeGestureAction: ((InputBarButtonItem, UISwipeGestureRecognizer) -> Void)?
private var onTextViewDidChangeAction: ((InputBarButtonItem, InputTextView) -> Void)?
private var onSelectedAction: InputBarButtonItemAction?
private var onDeselectedAction: InputBarButtonItemAction?
private var onEnabledAction: InputBarButtonItemAction?
private var onDisabledAction: InputBarButtonItemAction?
```

## Changelog
- 2.3.0
        - Removed experimental `TypingIndicator` see more refined version [here](https://github.com/nathantannar4/TypingIndicator)
        - Added a `KeyboardManager` to support adding an `InputBarAccessoryView` as a subview of a `UIViewController`. This better supports view controller containers such as the `UISplitViewController`
- 2.2.1
        - RTL Support (Made `AutocompleteManager.paragraphStyle` `open`)
- 2.2.0
        - Make `AutocompleteSession` a class so that its completion can be updated
- 2.1.0
        - `AutocompleteManager` table view datasource methods are now marked as `open`
        - `AutocompleteManager` changed to manage `UITextView`s rather than only `InputTextView`s
        - `AutocompleteSession` bug fixes
        - Example updated for asynchronous completion lookups with `AutocompleteManager`  
- 2.0.0
        - API Stability
        - Bug Fixes
        - `InputManager` renamed to `InputPlugin`
        - Added `shouldManageSendButtonEnabledState` to `InputBarAccessoryView`
- 1.5.4
        - Bug Fixes
- 1.5.3
        - [WIP] `TypingIndicator` InputItem view added, see example
        - `shouldForceTextViewMaxHeight` property added
- 1.5.2
        - Better autocomplete detection
- 1.5.1
        - Optimize AutocompleteManager & AttachmentManager
- 1.5.0
        - Stability and bug fixes
- 1.4.0
        - iPhone X Fixes
        - IntrinsicContentSize caching to increase performance
        - Auto Manage maxTextViewHeight
- 1.3.0
        - iPhone X Fixes
- 1.2.0
        - Better XCode docs
        - `InputItem` is now a protocol that you can give to the `InputBarAccessoryView`
        - `InputPlugin` is now a protocol that you can conform to make a plugin
        - `AutocompleteManager` and `AttactchmentManager` are no longer members of  `InputBarAccessoryView` by default. You will need to create them and assign them to the `InputPlugin` property of the `InputBarAccessoryView`
- 1.1.2
        - Fixed issue where adjusting the `InputTextView`'s placeholder text alignment didn't work
        - Fixed iPhone X support where the home indicator overlapped the `InputTextView`
- 1.1.1
        - AutocompleteManager bug fixes and customization improvements
- 1.1.0
        - AttactchmentManager (Beta)
- 1.0.0
	- A more refined AutocompleteManager
	- Auto-layout bug fixes

*pre-release versions not documented*

**Find a bug? Open an issue!**

## Author
<p>
	<img src="https://github.com/nathantannar4/NTComponents/raw/master/NTComponents/Assets/Nathan.png" width="100" height="100">
</p>

**Nathan Tannar** - [https://nathantannar.me](https://nathantannar.me)

## License

Distributed under the MIT license. See ``LICENSE`` for more information.
