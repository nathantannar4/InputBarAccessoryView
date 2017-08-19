//
//  File.swift
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

public class ToolbarItem: UIView {
    
    public enum Spacing {
        case none
        case flexible
        case fixed
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    public var title: String? {
        didSet {
            self.titleLabel?.text = title
            self.setNeedsUpdateConstraints()
        }
    }
    
    public var image: UIImage? {
        didSet {
            self.imageView?.image = image
            self.imageView?.setNeedsDisplay()
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            self.setSelected(isSelected, animated: true)
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            self.tapGestureRecognizer.isEnabled = isEnabled
            self.setEnabled(isEnabled, animated: true)
        }
    }
    
    public var isHighlighted: Bool = false {
        didSet {
            self.setHighlighted(isHighlighted, animated: true)
        }
    }
    
    /// Content inset
    public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    /// Fixed Space width
    public var width: CGFloat = 1 // Default 1
    
    /// Custom height
    public var height: CGFloat = 1
    
    /// The minimum height of the item
    public var minimumHeight: CGFloat {
        return 30
    }
    
    /// The minimum width of the item
    public var minimumWidth: CGFloat {
        if let label: UILabel = self.titleLabel {
            let size: CGSize = label.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return self.contentInset.left + size.width + self.contentInset.right
        }
        
        if let view: UIImageView = self.imageView {
            let size: CGSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return self.contentInset.left + size.width + self.contentInset.right
        }
        
        if let _: UIView = self.customView {
            return self.contentInset.left + self.width + self.contentInset.right
        }
        
        return self.width
    }
    
    /// The maximum height of the item
    public var maximumHeight: CGFloat = UIScreen.main.bounds.height {
        didSet {
            if maximumHeight < minimumHeight {
                debugPrint("[ToolbarItem] *** error: maximumHeight can not be smaller than minimumHeight")
            }
            setNeedsUpdateConstraints()
        }
    }
    
    /// The maximum width of the item
    public var maximumWidth: CGFloat = UIScreen.main.bounds.width {
        didSet {
            if maximumWidth < minimumWidth {
                debugPrint("[ToolbarItem] *** error: maximumWidth can not be smaller than minimumWidth")
            }
            setNeedsUpdateConstraints()
        }
    }
    
    /// Tap event target
    public weak var target: AnyObject?
    
    /// Tap event action
    public var action: Selector?
    
    // Private
    
    private(set) var titleLabel: UILabel?
    
    private(set) var imageView: UIImageView?
    
    private(set) var customView: UIView?
    
    private(set) var spacing: Spacing = .none
    
    private var minimumWidthConstraint: NSLayoutConstraint?
    
    private var maximumWidthConstraint: NSLayoutConstraint?
    
    private var minimumHeightConstraint: NSLayoutConstraint?
    
    private var maximumHeightConstraint: NSLayoutConstraint?
    
    private var titleLabelCenterXConstraint: NSLayoutConstraint?
    
    private var titleLabelCenterYConstraint: NSLayoutConstraint?
    
    private var imageViewCenterXConstraint: NSLayoutConstraint?
    
    private var imageViewCenterYConstraint: NSLayoutConstraint?
    
    private var customViewLeadingConstraint: NSLayoutConstraint?
    
    private var customViewTrailingConstraint: NSLayoutConstraint?
    
    private var customViewTopConstraint: NSLayoutConstraint?
    
    private var customViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - init
    
