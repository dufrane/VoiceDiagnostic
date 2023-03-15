//
//  PlayButton.swift
//  Voice Diagnostic
//
//  Created by Dmytro Vasylenko on 14.01.2023.
//

import UIKit

protocol RecordButtonDelegate: AnyObject {
    func tapButton(isRecording: Bool)
}

class RecordButton: UIView {
    private var isRecording = false
    private var roundView: UIView?
    private var squareSide: CGFloat = 30
    private let externalCircleFactor: CGFloat = 0.1
    private let roundViewSideFactor: CGFloat = 0.75
    weak var delegate: RecordButtonDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupRecordButtonView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        setupRecordButtonView()
    }

    private func setupRecordButtonView() {
        drawExternalCircle()
        drawRoundedButton()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(tappedView(_:))))
    }
    
    private func drawExternalCircle() {
        let layer = CAShapeLayer()
        let radius = min(self.bounds.width, self.bounds.height) / 2
        let lineWidth = externalCircleFactor * radius
        layer.path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2,
                                                     y: self.bounds.size.height / 2),
                                  radius: radius-lineWidth / 2,
                                  startAngle: 0,
                                  endAngle: 2 * CGFloat(Float.pi),
                                  clockwise: true).cgPath
        layer.lineWidth = lineWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.opacity = 1
        self.layer.addSublayer(layer)
    }

    private func drawRoundedButton() {
        squareSide = roundViewSideFactor * min(self.bounds.width, self.bounds.height)
        roundView = UIView(frame: CGRect(x: self.frame.size.width / 2 - squareSide / 2,
                                         y: self.frame.size.height / 2 - squareSide / 2,
                                         width: squareSide,
                                         height: squareSide))
        roundView?.backgroundColor = .red
        roundView?.layer.cornerRadius = squareSide / 2
        if let roundView {
            self.addSubview(roundView)
        } else {
            return
        }
    }
    
    private func recordButtonAnimation() -> CAAnimationGroup {
        let transformToStopButton = CABasicAnimation(keyPath: "cornerRadius")
        transformToStopButton.fromValue = !isRecording ? squareSide / 2 : 10
        transformToStopButton.toValue = !isRecording ? 10 : squareSide / 2
        let toSmallCircle = CABasicAnimation(keyPath: "transform.scale")
        toSmallCircle.fromValue = !isRecording ? 1 : 0.65
        toSmallCircle.toValue = !isRecording ? 0.65 : 1
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [transformToStopButton, toSmallCircle]
        animationGroup.duration = 0.25
        animationGroup.fillMode = CAMediaTimingFillMode.both
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }

    @objc func tappedView(_ sender: UITapGestureRecognizer) {
        self.roundView?.layer.add(self.recordButtonAnimation(), forKey: "")
        isRecording = !isRecording
        delegate?.tapButton(isRecording: isRecording)
    }

    // To be used when app goes to background
    // Advance animation and save recording
    public func endRecording() {
        self.roundView?.layer.add(self.recordButtonAnimation(), forKey: "")
        isRecording = !isRecording
    }

    override open func prepareForInterfaceBuilder() {
        self.backgroundColor = .clear
        setupRecordButtonView()
    }
}
