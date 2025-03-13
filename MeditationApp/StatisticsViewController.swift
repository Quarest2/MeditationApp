//
//  StatisticsViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Статистика"

        // Пример текста
        let label = UILabel()
        label.text = "Здесь будет статистика"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
