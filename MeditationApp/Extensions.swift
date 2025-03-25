//
//  Extensions.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

extension UIColor {
    static let primary = UIColor(hex: "#4A90E2") // Пример цвета из Figma
    static let background = UIColor(hex: "#F5F5F5")
    static let textPrimary = UIColor(hex: "#333333")
    static let textSecondary = UIColor(hex: "#666666")
}

extension UIFont {
    static let title = UIFont.systemFont(ofSize: 24, weight: .bold)
    static let subtitle = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
}

extension UIColor {
    convenience init(hex: String) {
        let hexInt = Int(hex, radix: 16) ?? 0
        let red = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
