import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView! // Here you declare a property for the SCNView that renders the content of the SCNScene on the display.
    var scnScene: SCNScene! // Here you declare a property for the SCNScene in your game. You will add components like lights, camera, geometry, or particle emitters as children of this scene.
    
    var cameraNode: SCNNode!
    
    func setupCamera() {
        // 1 You first create an empty SCNNode and assign it to cameraNode.
        cameraNode = SCNNode()
        // 2 You next create a new SCNCamera object and assign it to the camera property of cameraNode.
        cameraNode.camera = SCNCamera()
        // 3 Then you set the position of the camera at (x:0, y:0, z:10).

        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4 Finally, you add cameraNode to the scene as a child node of the scene’s root node.
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        // 1 First you create a placeholder geometry variable for use a bit later on.
        var geometry:SCNGeometry
        // 2  define a switch statement to handle the returned shape from ShapeType.random(). It’s incomplete at the moment and only creates a box shape; you’ll add more to it in the challenge at the end of this chapter.
        switch ShapeType.random() {
        default:
            // 3 You then create an SCNBox object and store it in geometry. You specify the width, height, and length, along with the chamfer radius (which is a fancy way of saying rounded corners).
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        // 4 This statement creates an instance of SCNNode named geometryNode. This time, you make use of the SCNNode initializer that takes a geometry parameter to create a node and automatically attach the supplied geometry.

        let geometryNode = SCNNode(geometry: geometry)
        // 5 Finally, you add the node as a child of the scene’s root node.
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera() // call the camera stuff we did
        spawnShape() // call shape spawn
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() { // Here, you cast self.view to a SCNView and store it in the scnView property so that you don’t have to re-cast it ever time you need to reference the view. Note that the view is already configured as an SCNView in Main.storyboard.
        scnView = self.view as! SCNView
    }
    
    func setupScene() { //  creates a new blank instance of SCNScene and stores it in scnScene; it then sets this blank scene as the one for scnView to use.
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
}
