import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView! // Here you declare a property for the SCNView that renders the content of the SCNScene on the display.
    var scnScene: SCNScene! // Here you declare a property for the SCNScene in your game. You will add components like lights, camera, geometry, or particle emitters as children of this scene.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
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
    }
    
}
