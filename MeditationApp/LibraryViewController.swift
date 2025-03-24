//
//  LibraryViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit
import AVFoundation

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddMeditationDelegate {

    var meditations: [Meditation] = []
    let tableView = UITableView()
    var currentMeditation: Meditation?
    var miniPlayerView: UIView!
    var miniPlayButton: UIButton!
    var audioPlayer: AVAudioPlayer?

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
            tableView.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 20),
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
        
        // Мини плеер внизу экрана
        miniPlayerView = UIView()
        miniPlayerView.backgroundColor = .systemGray5
        miniPlayerView.frame = CGRect(x: 0, y: view.frame.height - 60, width: view.frame.width, height: 60)
        miniPlayerView.layer.cornerRadius = 8
        view.addSubview(miniPlayerView)

        miniPlayButton = UIButton()
        miniPlayButton.setTitle("Play", for: .normal)
        miniPlayButton.setTitleColor(.black, for: .normal)
        miniPlayButton.frame = CGRect(x: 16, y: 10, width: 40, height: 40)
        miniPlayButton.addTarget(self, action: #selector(miniPlayButtonTapped), for: .touchUpInside)
        miniPlayerView.addSubview(miniPlayButton)
    }
    
    @objc private func miniPlayButtonTapped() {
        guard let currentMeditation = currentMeditation else { return }

        // Открываем полный экран плеера
        let playerVC = PlayerViewController()
        playerVC.meditation = currentMeditation
        navigationController?.pushViewController(playerVC, animated: true)
    }

    @objc private func addMeditationButtonTapped() {
        // Переход на экран добавления медитации
        let addMeditationVC = AddMeditationViewController()
        addMeditationVC.delegate = self // Устанавливаем делегат
        navigationController?.pushViewController(addMeditationVC, animated: true)
    }

    private func loadMeditations() {
        meditations = [
            Meditation(title: "Breathe", duration: "4:28 мин", image: "breathe", audioURL: "breathe_music"),
            Meditation(title: "Wake up", duration: "1:30 мин", image: "wake_up", audioURL: "https://music.apple.com/us/album/rain-and-music/1642284026?i=1642284027"),
            Meditation(title: "Relax", duration: "1:30 мин", image: "relax", audioURL: "https://music.apple.com/us/album/the-sound-of-harmony/1291357067?i=1291357631"),
            Meditation(title: "Anxiety", duration: "1:30 мин", image: "anxiety", audioURL: "https://music.apple.com/us/album/flowing-energy/1642284026?i=1642284036"),
            Meditation(title: "Gratitude", duration: "1:30 мин", image: "gratitude", audioURL: "https://music.apple.com/us/album/indescribable-emotions-nature/1642284026?i=1642284037"),
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
        let meditation = meditations[indexPath.row]
        currentMeditation = meditation

        
        if let audioURL = meditation.audioURL, let url = Bundle.main.url(forResource: audioURL, withExtension: "mp3") {
            // Загружаем и воспроизводим аудио с помощью AVAudioPlayer
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play() // Запуск воспроизведения
                miniPlayButton.setTitle("Pause", for: .normal) // Кнопка будет показывать "Pause"
            } catch {
                print("Ошибка воспроизведения: \(error)")
            }
        } else {
            print("Неверный URL для аудио.")
        }
    }

    // MARK: - AddMeditationDelegate
    func didAddMeditation(_ meditation: Meditation) {
        meditations.append(meditation) // Добавляем новую медитацию
        tableView.reloadData() // Обновляем таблицу
    }
}
