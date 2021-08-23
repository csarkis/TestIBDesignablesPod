//
//  RadioButton.swift
//  GraphicLibrary
//
//  Created by Carl Sarkis on 23/08/2021.
//

import UIKit

@available(iOS 11.0, *)
@IBDesignable
class RadioButton: UIControl {

    // UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?

    /// Radio button radius
    private var radioButtonSize: CGFloat = 20

    /// Enables haptic feedback at touch (disabled by default)
    public var useHapticFeedback: Bool = false

    /// A Boolean value that determines the off/on state of the radio button. Default is on
    @IBInspectable public var isOn: Bool = true {
        didSet {
            setupViews()
        }
    }

    /// A Boolean value that determines if the radio button is enabled. If it
    /// is disabled, it won't answer to the user anymore and switch to the "disabled"
    /// set of colors.
    override public var isEnabled: Bool {
        didSet {
            setupViews()
            if self.isEnabled != self.isComponentEnabled {
                self.isComponentEnabled = self.isEnabled
            }
        }
    }

    /// :nodoc:
    /// Boolean value meant for the Interface Builder
    @IBInspectable var isComponentEnabled: Bool = true {
        didSet {
            if self.isEnabled != self.isComponentEnabled {
                self.isEnabled = self.isComponentEnabled
            }
        }
    }

    // MARK: Intialisers

    /// :nodoc:
    public override init(frame: CGRect) {

        super.init(frame: frame)
        setupViews()
    }

    /// :nodoc:
    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setupViews()
    }

    /// Setup the view initially
    private func setupViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizesSubviews = false


        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true

        prepareForInterfaceBuilder()
        setNeedsDisplay()
    }

    /// Main color of the radio button element
    private var color: UIColor {
        if !self.isEnabled {
            return UIColor.lightGray

        } else if !self.isOn {
            // Off checkbox: circle color
            return UIColor.darkGray

        } else if let color = self.primaryColor {
            return color
        }

        return self.isEnabled
            ? UIColor.green
            : UIColor.darkGray
    }

    /// Primary color.
    ///
    /// Controls the "on" color of checkboxes and the "on" color of the switch bar.
    @IBInspectable public var primaryColor: UIColor? {
        didSet {
            setupViews()
        }
    }

    // MARK: View management

    // MARK: Custom drawings
    /// Width of the unchecked radio circle
    private var borderWidth: CGFloat = 2

    /// :nodoc:
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.color.cgColor)
        context.setFillColor(self.color.cgColor)
        context.setLineWidth(self.borderWidth)

        drawRadio(in: rect, for: context)
    }

    private func drawRadio(in rect: CGRect, for context: CGContext) {
        // Radio button
        // Draw inside the box, considering the border width
        let newRect = rect.insetBy(dx: (rect.width - radioButtonSize + borderWidth) / 2,
                                   dy: (rect.height - radioButtonSize + borderWidth) / 2)

        // Draw the outlined circle
        let borderCircle = UIBezierPath(ovalIn: newRect)
        borderCircle.stroke()
        context.addPath(borderCircle.cgPath)
        context.strokePath()
        context.fillPath()

        if isOn {
            // Draw the inner dot
            let inset: CGFloat = 4
            let insets = UIEdgeInsets(top: inset,
                                      left: inset,
                                      bottom: inset,
                                      right: inset)
            let innerRect: CGRect = newRect.inset(by: insets)
            let innerCircle = UIBezierPath(ovalIn: innerRect)
            innerCircle.fill()
            context.addPath(innerCircle.cgPath)
            context.fillPath()
        }
    }

    /// :nodoc:
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.setNeedsDisplay()
    }

    /// :nodoc:
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 40, height: 40)
    }

    /// :nodoc:
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }

    // MARK: Interactions
    /// :nodoc:
    /// Start of the touch event
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }

    /// :nodoc:
    /// End of the touch event
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isOn = !isOn
        self.sendActions(for: .valueChanged)
        if useHapticFeedback {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }

}
