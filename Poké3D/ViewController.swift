//
//  ViewController.swift
//  Poké3D
//
//  Created by Hunter Hudson on 11/10/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

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
        
        /* Create a session configuration (NOTE: ARImageTrackingConfiguration allows for tracking of images instead of things in the world):
        */
        let configuration = ARImageTrackingConfiguration()
        
        /*Init imageToTrack as an AR reference image in the Pokémon Cards folder (NOTE: bundle is set to bundle.main, which tells the method to look in the current project directory):
        */
        if  let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokémon Cards", bundle: Bundle.main) {
            //Set the configuration's trackingImages as the unwrapped imageToTrack:
            configuration.trackingImages = imageToTrack
            
            //Sets the max amount of images that can be tracked:
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images successfully added to application.")
        }

        // Run the view's session
        sceneView.session.run(configuration)
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
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    /*The anchor for this delegate method will be the image of the card that was detected (method is called when image is detected):
    */
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        //Check to see if the anchor detected is in fact an image:
        if let imageAnchor = anchor as? ARImageAnchor {
            /*Init new plane using the width and height of the reference image of the imageAnchor:
            */
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //Init new node on plane with the geometry of the plane created above:
            let planeNode = SCNNode(geometry: plane)
            
            //Add planeNode:
            node.addChildNode(planeNode)
        }
        
        return node
    }
}
