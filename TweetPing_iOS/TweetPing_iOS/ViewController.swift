//
//  ViewController.swift
//  TweetPing_iOS
//
//  Created by Eric Ito on 3/18/15.
//  Copyright (c) 2015 Esri. All rights reserved.
//

import UIKit

class TweetPingLayer: CAShapeLayer {

    var pingColor: UIColor! {
        didSet {
            strokeColor = pingColor.CGColor
        }
    }
    
    var pingWidth: CGFloat! {
        set {
            lineWidth = newValue
        }
        get {
            return lineWidth
        }
    }
    
    var pingDuration: Double = 1.0 {
        didSet {
            
            pathAnimation.duration = pingDuration
            opacityAnimation.duration = pingDuration

            removeAllAnimations()
            addAnimation(pathAnimation, forKey: "pathAnimation")
            addAnimation(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    private let toRadius: CGFloat!
    private let fromRadius: CGFloat!
    private let center: CGPoint!
    
    private lazy var fromPath: CGPath! = {
        
        var fromPath = UIBezierPath()
        fromPath.addArcWithCenter(self.center, radius: self.fromRadius, startAngle: CGFloat(0), endAngle: CGFloat(2.0*M_PI), clockwise: true)
        fromPath.closePath()
        return fromPath.CGPath
    }()
    
    private lazy var toPath: CGPath! = {
        
        var toPath = UIBezierPath()
        toPath.addArcWithCenter(self.center, radius: self.toRadius, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        toPath.closePath()
        return toPath.CGPath
    }()
    
    private lazy var pathAnimation: CABasicAnimation = {
        var anim = CABasicAnimation(keyPath: "path")
        anim.duration = 1.0
        anim.fromValue = self.fromPath
        anim.toValue = self.toPath
        anim.removedOnCompletion = true
        anim.delegate = self
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return anim
    }()
    
    private lazy var opacityAnimation: CABasicAnimation = {
        var anim2 = CABasicAnimation(keyPath: "opacity")
        anim2.duration = self.pingDuration
        anim2.fromValue = 1.0
        anim2.toValue = 0.0
        anim2.removedOnCompletion = true
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return anim2
    }()
    
    init(center: CGPoint, fromRadius: CGFloat, toRadius: CGFloat) {

        self.center = center
        self.fromRadius = fromRadius
        self.toRadius = toRadius
        self.pingDuration = 1.0
        
        super.init()

        fillColor = UIColor.clearColor().CGColor
        strokeColor = UIColor.blueColor().CGColor
        lineWidth = 1
    
        path = fromPath
    
//        var group = CAAnimationGroup()
//        group.animations = [pathAnimation, opacityAnimation]
//        group.duration = pingDuration
//        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        group.removedOnCompletion = true
//        addAnimation(group, forKey: "group")
        
        addAnimation(pathAnimation, forKey: "expandRadius")
        addAnimation(opacityAnimation, forKey: "opacityAnimation")
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: CALayer delegate
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.removeAllAnimations()
        self.removeFromSuperlayer()
        
        if self.superlayer != nil {
            println("still here -- doesn't get called")
        }
    }
}

class ViewController: UIViewController {

    func pingForTouch(touch: UITouch) {
        var l = TweetPingLayer(center: touch.locationInView(view), fromRadius: 0, toRadius: 50)
        l.pingWidth = 2.0
//        l.drawsAsynchronously = true
//        l.pingDuration = 1.0
        l.pingColor = UIColor.blueColor().colorWithAlphaComponent(0.65)
        view.layer.addSublayer(l)
    }

//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        if let touch = touches.first as? UITouch {
//            pingForTouch(touch)
//        }
//    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.allObjects.first as? UITouch {
            pingForTouch(touch)
        }
    }
    
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        if let touch = touches.first as? UITouch {
//            pingForTouch(touch)
//        }
//    }
}

