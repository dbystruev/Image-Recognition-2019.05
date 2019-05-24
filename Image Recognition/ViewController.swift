//
//  ViewController.swift
//  Image Recognition
//
//  Created by Denis Bystruev on 24/05/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.planeDetection = [.horizontal, .vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print(#line, #function, "\(anchor) added")
        }
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor) {
        let referenceImage = anchor.referenceImage
        let size = referenceImage.physicalSize
        let plane = SCNPlane(width: 1.1 * size.width, height: 1.1 * size.height)
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: "1000usd")
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        
        let ship = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
        ship.scale = SCNVector3(0.1, 0.1, 0.1)
        node.addChildNode(ship)
        
        ship.runAction(
            .repeatForever(
                .group([
                    SCNAction.rotateBy(x: 0, y: -.pi, z: 0, duration: 1),
                    .sequence([
                        .moveBy(x: 0, y: 0.25, z: 0, duration: 1),
                        .moveBy(x: 0, y: -0.25, z: 0, duration: 1),
                    ]),
                    .sequence([
                        .scale(by: 2, duration: 1),
                        .scale(by: 0.5, duration: 1)
                    ])
                ])
            )
        )
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        let extent = anchor.extent
        let width = CGFloat(extent.x)
        let height = CGFloat(extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.blue
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.125
        
        node.addChildNode(planeNode)
    }
    
    
}
