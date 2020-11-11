//
//  ViewController.swift
//  Poké3D
//
//  Created by Hunter Hudson on 11/10/20.
//

//ATTENTION: This app does not actually work as intended. It is mainly an example of how to
//use image tracking for note-taking and educational purposes.

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
        
        /*Allow the sceneView to scan the room for lighting and apply appropriate changes to prevent strange runtime errors with AR objects:
        */
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration:
        
        let configuration = ARWorldTrackingConfiguration()
        
        /*Init imageToTrack as an AR reference image in the Pokémon Cards folder (NOTE: bundle is set to bundle.main, which tells the method to look in the current project directory):
        */
        if  let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokémon Cards", bundle: Bundle.main) {
            /*Set the configuration's detectionImages as the unwrapped imageToTrack (NOTE: this allows the app to track images as well as detect planes):
            */
            configuration.detectionImages = imageToTrack
            
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
            //Print which card was detected to the console:
            print(imageAnchor.referenceImage.name!)
            
            /*Init new plane using the width and height of the reference image of the imageAnchor:
            */
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //Make plane translucent:
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            //Init new node on plane with the geometry of the plane created above:
            let planeNode = SCNNode(geometry: plane)
            
            //Rotates the plane by pi / 2 (NOTE: units are in radians for this method):
            planeNode.eulerAngles.x = -(.pi / 2)
            
            //Add planeNode:
            node.addChildNode(planeNode)
            
            if (imageAnchor.referenceImage.name == "eevee-card") {
                //Create scene for Eevee AR object (optional in case the file can't be pulled):
                if let pokéScene = SCNScene(named: "art.scnassets/eevee.scn") {
                    /*Init pokéNote equal to the first childNode of the rootNode in the pokéScene:
                    */
                    if let pokéNode = pokéScene.rootNode.childNodes.first {
                        //Rotate pokéNode 90 degrees so it's standing directly on the plane:
                        pokéNode.eulerAngles.x = .pi / 2
                        
                        //Add pokéNode to the planeNode if pokéNode isn't nil:
                        planeNode.addChildNode(pokéNode)
                    }
                }
            } else if (imageAnchor.referenceImage.name == "oddish-card") {
                //Create scene for Eevee AR object (optional in case the file can't be pulled):
                if let pokéScene = SCNScene(named: "art.scnassets/oddish.scn") {
                    /*Init pokéNote equal to the first childNode of the rootNode in the pokéScene:
                    */
                    if let pokéNode = pokéScene.rootNode.childNodes.first {
                        //Rotate pokéNode 90 degrees so it's standing directly on the plane:
                        pokéNode.eulerAngles.x = .pi / 2
                        
                        //Add pokéNode to the planeNode if pokéNode isn't nil:
                        planeNode.addChildNode(pokéNode)
                    }
                }
            } else {
                print("Error code 1: could not find reference images.")
            }
            
            
        }
        
        return node
    }
}
