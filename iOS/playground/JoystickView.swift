//
//  JoystickView.swift
//  playground
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit


@objc protocol JoystickDelegate {
    @objc optional func onJoystickMoved()
    @objc optional func onJoystickSoftReleased()
    @objc optional func onJoystickReleased()
    @objc optional func joystickSoftReturnDuration() -> Float // max time for "return center" method which is called after user releases joystick
    @objc optional func joystickBounds() -> CGRect
}

//extension JoystickDelegate {
//    func onJoystickMoved() {}
//    @objc func onJoystickSoftReleased() {}
//    func onJoystickReleased() {}
//    @objc func joystickSoftReturnDuration() -> Float { return 0.0 }
//}


class JoystickView: UIView {
    
    enum JoystickType : UInt {
        case DRIVE_JOYSTICK
        case HEAD_JOYSTICK
    }

    let DRIVE_DRAGGER_IMAGE = "RC_drive_joystick"
    let HEAD_DRAGGER_IMAGE = "RC_head_joystick"
    let DOTSIZE : CGFloat = 90
    let TIMER_RETURN_UPDATE_RATE : Float = 30.0 // delegates calls update rate ( affects robot update state )
    
    var type : JoystickType = .DRIVE_JOYSTICK
    var draggerImgView : UIImageView = UIImageView()
    
    @IBOutlet weak var joystickDelegate : JoystickDelegate!

    var returnTimer : Timer?
    var currentReturnRatio : Float = 0.0
    var returnTime : Float = 0.0

    var _center : CGPoint = CGPoint()
    private var _dotPos = CGPoint()
    var dotPos : CGPoint {
        set {
            self._dotPos = newValue
            joystickDelegate.onJoystickMoved?()
        }
        get {
            return self._dotPos
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        contentMode = .scaleAspectFit
        autoresizingMask = UIViewAutoresizing(rawValue: 0)
        self.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _center = CGPoint(x:bounds.width / 2.0, y: bounds.height / 2.0)
        dotPos = _center
        self.updateDraggerPosition()        
    }
    

//}
//
//
//// MARK: Joystick Layout
//extension JoystickView {
    func updateDraggerImage() {
        let imgName : String
        switch type {
        case .DRIVE_JOYSTICK:
            imgName = DRIVE_DRAGGER_IMAGE
        case .HEAD_JOYSTICK:
            imgName = HEAD_DRAGGER_IMAGE
        }
        let img = UIImage(named: imgName)
        draggerImgView = UIImageView(image: img)
        draggerImgView.frame = CGRect(x: 0.0, y: 0.0, width: DOTSIZE, height: DOTSIZE)
        draggerImgView.center = dotPos
        print("adding the dragger")
        addSubview(draggerImgView)
    }
    
    
    func enforceJoystickBound(_ point: CGPoint) -> CGPoint? {
        guard let bounds = joystickDelegate.joystickBounds?() else {
            return nil
        }
        
        return CGPoint(x: clamp(point.x, bounds.origin.x, bounds.width),
                       y: clamp(point.y, bounds.origin.y, bounds.height) )
    }
    
//    // forbid the joystick dot going out of circle
//    override func enforceJoystickBound(_ point: UnsafeMutablePointer<CGPoint>!) {
//        guard let bounds = joystickDelegate.joystickBounds?() else {
//            return
//        }
//        let originalPoint = point.pointee
//        point.pointee = CGPoint(x: clamp(originalPoint.x, bounds.origin.x, bounds.width),
//                                y: clamp(originalPoint.y, bounds.origin.y, bounds.height) )
//        
//    }
    

}


// MARK: -
// MARK: handle touches
extension JoystickView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnTimer?.invalidate()
        currentReturnRatio = 0
        draggerImgView.layer.removeAllAnimations()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (joystickDelegate.joystickSoftReturnDuration?()) != nil {
            joystickDelegate.onJoystickSoftReleased?()
            returnJoystickToCenter()
        } else {
            returnNow()
            joystickDelegate?.onJoystickReleased?()
        }
    }
    
    func returnNow() {
        if let timer = returnTimer {
            timer.invalidate()
            returnTimer = nil
        }
        dotPos = _center
        updateDraggerPosition()
    }
    
    func returnJoystickToCenter() {
        let dist = getDistance(p1: _center, p2: dotPos)
        if dist < 0.1 {
            returnNow()
        } else if let returnDuration = joystickDelegate.joystickSoftReturnDuration?() {
            returnTime = returnDuration * Float(dist) / Float(bounds.width)
            // timer will update robot with new joystick values while is being animated
            returnTimer = Timer.scheduledTimer(timeInterval: TimeInterval(returnTime / TIMER_RETURN_UPDATE_RATE), target:self, selector:#selector(self.updateReturnJoystick), userInfo:nil, repeats:true)
            
            // animate soft return
            UIView.animate(withDuration: TimeInterval(returnTime), animations: {
                self.draggerImgView.center = self._center
            })
            
        }
    }
    
    func updateReturnJoystick() {
        if currentReturnRatio > 1 {
            dotPos = _center
            // means we have returned it to the center
            joystickDelegate.onJoystickReleased?()
            
            // clean
            returnTimer?.invalidate()
            returnTimer = nil
            currentReturnRatio = 0;
        } else {
            currentReturnRatio += (returnTime / TIMER_RETURN_UPDATE_RATE)
            joystickDelegate.onJoystickMoved?()
            
            dotPos = lerpPoints(min: dotPos, max: _center, T: Double(currentReturnRatio * 0.4))
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let originalPos = touches.first?.location(in: self) {
            if let newPos = enforceJoystickBound(originalPos) {
                dotPos = newPos
            } else {
                dotPos = originalPos
            }
        }
        

        updateDraggerPosition()
    }
        
    
}



extension JoystickView {


    func updateDraggerPosition() {
        draggerImgView.center = dotPos;
    }
    
    func getX() -> Float {
        return 0
    }
    func getY() -> Float {
        return 0
    }

}


