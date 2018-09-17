//
//  Timer.swift
//  timer
//
//  Created by Morten Just Petersen on 7/11/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit
import ARKit
import Foundation




class TimerNode: SCNNode, UserTimerDelegate {
   
    
    
    var seconds : TimeInterval = 0
    var timer : Timer!
    var timerReadout = "00:00"
    var timeStarted = ""
    var userTimer : UserTimer!
    
    var tickNode = SCNNode();
    var readoutGeometry = SCNText();
    var readoutNode = SCNNode()
    var startedGeometry = SCNText();
    var planeGeometry = SCNPlane();
    
    
    override init() {
        super.init()
        print("use the other init")
    }
    
    init(timerScene : SCNScene, userTimer : UserTimer) {
        super.init()
        addChildNode(self.makeTimerNode(withScene: timerScene))
        self.userTimer = userTimer
        userTimer.nodeDelegate = self
        self.userTimer.start() // will upda via delegate
        
        
//        self.startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func formatTimer(s:TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(s))!
        return formattedString
    }

    
    func stopTimer(){}
    func resetTimer(){}
    
    func makeTimerNode(withScene s : SCNScene) -> SCNNode {
        
        let s = SCNScene(named: "art.scnassets/TimerScene.scn")! // weird, it can't pass its
        
        let t = s.rootNode.childNode(withName: "timer", recursively: false)!
        
        readoutNode = t.childNode(withName: "mainTimer", recursively: true)!
        readoutGeometry = readoutNode.geometry as! SCNText
        planeGeometry = t.childNode(withName: "plane", recursively: true)?.geometry as! SCNPlane
        tickNode = t.childNode(withName: "tickmarks", recursively: true)!
        
        
        
        
        
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = [.X, .Y]
        t.constraints = [constraint] // don't rotate the Z axis
        
        t.name = "timerNode"
        
        
        
        return t
    }
    
    
    // MARK: UserTimer Delegate
    func timerUpdated(seconds: TimeInterval, formatted: String) {
        
        DispatchQueue.main.async {
            self.readoutGeometry.string = "\(formatted)"
        
            let maxX : CGFloat = 52
            
            if self.readoutGeometry.boundingBox.max.x > 52 {
                let scaleFactor = maxX / CGFloat(self.readoutGeometry.boundingBox.max.x)
                let curFontSize = self.readoutGeometry.font.pointSize
                let newFontSize = curFontSize * scaleFactor
                let curFont = self.readoutGeometry.font.fontName
                
                print("font size now is \(self.readoutGeometry.font.fontName) or \(self.readoutGeometry.font.familyName)")
                self.readoutGeometry.font = UIFont(name: curFont, size: newFontSize)
                
//                self.readoutGeometry.font = UIFont.boldSystemFont(ofSize: newFontSize)
            }
        }
        
        let offset : Float = Float(self.seconds)/20
        let translate = SCNMatrix4MakeTranslation(offset, 0, 0)
        //            let scale = SCNMatrix4MakeScale(2, 14, 1)
        //            let transform = SCNMatrix4Mult(scale, translate)
        self.tickNode.geometry?.firstMaterial?.diffuse.contentsTransform = translate
    }
    
}
