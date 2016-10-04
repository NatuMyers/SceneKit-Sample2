import UIKit
import SceneKit


class GameViewController: UIViewController {
    
    var scnView: SCNView! // Here you declare a property for the SCNView that renders the content of the SCNScene on the display.
    var scnScene: SCNScene! // Here you declare a property for the SCNScene in your game. You will add components like lights, camera, geometry, or particle emitters as children of this scene.
    
   
    
    var cameraNode: SCNNode!
    
    var spawnTime:NSTimeInterval = 0
    
    func setupCamera() {
        
        // 1 You first create an empty SCNNode and assign it to cameraNode.
        
        cameraNode = SCNNode()
        
        // 2 You next create a new SCNCamera object and assign it to the camera property of cameraNode.
        
        cameraNode.camera = SCNCamera()
        
        // 3 Then you set the position of the camera at (x:0, y:0, z:10).

        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        
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
        
        // add color ---
        
        geometry.materials.first?.diffuse.contents = UIColor.random()
        
        // add physics to the shapes---
        
        geometryNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil) // creates a new instance of SCNPhysicsBody and assigns it to the physicsBody property of geometryNode. When you create a physics body, you specify the type and shape the body should have. If you pass in nil for the physics shape, Scene Kit will automatically generate a shape based on the geometry of the node. 
        // If you want to add more detail to the physics shape, you could create a SCNPhysicsShape and use that for the shape instead of passing in nil.
        
        // now that there are physics, add force
        
        
        // 1
        let randomX = Float.random(min: -2, max: 2)
        
        let randomY = Float.random(min: 10, max: 18)
        // 2
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        // 3
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        // 4
        geometryNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        
        // (impulses stop. non-[impulse forces keep going)
        
        
        // this makes us able to change perspective----
        
        // 1 showStatistics enables a real-time statistics panel at the bottom of your scene.
        
        scnView.showsStatistics = true
        
        // 2 allowsCameraControl lets you manually control the active camera through simple gestures.
        
        scnView.allowsCameraControl = true
        // 3 autoenablesDefaultLighting creates a generic omnidirectional light in your scene so you don’t have to worry about adding your own light sources for the moment.
        
        scnView.autoenablesDefaultLighting = true
        
        /*
 
         Single finger swipe: Rotates your active camera around the contents of the scene.
         Two finger swipe: Moves, or pans your camera left, right, up or down in the scene.
         Two finger pinch: Zooms the camera in and out of the scene.
         Double-tap: If you have more than one camera, this switches between the cameras in your scene. Of course since you have only one camera this won’t don that. However, it also has the effect of resetting the camera to its original position and settings.

         */

    }
    
    //  remove objects that fall out of sight because spawnshape doesn't.
    func cleanScene() {
        // 1 Here you simply create a little for loop that steps through all available child nodes within the root node of the scene.
        for node in scnScene.rootNode.childNodes {
            // 2 Since the physics simulation is in play at this point, you can’t simply look at the object’s position as this reflects the position before the animation started. Scene Kit maintains a copy of the object during the animation and plays it out until the animation is done. It’s a strange concept to understand at first, but you’ll see how this works before long. To get the actual position of an object while it’s animating, you leverage the presentationNode property. This is purely read-only: don’t attempt to modify any values on this property!
            
            if node.presentationNode.position.y < -2 {
                // 3 kill the object
                node.removeFromParentNode()
            }
        }
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
        scnView.delegate = self // Before the view can call the renderer delegate method, it first needs to know that GameViewController will act as the delegate for the view.
        scnView.playing = true
    }
    
    func setupScene() { //  creates a new blank instance of SCNScene and stores it in scnScene; it then sets this blank scene as the one for scnView to use.
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    

    
}

// add renderer delegate
// 1 adds an extension to GameViewController for protocol conformance and lets you maintain code protocol methods in separate blocks of code.
extension GameViewController: SCNSceneRendererDelegate {
    // 2 adds an implemention of the renderer(_: updateAtTime:) protocol method.
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        // 3 call spawnShape() to create a new shape inside the delegate method.
        // spawnShape() didn't workfor periodic spawning
        
        // 1
        if time > spawnTime {
            spawnShape()
            cleanScene()
            
            // 2
            spawnTime = time + NSTimeInterval(Float.random(min: 0.2, max: 1.5))
        }
    }
}
