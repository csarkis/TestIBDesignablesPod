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
    @IBInspectable var radioButtonSize: CGFloat = 20 { didSet { setNeedsDisplay() } }

    /// Enables haptic feedback at touch (disabled by default)
    public var useHapticFeedback: Bool = false

    /// A Boolean value that determines the off/on state of the radio button. Default is on
    @IBInspectable public var isOn: Bool = true { didSet { setNeedsDisplay() } }

    /// :nodoc:
    /// Boolean value meant for the Interface Builder
    @IBInspectable var isComponentEnabled: Bool {
        get { isEnabled }
        set { isEnabled = newValue }
    }

    /// Main color of the radio button element
    private var color: UIColor {
        if !isEnabled {
            return .lightGray
        } else if !isOn {
            // Off checkbox: circle color
            return .darkGray
        } else if let color = primaryColor {
            return color
        }

        return isEnabled ? .green : .darkGray
    }

    /// Primary color.
    ///
    /// Controls the "on" color of checkboxes and the "on" color of the switch bar.
    @IBInspectable public var primaryColor: UIColor?

    // MARK: Custom drawings
    /// Width of the unchecked radio circle
    @IBInspectable var borderWidth: CGFloat = 2 { didSet { setNeedsDisplay() } }

    /// :nodoc:
    public override func draw(_ rect: CGRect) {
        color.setStroke()
        color.setFill()

        drawRadio(in: rect)
    }

    private func drawRadio(in rect: CGRect) {
        // Radio button
        // Draw inside the box, considering the border width
        let newRect = bounds.insetBy(dx: (bounds.width - radioButtonSize + borderWidth) / 2,
                                     dy: (bounds.height - radioButtonSize + borderWidth) / 2)

        // Draw the outlined circle
        let borderCircle = UIBezierPath(ovalIn: newRect)
        borderCircle.lineWidth = borderWidth
        borderCircle.stroke()

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
        }
    }

    /// :nodoc:
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 40, height: 40)
    }

    // MARK: Interactions
    /// :nodoc:
    /// Start of the touch event
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        feedbackGenerator?.prepare()
    }

    /// :nodoc:
    /// End of the touch event
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn.toggle()
        sendActions(for: .valueChanged)
        if useHapticFeedback {
            feedbackGenerator?.impactOccurred()
            feedbackGenerator = nil
        }
    }
}
