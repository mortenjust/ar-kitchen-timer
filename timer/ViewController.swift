//
//  ViewController.swift
//  timer
//
//  Created by Morten Just Petersen on 7/11/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Pulley

class ViewController: UIViewController, ARSCNViewDelegate {

    

    @IBOutlet var sceneView: ARSCNView!
    var lightNodes = [SCNNode]()
    var timerScene : SCNScene!
    var pullUp : PullUp!
    var drawerController : PulleyViewController!
    var longPressNode : TimerNode!
    var showingDebug = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        timerScene = SCNScene(named: "art.scnassets/TimerScene.scn")!
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = false
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        addGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pullUp = pulleyViewController?.drawerContentViewController as? PullUp
        pulleyViewController?.displayMode = .automatic
    }
    
    @IBAction func debugTapped(_ sender: Any) {
        if showingDebug {
            showDebug(featureDots: false)
            showingDebug = false
        } else {
            showDebug(featureDots: true)
            showingDebug = true
        }
    }
    
    
    func showDebug(featureDots : Bool) {
        if featureDots {
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
            .renderAsWireframe,
            .showBoundingBoxes,
            .showCameras,
            .showConstraints,
            .showLightExtents,
            .showLightInfluences,
            .showSkeletons,
            ARSCNDebugOptions.showWorldOrigin]
            sceneView.showsStatistics = true
        } else {
            sceneView.debugOptions = []
            sceneView.showsStatistics = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showDebug(featureDots: true)
        
        // Create a session configuration
        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.vertical, .horizontal]

        
        
////            , .showLightExtents
////            ,  .showLightInfluences
//        ]

        setupCamera()
        
        lightNodes.append(timerScene.rootNode.childNode(withName: "light1", recursively: true)!)
        lightNodes.append(timerScene.rootNode.childNode(withName: "light2", recursively: true)!)

        
            for light in self.lightNodes {
                let l = light.light
                l?.castsShadow = true
                l?.shadowSampleCount = 20
                l?.shadowRadius = 30
                light.light = l
                self.sceneView.scene.rootNode.addChildNode(light)
            }
        
        
        
//        addLightNodeTo(sceneView.pointOfView!)
        // Run the view's session
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func setupCamera(){
        let camera = self.sceneView.pointOfView?.camera!
        camera?.motionBlurIntensity = 1
        camera?.wantsDepthOfField = true
    }
    
    func addGestures(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        sceneView.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLong(gestureRecognize:)))
        sceneView.addGestureRecognizer(longPress)
    }
    
    
    
    func updateLightNodesLightEstimation() {
        DispatchQueue.main.async {
            let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate
            let ambientIntensity = lightEstimate?.ambientIntensity
            let ambientColorTemperature = lightEstimate?.ambientColorTemperature
            
            for lightNode in self.lightNodes {
                guard let light = lightNode.light else { continue }
                
                if let am = ambientIntensity {
                   light.intensity = am
                }
                
                if let amtemp = ambientColorTemperature {
                    light.temperature = amtemp
                }
            }
        }
    }

    func addLightNodeTo(_ node: SCNNode) {
        let lightNode = getLightNode()
        node.addChildNode(lightNode)
        lightNodes.append(lightNode)
    }
    
    func getLightNode() -> SCNNode {
        let light = SCNLight()
        light.type = .directional
        light.intensity = 1000
        light.temperature = 0
        light.castsShadow = true
        light.shadowRadius = 15.0
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(1, 1, 1)
        
        return lightNode
    }
    
    @objc func handleLong(gestureRecognize gesture: UILongPressGestureRecognizer) {
        let tap : CGPoint = gesture.location(in: self.sceneView)
        switch gesture.state {
        case .changed:
            longPressNode.userTimer.seconds += 10
            longPressNode.userTimer.requestUIUpdate()
        case .ended:
            print("^ended")
        case .cancelled:
            print("^cancelled")
        case .began:
            self.longPressNode = createTimer(with: 0, for: tap)
            // instantiate node
        case .failed:
            print("^failed")
        case .possible:
            print("^possible")
        }
    }
    
    @objc func handleTap(gestureRecognize gesture: UITapGestureRecognizer) {
        print("handletap")
        let tap : CGPoint = gesture.location(in: self.sceneView)
        if maybeDeleteTimer(at: tap) == false {
           _ = createTimer(with: 0, for: tap)
        }        
    }
    
    func maybeDeleteTimer(at tap:CGPoint) -> Bool {
        var wasDeleted = false
        
        for hit in sceneView!.hitTest(tap, options: [.searchMode : 1]) {
            print("hit a \(String(describing: hit.node.name))")
            if(hit.node.name == "plane"){
                hit.node.removeFromParentNode()
                wasDeleted = true
            }
        }
           return wasDeleted
    }
    
    
    func toggleDebugViews(){
        print("toggle debug")
        

        
    }

    func createTimer(with offset : TimeInterval, for tap: CGPoint) -> TimerNode? {
        let userTimer = UserTimer(secondsOffset: offset, image: sceneView.snapshot())
        timerStore.allTimers.insert(userTimer, at: 0) // add to top
        let timerNode = TimerNode(timerScene: timerScene, userTimer: userTimer)
        addTimer(to: tap, timerNode: timerNode)
        pullUp.timerCollection.reloadData()
        return timerNode
    }
    
    
    func addTimer(to tap:CGPoint, timerNode node : TimerNode){

        // 1. where should we place it?
        let arHitTestResults : [ARHitTestResult] = self.sceneView.hitTest(tap, types: [.existingPlaneUsingGeometry, .featurePoint])
        
        
        if let closestResult = arHitTestResults.first {
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            self.sceneView.scene.rootNode.addChildNode(node)
//            showDebug(featureDots: false)
            node.position = worldCoord
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateLightNodesLightEstimation()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    

    
    
}


public extension UIViewController {
    
    /// If this viewController pertences to a PulleyViewController, return it.
    public var pulleyViewController: PulleyViewController? {
        var parentVC = parent
        while parentVC != nil {
            if let pulleyViewController = parentVC as? PulleyViewController {
                return pulleyViewController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }
    
    
}
