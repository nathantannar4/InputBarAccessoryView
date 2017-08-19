//
//  InputBarAccessoryView.swift
//  NTInputAccessoryView
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 8/18/17.
//

open class InputBarAccessoryView: UIView {
    
    // MARK: - Properties
    
    open weak var delegate: InputBarAccessoryViewDelegate?
    
    open lazy var backgroundView: UIView = { [unowned self] in
        let blurEffect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open var topStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.alignment = .bottom
        view.spacing = 0
        return view
    }()
    
    open var bottomStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.alignment = .bottom
        view.spacing = 0
        return view
    }()
    
    open let textView: InputTextView = {
        let textView = InputTextView()
        textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        textView.textColor = .black
        textView.placeholder = "Aa"
        textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 16.0
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.placeholderInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return textView
    }()
    
    open let sendButton: InputBarItem = {
        let item = InputBarItem()
        return item
    }()
    
    open var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    open var stackViewSpacing: CGFloat {
        return 0
    }
    
    override open var intrinsicContentSize: CGSize {
        
        return CGSize(width: 300, height: 44)
    }
    
    /// [topAnchor, bottomAnchor, leftAnchor, rightAnchor]
    private var backgroundViewConstraints: [NSLayoutConstraint]?
    private var topStackViewConstraints: [NSLayoutConstraint]?
    private var bottomStackViewConstraints: [NSLayoutConstraint]?
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        setupSubviews()
        setupConstraints()
        setupObservers()
        
        #if DEBUG
            
        #endif
    }
    
    private func setupSubviews() {
        
        addSubview(backgroundView)
        addSubview(topStackView)
        addSubview(bottomStackView)
        topStackView.addArrangedSubview(textView)
        
        
    }
    
    private func setupConstraints() {
        
        backgroundViewConstraints = [
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        backgroundViewConstraints?.forEach{ $0.isActive = true }
        
        topStackViewConstraints = [
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            topStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -stackViewSpacing),
            topStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            topStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        ]
        topStackViewConstraints?.forEach{ $0.isActive = true }

        bottomStackViewConstraints = [
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            bottomStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            bottomStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        ]
        bottomStackViewConstraints?.forEach{ $0.isActive = true }
        
        // Anchor the two stack views heights together
//        topStackView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor).isActive = true
    }
    
    open override func updateConstraints() {
        
        super.updateConstraints()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    // MARK: - Notifications
    
    open func orientationDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }
    
    open  func textViewDidChange(_ notification: Notification) {
//        if textView.text.isEmpty && isAccessoryButtonHidden {
//            isAccessoryButtonHidden = false
//        } else if !textView.text.isEmpty && !isAccessoryButtonHidden {
//            isAccessoryButtonHidden = true
//        }
//        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        sendButton.isEnabled = !trimmedText.isEmpty
//        delegate?.textInput?(self, textDidChangeTo: trimmedText)
//        invalidateIntrinsicContentSize()
    }
}
