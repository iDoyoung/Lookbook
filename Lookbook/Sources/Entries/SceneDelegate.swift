//
//  SceneDelegate.swift
//  Lookbook
//
//  Created by Doyoung on 5/9/24.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let assembler = Assembler([
        CoreServiceAssembly(),
        DomainAssembly(),
        ViewControllerAssembly(),
    ])
   
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let todayViewController = assembler.resolver.resolve(TodayViewController.self) else {
            fatalError("Today View Controller is not registered")
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        let naviationViewController = UINavigationController(rootViewController: todayViewController)
        window?.rootViewController = naviationViewController
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) {  }
    func sceneWillResignActive(_ scene: UIScene) {  }
    func sceneWillEnterForeground(_ scene: UIScene) {  }
    func sceneDidEnterBackground(_ scene: UIScene) {  }
}
