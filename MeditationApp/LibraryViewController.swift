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
        view.backgroundColor = UIColor.background
        
        let backgroundImageView = UIImageView(image: UIImage(named: "library_colour"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // Настроим констрейнты для фона
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        title = "Медитации"
        
        // Приветствие и вопрос
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome, Username!"
        welcomeLabel.font = .systemFont(ofSize: 30, weight: .bold)
        welcomeLabel.textColor = .white
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)

        let feelingLabel = UILabel()
        feelingLabel.text = "How are you feeling today?"
        feelingLabel.font = .systemFont(ofSize: 20, weight: .regular)
        feelingLabel.textColor = .white
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feelingLabel)

        // Позиционируем элементы на экране с помощью Auto Layout
        NSLayoutConstraint.activate([
            // Для welcomeLabel
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Для feelingLabel
            feelingLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            feelingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feelingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Настройка таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MeditationCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Констрейнты для таблицы (чтобы она начиналась ниже приветственного текста)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 20), // Сместим таблицу ниже
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

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
            Meditation(title: "Breathe", duration: "20 мин", image: "breathe"),
            Meditation(title: "Wake up", duration: "10 мин", image: "wake_up"),
            Meditation(title: "Relax", duration: "15 мин", image: "relax"),
            Meditation(title: "Anxiety", duration: "30 мин", image: "anxiety"),
            Meditation(title: "Gratitude", duration: "30 мин", image: "gratitude"),
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
