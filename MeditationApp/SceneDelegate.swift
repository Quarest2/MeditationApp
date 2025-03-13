//
//  SceneDelegate.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        // Создаем экраны
        let libraryVC = LibraryViewController()
        let statisticsVC = StatisticsViewController()
        let settingsVC = SettingsViewController()

        // Настраиваем таб-бар
        libraryVC.tabBarItem = UITabBarItem(title: "Медитации", image: UIImage(systemName: "house"), tag: 0)
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "chart.bar"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 2)

        // Создаем таб-бар контроллер
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [libraryVC, statisticsVC, settingsVC]

        // Настройка внешнего вида таб-бара
        setupTabBarAppearance()

        // Устанавливаем таб-бар как корневой контроллер
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        // Цвет текста и иконок
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]

        // Применяем настройки
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
