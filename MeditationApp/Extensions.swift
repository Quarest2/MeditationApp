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
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