    public convenience init(title: String?, target: Any?, action: Selector?) {
        self.init(frame: .zero)
        self.target = target as AnyObject
        self.action = action
        
        let label: UILabel = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = title
        
        self.title = title
        self.titleLabel = label
        
        self.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        self.addSubview(label)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public convenience init(image: UIImage, target: Any?, action: Selector?) {
        self.init(frame: .zero)
        self.target = target as AnyObject
        self.action = action
        
        let view: UIImageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = image
        self.imageView = view
        
        self.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        self.addSubview(view)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public convenience init(customView: UIView) {
        self.init(frame: .zero)
        self.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.customView = customView
    }
    
    public convenience init(spacing: Spacing) {
        self.init(frame: .zero)
        self.spacing = spacing
        switch spacing {
        case .flexible:
            self.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
            self.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        case .fixed:
            self.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
            self.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        default: break
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        
        if let label: UILabel = self.titleLabel {
            let size: CGSize = label.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return CGSize(width: self.contentInset.left + size.width + self.contentInset.right, height: size.height)
        }
        
        if let view: UIImageView = self.imageView {
            let size: CGSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return CGSize(width: self.contentInset.left + size.width + self.contentInset.right, height: size.height)
        }
        
        switch self.spacing {
        case .flexible: return CGSize(width: 1, height: 1)
        case .fixed: return CGSize(width: self.width, height: 1)
        default: return super.intrinsicContentSize
        }
    }
    
    override public func updateConstraints() {
        
        // deactive
        self.removeConstraints([self.minimumWidthConstraint,
                                self.maximumWidthConstraint,
                                self.minimumHeightConstraint,
                                self.maximumHeightConstraint,
                                self.titleLabelCenterXConstraint,
                                self.titleLabelCenterYConstraint,
                                self.imageViewCenterXConstraint,
                                self.imageViewCenterYConstraint,
                                self.customViewLeadingConstraint,
                                self.customViewTrailingConstraint,
                                self.customViewTopConstraint,
                                self.customViewBottomConstraint
            ].flatMap({ return $0 }))
        
        self.minimumWidthConstraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: self.minimumWidth)
        self.maximumWidthConstraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: self.maximumWidth)
        self.minimumHeightConstraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: self.minimumHeight)
        self.maximumHeightConstraint = self.heightAnchor.constraint(lessThanOrEqualToConstant: self.maximumHeight)
        
        if let label: UILabel = self.titleLabel {
            self.titleLabelCenterXConstraint = label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            self.titleLabelCenterYConstraint = label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            self.titleLabelCenterXConstraint?.isActive = true
            self.titleLabelCenterYConstraint?.isActive = true
        }
        
        if let view: UIImageView = self.imageView {
            self.imageViewCenterXConstraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            self.imageViewCenterYConstraint = view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            self.imageViewCenterXConstraint?.isActive = true
            self.imageViewCenterYConstraint?.isActive = true
        }
        
        if let view: UIView = self.customView {
            self.customViewLeadingConstraint = view.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor)
            self.customViewTrailingConstraint = view.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
            self.customViewTopConstraint = view.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
            self.customViewBottomConstraint = view.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
            self.customViewLeadingConstraint?.isActive = true
            self.customViewTrailingConstraint?.isActive = true
            self.customViewTopConstraint?.isActive = true
            self.customViewBottomConstraint?.isActive = true
        }
        
        self.minimumHeightConstraint?.isActive = true
        self.maximumHeightConstraint?.isActive = true
        super.updateConstraints()
    }
    
    // MARK: -
    
    public func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        self.layer.removeAllAnimations()
        
        if animated {
            if hidden {
                UIView.animate(withDuration: 0.1, animations: {
                    self.alpha = 0
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.isHidden = hidden
                    }, completion: { (finished) in
                        self.alpha = 1
                    })
                })
            } else {
                self.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.isHidden = hidden
                    self.alpha = 1
                })
            }
        } else {
            self.alpha = 1
            self.isHidden = hidden
        }
    }
    
    public func setSelected(_ isSelected: Bool, animated: Bool) {
        guard self.isEnabled else {
            return
        }
    }
    
    public func setEnabled(_ isEnabled: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                if let label: UILabel = self.titleLabel {
                    label.textColor = isEnabled ? self.tintColor : UIColor.lightGray
                }
                if let view: UIImageView = self.imageView {
                    view.tintColor = isEnabled ? self.tintColor : UIColor.lightGray
                }
            })
        } else {
            if let label: UILabel = self.titleLabel {
                label.textColor = isEnabled ? self.tintColor : UIColor.lightGray
            }
            if let view: UIImageView = self.imageView {
                view.tintColor = isEnabled ? self.tintColor : UIColor.lightGray
            }
        }
    }
    
    public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard self.isEnabled else {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = highlighted ? 0.5 : 1
            })
        } else {
            self.alpha = highlighted ? 0.5 : 1
        }
    }
    
    // MARK: -
    
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self.target, action: self.action)
        return recognizer
    }()
    
    // MARK: - Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.customView == nil {
            self.isHighlighted = true
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.customView == nil {
            self.isHighlighted = false
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if self.customView == nil {
            self.isHighlighted = false
        }
    }
    
}

