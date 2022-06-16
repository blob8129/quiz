//
//  SceneDelegate.swift
//  Quiz
//
//  Created by Andrey Volobuev on 16/06/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: scene)
        window?.windowScene = scene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}
