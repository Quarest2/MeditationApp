//
//  AppDelegate.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Настройка окна приложения
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        // Создание начального экрана (библиотека медитаций)
        let libraryVC = LibraryViewController()
        let navigationController = UINavigationController(rootViewController: libraryVC)

        // Установка NavigationController как корневого контроллера
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        // Дополнительные настройки (например, настройка внешнего вида NavigationBar)
        setupAppearance()

        return true
    }

    private func setupAppearance() {
        // Настройка внешнего вида NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    // MARK: - Жизненный цикл приложения

    func applicationWillResignActive(_ application: UIApplication) {
        // Приложение скоро перейдет в фоновый режим (например, при входящем звонке)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Приложение перешло в фоновый режим
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Приложение скоро вернется на передний план
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Приложение снова активно
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Приложение завершает работу
    }
}
