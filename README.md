# InputBarAccessoryView

### Requirements
iOS 9.0 and Higher

## Examples

Explore the Example project!

<img src="./Screenshots/Slack Keyboard.png" width="242" height="432">  <img src="./Screenshots/Simple Keyboard.png" width="242" height="432">

## Layout

The layout of the `InputBarAccessoryView` is made of of 3 `UIStackView`'s and an `InputTextView` (subclass of `UITextView`). The padding of the subviews can be easily adjusted by changing the `padding` and `textViewPadding` properties. The constraints will automatically be updated.

```swift
H:|-(padding.left)-[UIStackView(leftStackViewWidthContant)]-(textViewPadding.left)-[InputTextView]-(textViewPadding.right)-[UIStackView(rightStackViewWidthContant)]-(padding.right)-|

V:|-(padding.top)-[InputTextView]-(textViewPadding.bottom)-[UIStackView]-(padding.bottom)-|
```

It is important to note that each of the `UIStackView`'s to the left and right of the `InputTextView` are anchored by a width constraint. This way the `InputTextView` will always fill the space inbetween in addition to providing methods that can easily be called to hide all buttons to the right or left of the `InputTextView` by setting the width constraint constant to 0.

```swift
func setLeftStackViewWidthContant(to newValue: CGFloat, animated: Bool)
func setRightStackViewWidthContant(to newValue: CGFloat, animated: Bool)
```

## InputBarButtonItem

It is recommended that you use the `InputBarButtonItem` for the `UIStackView`'s. This is because all `UIStackView`'s are intitially set with the following properties:

```swift
let view = UIStackView()
view.axis = .horizontal
view.distribution = .fill
view.alignment = .fill
view.spacing = 15
```

This will layout the arrangedViews based on their intrinsicContentSize and if there is extra space the views will be expanded based on their content hugging `UILayoutPriority`.

### Size

Each `InputBarButtonItem`'s `intrinsicContentSize` can be overridden by setting the `size` property. It is optional so when set to `nil` the `super.intrinsicContentSize` will be used. 

### Spacing

Spacing can be set using the `spacing` property. This will change the content hugging `UILayoutPriority` and add extra space to the `intrinsicContentSize` when set to `.fixed(CGFloat)`.


### Hooks

Each `InputBarButtonItem` has properties that can hold actions that will be executed during various hooks such as the button being touched, the `UITextView `text changing and more! Thanks to these easy hooks with a few lines of code the items can be easily resized and animated similar to that of the Facebook messenger app.

```swift
// MARK: - Hooks
    
private var onTouchUpInsideAction: ((InputBarButtonItem)->Void)?
private var onKeyboardEditingBeginsAction: ((InputBarButtonItem)->Void)?
private var onKeyboardEditingEndsAction: ((InputBarButtonItem)->Void)?
private var onKeyboardSwipeGestureAction: ((InputBarButtonItem, UISwipeGestureRecognizer)->Void)?
private var onTextViewDidChangeAction: ((InputBarButtonItem, InputTextView)->Void)?
private var onSelectedAction: ((InputBarButtonItem)->Void)?
private var onDeselectedAction: ((InputBarButtonItem)->Void)?
private var onEnabledAction: ((InputBarButtonItem)->Void)?
private var onDisabledAction: ((InputBarButtonItem)->Void)?
```

## Author

<img src="https://github.com/nathantannar4/NTComponents/raw/master/NTComponents/Assets/Nathan.png" width="75" height="75">
Nathan Tannar - https://nathantannar.me

## License

Distributed under the MIT license. See ``LICENSE`` for more information.
