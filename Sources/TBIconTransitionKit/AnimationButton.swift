import UIKit
import SwiftUI

public enum AnimatedButtonState: Int {
    case menu
    case arrow
    case cross
    case plus
    case minus
}

/// `AnimatedButton` is a `UIViewRepresentable` wrapper for `TBAnimationButton`.
/// It enables the use of `TBAnimationButton` in SwiftUI, providing an easy way to integrate
/// a customizable button with an animated icon.
///
/// Wrapped `TBAnimationButton` is a subclass of `UIButton` with an icon drawn with code.
/// The appearance of the icon can be modified by changing the line width, line cap, etc.
@available(iOS 13.0, *)
public struct AnimatedButton: UIViewRepresentable {
    let state: AnimatedButtonState
    let action: (TBAnimatedButton) -> ()
    let configure: (TBAnimatedButton) -> ()

    public func makeCoordinator() -> Coordinator { Coordinator(self) }

    public init(
        state: AnimatedButtonState,
        configure: @escaping (TBAnimatedButton) -> (),
        action: @escaping (TBAnimatedButton) -> ()
    ) {
        self.state = state
        self.action = action
        self.configure = configure
    }
    
    public class Coordinator: NSObject {
        var parent: AnimatedButton

        init(_ button: AnimatedButton) {
            self.parent = button
            super.init()
        }

        @objc func doAction(_ sender: TBAnimatedButton) {
            self.parent.action(sender)
        }
    }

    public func makeUIView(context: Context) -> TBAnimatedButton {
        let button = TBAnimatedButton()
        // Assign the properties to the button instance
        button.currentState = state
        configure(button)
        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)
        return button
    }

    public func updateUIView(_ uiView: TBAnimatedButton, context: Context) {}
}

/// `TBAnimationButton` is a subclass of `UIButton` with an icon. All icons are drawn with code.
/// You can modify the icon appearance by changing the line width, line cap, etc.
/// All icons are built with a hamburger menu transformation.
///
/// There are 4 animated transforms between states:
/// - Menu and Arrow
/// - Menu and Cross
/// - Cross and Plus
/// - Plus and Minus
///
/// If you call `animationTransformToState` for other states, they will change without animation.
///
/// To change the button icon, you should set `currentState` to one of `TBAnimationButtonState`, and call `updateAppearance` method.
public class TBAnimatedButton: UIButton {
    
    private static let tbScaleForArrow: CGFloat = 0.7
    private static let tbAnimationKey: String = "tbAnimationKey"
    private static let tbFrameRate: CGFloat = 1.0 / 30.0
    private static let tbAnimationFrames: CGFloat = 10.0

    // Layers for lines
    private var topLayer = CAShapeLayer()
    private var middleLayer = CAShapeLayer()
    private var bottomLayer = CAShapeLayer()

    private var needsToUpdateAppearance = false

    public var lineHeight: CGFloat = 2.0 {
        didSet {
            needsToUpdateAppearance = true
        }
    }

    public var lineWidth: CGFloat = 30.0 {
        didSet {
            needsToUpdateAppearance = true
        }
    }

    public var lineSpacing: CGFloat = 8.0 {
        didSet {
            needsToUpdateAppearance = true
        }
    }

    public var lineColor: UIColor = .black {
        didSet {
            needsToUpdateAppearance = true
        }
    }

    public var lineCap: CAShapeLayerLineCap = .butt {
        didSet {
            needsToUpdateAppearance = true
        }
    }
    
