//
//  ViewController.swift
//  Finding Surfaces
//
//  Created by MacBook Pro on 15.02.2021.
//

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    // MARK: - Outlet
    @IBOutlet var sceneView: ARSCNView!
    
    //MARK: - Metods
    
    /// Add ship model (discription cmd+opt+/)
    /// - Returns: SCNNode associated with the model
    func loadShip() -> SCNNode {
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let shipNode = scene.rootNode.clone()
        
        return shipNode
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable default lighting
        sceneView.autoenablesDefaultLighting = true
        
        // Set the debug options
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .horizontal {
            // Set size
            let extent = planeAnchor.extent
            let width = CGFloat(extent.x)
            let height = CGFloat(extent.z)
            
            //Create geometry
            let plane = SCNPlane(width: width, height: height)
            plane.firstMaterial?.diffuse.contents = UIColor.green
            
            //Create node
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            planeNode.opacity = 0.5
            
            //Add node to the detected plane
            node.addChildNode(planeNode)
            node.addChildNode(loadShip())
            print(#line, #function, "size:", planeAnchor.extent)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAncher = anchor as? ARPlaneAnchor, planeAncher.alignment == .horizontal{
            
            for childeNode in node.childNodes {
                childeNode.simdPosition = planeAncher.center
                
                if let plane = childeNode.geometry as? SCNPlane {
                    plane.width = CGFloat(planeAncher.extent.x)
                    plane.height = CGFloat(planeAncher.extent.z)
                }
            }
        }
    }
}
