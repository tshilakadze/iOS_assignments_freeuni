//
//  SceneDelegate.swift
//  phone-app
//
//  Created by Tsotne Shilakadze on 17.11.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func tabBarController() -> UITabBarController{
        let my_controller = UITabBarController()
        let favourites = UIViewController()
        let recents = UIViewController()
        let contacts = UIViewController()
        let keypad = ViewController()
        let voicemail = UIViewController()
        favourites.view.backgroundColor = .systemBackground
        favourites.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star.fill"), selectedImage: UIImage(systemName: "star.fill"))
        recents.view.backgroundColor = .systemBackground
        recents.tabBarItem = UITabBarItem(title: "Recents", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
        contacts.view.backgroundColor = .systemBackground
        contacts.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        keypad.view.backgroundColor = .systemBackground
        keypad.tabBarItem = UITabBarItem(title: "Keypad", image: UIImage(systemName: "circle.grid.3x3.circle"), selectedImage: UIImage(systemName: "circle.grid.3x3.fill"))
        voicemail.view.backgroundColor = .systemBackground
        voicemail.tabBarItem = UITabBarItem(title: "Voicemail", image: UIImage(systemName: "phone.bubble"), selectedImage: UIImage(systemName: "phone.bubble.fill"))
        
        my_controller.viewControllers = [favourites, recents, contacts, keypad, voicemail]
        my_controller.selectedIndex = 3
        return my_controller
    }

    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