    private var innerState: AnimatedButtonState = .menu
    public var currentState: AnimatedButtonState {
        get {
            return innerState
        }
        set {
            innerState = newValue
            transformTo(state: currentState)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        needsToUpdateAppearance = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        needsToUpdateAppearance = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsToUpdateAppearance {
            updateAppearance()
        }
    }

    func updateAppearance() {
        needsToUpdateAppearance = false
        topLayer.removeFromSuperlayer()
        middleLayer.removeFromSuperlayer()
        bottomLayer.removeFromSuperlayer()
        
        let x = bounds.width / 2.0
        let heightDiff = lineHeight + lineSpacing
        var y = bounds.height / 2.0 - heightDiff
        
        topLayer = createLayer()
        topLayer.position = CGPoint(x: x, y: y)
        y += heightDiff
        
        middleLayer = createLayer()
        middleLayer.position = CGPoint(x: x, y: y)
        y += heightDiff
        
        bottomLayer = createLayer()
        bottomLayer.position = CGPoint(x: x, y: y)
        transformTo(state: currentState)
    }
    
    public func transformTo(state: AnimatedButtonState) {
        var transform: CATransform3D
        switch state {
        case .arrow:
            topLayer.transform = arrowLineTransform(line: topLayer)
            middleLayer.transform = arrowLineTransform(line: middleLayer)
            bottomLayer.transform = arrowLineTransform(line: bottomLayer)
        case .cross:
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            topLayer.transform = CATransform3DRotate(transform, .pi / 4, 0.0, 0.0, 1.0)
            middleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
            bottomLayer.transform = CATransform3DRotate(transform, -.pi / 4, 0.0, 0.0, 1.0)
        case .minus:
            topLayer.transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            middleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            bottomLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        case .plus:
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            topLayer.transform = transform
            middleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
            bottomLayer.transform = CATransform3DRotate(transform, -.pi / 2, 0.0, 0.0, 1.0)
        default:
            topLayer.transform = CATransform3DIdentity
            middleLayer.transform = CATransform3DIdentity
            bottomLayer.transform = CATransform3DIdentity
        }
        innerState = state
    }
    
    func arrowLineTransform(line: CALayer) -> CATransform3D {
        var transform: CATransform3D
        if line == middleLayer {
            let middleLineXScale = lineHeight / lineWidth
            transform = CATransform3DMakeScale(1.0 - middleLineXScale, 1.0, 1.0)
            transform = CATransform3DTranslate(transform, lineWidth * middleLineXScale / 2.0, 0.0, 0.0)
            return transform
        }
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0
        var yShift: CGFloat = 0.0
        if lineCap == .butt {
            yShift = sqrt(2) * lineHeight / 4.0
        }
        let lineShift = lineWidth * (1.0 - TBAnimatedButton.tbScaleForArrow) / 2.0
        transform = CATransform3DMakeTranslation(-lineShift, middleLayer.position.y - line.position.y + yShift * lineMult, 0.0)
        let xTransform = lineWidth / 2.0 - lineShift
        transform = CATransform3DTranslate(transform, -xTransform, 0 , 0.0)
        transform = CATransform3DRotate(transform, .pi / 4 * lineMult, 0.0, 0.0, -1.0)
        transform = CATransform3DTranslate(transform, xTransform, 0, 0.0)
        transform = CATransform3DScale(transform, TBAnimatedButton.tbScaleForArrow, 1.0, 1.0)
        return transform
    }

    public func animationTransform(to state: AnimatedButtonState) {
        if innerState == state {
            return
        }
        var findAnimationForTransition = false
        switch innerState {
        case .arrow:
            if state == .menu {
                findAnimationForTransition = true
                animationTransitionFromMenuToArrow(reverse: true)
            }
        case .cross:
            if state == .menu {
                findAnimationForTransition = true
                animationTransitionFromMenuToCross(reverse: true)
            } else if state == .plus {
                findAnimationForTransition = true
                animationTransitionFromCrossToPlus(reverse: false)
            }
        case .minus:
            if state == .plus {
                findAnimationForTransition = true
                animationTransitionFromPlusToMinus(reverse: true)
            }
        case .plus:
            if state == .cross {
                findAnimationForTransition = true
                animationTransitionFromCrossToPlus(reverse: true)
            } else if state == .minus {
                findAnimationForTransition = true
                animationTransitionFromPlusToMinus(reverse: false)
            }
        default:
            // Default state is menu
            if state == .arrow {
                findAnimationForTransition = true
                animationTransitionFromMenuToArrow(reverse: false)
            } else if state == .cross {
                findAnimationForTransition = true
                animationTransitionFromMenuToCross(reverse: false)
            }
        }
        if !findAnimationForTransition {
            print("Can't find animation transition for these states!")
            transformTo(state: state)
        } else {
            innerState = state
        }
    }
    
    // MARK: - From menu to arrow
    
    func animationTransitionFromMenuToArrow(reverse: Bool) {
        let times = [0.0, 0.5, 0.5, 1.0]
        
        let values = fromMenuToArrowAnimationValues(line: topLayer, reverse: reverse)
        let topAnimation = createKeyFrameAnimation()
        topAnimation.keyTimes = times.map { NSNumber(value: $0) }
        topAnimation.values = values
        
        let bottomValues = fromMenuToArrowAnimationValues(line: bottomLayer, reverse: reverse)
        let bottomAnimation = createKeyFrameAnimation()
        bottomAnimation.keyTimes = times.map { NSNumber(value: $0) }
        bottomAnimation.values = bottomValues
        
        let middleTransform = arrowLineTransform(line: middleLayer)
        let middleValues = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: middleTransform),
            NSValue(caTransform3D: middleTransform)
        ]
        let middleTimes = [0.0, 0.4, 0.4, 1.0]
        let middleAnimation = createKeyFrameAnimation()
        middleAnimation.keyTimes = middleTimes.map { NSNumber(value: $0) }
        middleAnimation.values = middleValues
        middleLayer.add(middleAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        topLayer.add(topAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        bottomLayer.add(bottomAnimation, forKey: TBAnimatedButton.tbAnimationKey)
    }
    
    func fromMenuToArrowAnimationValues(line: CALayer, reverse: Bool) -> [NSValue] {
        var values = [NSValue]()
        
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0
        let yTransform = middleLayer.position.y - line.position.y
        var yShift: CGFloat = 0.0
        if lineCap == .butt {
            yShift = sqrt(2.0) * lineHeight / 4.0
        }
        
        var transform = CATransform3DIdentity
        values.append(NSValue(caTransform3D: transform))
        
        transform = CATransform3DTranslate(transform, 0.0, yTransform, 0.0)
        values.append(NSValue(caTransform3D: transform))
        
        let lineShift = lineWidth * (1.0 - TBAnimatedButton.tbScaleForArrow) / 2.0
        let scaleTransform = CATransform3DScale(transform, TBAnimatedButton.tbScaleForArrow, 1.0, 1.0)
        let translatedScaleTransform = CATransform3DTranslate(scaleTransform, -lineShift, 0.0, 0.0)
        values.append(NSValue(caTransform3D: translatedScaleTransform))
        
        transform = CATransform3DTranslate(transform, -lineShift, 0.0, 0.0)
        let xTransform = lineWidth / 2.0 - lineShift
        
        transform = CATransform3DTranslate(transform, -xTransform, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat.pi / 4 * lineMult, 0.0, 0.0, -1.0)
        transform = CATransform3DTranslate(transform, xTransform, 0.0, 0.0)
        
        transform = CATransform3DScale(transform, TBAnimatedButton.tbScaleForArrow, 1.0, 1.0)
        transform = CATransform3DTranslate(transform, 0.0, yShift * lineMult, 0.0)
        values.append(NSValue(caTransform3D: transform))
        
        if reverse {
            values.reverse()
        }
        return values
    }
    
    // MARK: - From menu to cross
    
    func animationTransitionFromMenuToCross(reverse: Bool) {
        let times: [NSNumber] = [0.0, 0.5, 1.0]
        
        var values = fromMenuToCrossAnimationValues(line: topLayer, reverse: reverse)
        let topAnimation = createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values
        
        values = fromMenuToCrossAnimationValues(line: bottomLayer, reverse: reverse)
        let bottomAnimation = createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = values
        
        let middleTransform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        values = [NSValue(caTransform3D: CATransform3DIdentity),
                  NSValue(caTransform3D: CATransform3DIdentity),
                  NSValue(caTransform3D: middleTransform),
                  NSValue(caTransform3D: middleTransform)]
        
        if reverse {
            values.reverse()
        }
        
        let middleTimes: [NSNumber] = [0.0, 0.5, 0.5, 1.0]
        let middleAnimation = createKeyFrameAnimation()
        middleAnimation.keyTimes = middleTimes
        middleAnimation.values = values
        middleLayer.add(middleAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        topLayer.add(topAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        bottomLayer.add(bottomAnimation, forKey: TBAnimatedButton.tbAnimationKey)
    }
    
    func fromMenuToCrossAnimationValues(line: CALayer, reverse: Bool) -> [NSValue] {
        var values: [NSValue] = []
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0
        let yTransform: CGFloat = middleLayer.position.y - line.position.y
        
        var transform = CATransform3DIdentity
        values.append(NSValue(caTransform3D: transform))
        transform = CATransform3DTranslate(transform, 0, yTransform, 0.0)
        values.append(NSValue(caTransform3D: transform))
        
        transform = CATransform3DRotate(transform, .pi / 4 * lineMult, 0.0, 0.0, 1.0)
        values.append(NSValue(caTransform3D: transform))
        
        if reverse {
            values.reverse()
        }
        
        return values
    }
    
    // MARK: - From cross to plus
    
    func animationTransitionFromCrossToPlus(reverse: Bool) {
        let times: [NSNumber] = reverse ? [1.0, 0.0] : [0.0, 1.0]
        
        var transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
        transform = CATransform3DRotate(transform, .pi / 4, 0.0, 0.0, 1.0)
        let values: [NSValue] = [
            NSValue(caTransform3D: transform),
            NSValue(caTransform3D: CATransform3DRotate(transform, .pi / 2 + .pi / 4, 0.0, 0.0, 1.0))
        ]
        let topAnimation = createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values
        
        transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
        transform = CATransform3DRotate(transform, -.pi / 4, 0.0, 0.0, 1.0)
        let bottomValues: [NSValue] = [
            NSValue(caTransform3D: transform),
            NSValue(caTransform3D: CATransform3DRotate(transform, .pi / 2 + .pi / 4, 0.0, 0.0, 1.0))
        ]
        let bottomAnimation = createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = bottomValues
        
        topLayer.add(topAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        bottomLayer.add(bottomAnimation, forKey: TBAnimatedButton.tbAnimationKey)
    }
    
    // MARK: - From plus to minus
    
    func animationTransitionFromPlusToMinus(reverse: Bool) {
        let times: [NSNumber] = reverse ? [1.0, 0.0] : [0.0, 1.0]
        
        var transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
        let values: [NSValue] = [
            NSValue(caTransform3D: transform),
            NSValue(caTransform3D: CATransform3DRotate(transform, -.pi, 0.0, 0.0, 1.0))
        ]
        let topAnimation = createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values
        
        transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
        transform = CATransform3DRotate(transform, -.pi / 2, 0.0, 0.0, 1.0)
        let bottomValues: [NSValue] = [
            NSValue(caTransform3D: transform),
            NSValue(caTransform3D: CATransform3DRotate(transform, -.pi / 2, 0.0, 0.0, 1.0))
        ]
        let bottomAnimation = createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = bottomValues
        
        topLayer.add(topAnimation, forKey: TBAnimatedButton.tbAnimationKey)
        bottomLayer.add(bottomAnimation, forKey: TBAnimatedButton.tbAnimationKey)
    }
    
    // MARK: - Helpers

    func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineWidth, y: 0))

        layer.path = path.cgPath
        layer.lineWidth = lineHeight
        layer.strokeColor = lineColor.cgColor
        layer.lineCap = lineCap

        let bound = CGPath(__byStroking: layer.path!,
                           transform: nil,
                           lineWidth: layer.lineWidth,
                           lineCap: .butt,
                           lineJoin: .miter,
                           miterLimit: layer.miterLimit)
        layer.bounds = bound!.boundingBox
        self.layer.addSublayer(layer)

        return layer
    }

    func createKeyFrameAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = TBAnimatedButton.tbFrameRate * TBAnimatedButton.tbAnimationFrames
        animation.isRemovedOnCompletion = false // Keep changes
        animation.fillMode = .forwards // Keep changes
        // Custom timing function for really smooth =)
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.60, 0.00, 0.40, 1.00)
        
        return animation
    }
}
