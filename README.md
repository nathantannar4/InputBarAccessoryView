# InputBarAccessoryView

#### To be used in [MessageKit](https://github.com/MessageKit/MessageKit)
<img src="https://cdn.rawgit.com/MessageKit/MessageKit/master/Assets/mklogo.svg" title="MessageKit logo" height="60">

## InputBarAccessoryView Examples

Explore the Example project!

<img src="./Slack Keyboard.png" width="242" height="432">  <img src="./Simple Keyboard.png" width="242" height="432">

## Layout

```swift
H:|-(padding.left)-[UIStackView(leftStackViewWidthContant)]-(textViewPadding.left)-[InputTextView]-(textViewPadding.right)-[UIStackView(rightStackViewWidthContant)]-(padding.right)-|

V:|-(padding.top)-[InputTextView]-(textViewPadding.bottom)-[UIStackView]-(padding.bottom)-|
```

## Hooks

Each InputBarButtonItem has properties that can hold actions that will be executed during various hooks such as the button being touched, the UITextView text changing and more! Thanks to these easy hooks with a few lines of code the items can be easily resized and animated similar to that of the Facebook messenger app.

## Author

<img src="https://github.com/nathantannar4/NTComponents/raw/master/NTComponents/Assets/Nathan.png" width="75" height="75">
Nathan Tannar - https://nathantannar.me

## License

Distributed under the MIT license. See ``LICENSE`` for more information.
