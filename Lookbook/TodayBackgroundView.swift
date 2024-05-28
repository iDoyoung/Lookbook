import SceneKit
import SwiftUI

struct TodayBackgroundView: View {
    
    private var scene: SCNScene {
        let scene = SCNScene()
//        scene.rootNode.addChildNode(createCloudNode())
        scene.rootNode.addChildNode(createCameraNode())
        scene.rootNode.addChildNode(createFloorNode())
        return scene
    }
    
    var body: some View {
        SceneView(scene: scene)
    }
    
    
    private func createCloudNode() -> SCNNode {
        let image = UIImage(named: "cloud_border_1")
        var node: SCNNode
        
        let plane = SCNPlane(
            width: (image?.size.width ?? 0) / 200,
            height: (image?.size.height ?? 0) / 200
        )
        
        plane.firstMaterial?.diffuse.contents = image
        node = SCNNode(geometry: plane)
        node.position = SCNVector3(x: 0, y: 2, z: 0)
        
//        let moveLeft = SCNAction.moveBy(x: -5, y: 0, z: 0, duration: 5)
//        let moveToRight = SCNAction.moveBy(x: 10, y: 0, z: 0, duration: 0)
//        let sequence = SCNAction.sequence([moveLeft, moveToRight])
//        let repeatForever = SCNAction.repeatForever(sequence)
//        
//        node.runAction(repeatForever) 
        
        return node
    }
    
    private func createFloorNode() -> SCNNode {
        let floor = SCNFloor()
        let node = SCNNode(geometry: floor)
        node.position = SCNVector3(0, -0.5, 0)
        
        return node
    }
    
    private func createCameraNode() -> SCNNode {
        let camera = SCNCamera()
        let node = SCNNode()
        node.camera = camera
        node.position = SCNVector3(x: 0, y: 0, z: 1)
        
        return node
    }
}

#Preview {
    TodayBackgroundView()
}
