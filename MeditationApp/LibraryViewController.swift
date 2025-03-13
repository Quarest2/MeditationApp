//
//  LibraryViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddMeditationDelegate {

    var meditations: [Meditation] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMeditations()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Медитации"

        // Настройка таблицы
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MeditationCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Кнопка добавления медитации
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, // Иконка "+"
            target: self,
            action: #selector(addMeditationButtonTapped)
        )
        addButton.tintColor = .systemBlue // Цвет иконки
        navigationItem.rightBarButtonItem = addButton // Размещаем в правом верхнем углу
    }

    @objc private func addMeditationButtonTapped() {
        // Переход на экран добавления медитации
        let addMeditationVC = AddMeditationViewController()
        addMeditationVC.delegate = self // Устанавливаем делегат
        navigationController?.pushViewController(addMeditationVC, animated: true)
    }

    private func loadMeditations() {
        meditations = [
            Meditation(title: "Утренняя медитация", duration: "10 мин", image: "morning.jpg"),
            Meditation(title: "Вечерняя медитация", duration: "15 мин", image: "evening.jpg")
        ]
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meditations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MeditationCell
        cell.configure(with: meditations[indexPath.row])
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Анимация нажатия на ячейку
        if let cell = tableView.cellForRow(at: indexPath) as? MeditationCell {
            cell.animateTap()
        }

        // Переход на экран проигрывателя
        let playerVC = PlayerViewController()
        playerVC.meditation = meditations[indexPath.row]
        navigationController?.pushViewController(playerVC, animated: true)
    }

    // MARK: - AddMeditationDelegate
    func didAddMeditation(_ meditation: Meditation) {
        meditations.append(meditation) // Добавляем новую медитацию
        tableView.reloadData() // Обновляем таблицу
    }
}
