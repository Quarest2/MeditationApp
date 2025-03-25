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
    var isPlaying: Bool = false        // флаг, идёт ли воспроизведение
    var audioStartTime: Date? = nil    // время начала воспроизведения
    var timer: Timer?                  // таймер для обновления времени
    var timeLabel: UILabel!            // лейбл для отображения времени
    var titleLabel: UILabel!           // лейбл для отображения названия медитации

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMeditations()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error)")
        }
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
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 800),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        title = "Медитации"
        
        // Приветствие и вопрос
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome, " + (UserDefaults.standard.string(forKey: "nickname") ?? "Username") + "!"
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

        // Настройка мини-плеера
        miniPlayerView = UIView()
        miniPlayerView.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.8) // Полупрозрачный фон
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false // Включаем Auto Layout
        view.addSubview(miniPlayerView)

        NSLayoutConstraint.activate([
            miniPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miniPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), // Safe area
            miniPlayerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        miniPlayButton = UIButton()
        miniPlayButton.setTitle("Play", for: .normal)
        miniPlayButton.setTitleColor(.black, for: .normal)
        miniPlayButton.frame = CGRect(x: 16, y: 10, width: 40, height: 40)
        miniPlayButton.addTarget(self, action: #selector(miniPlayButtonTapped), for: .touchUpInside)
        miniPlayerView.addSubview(miniPlayButton)
        
        // Добавляем лейблы для времени и названия
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        miniPlayerView.addSubview(titleLabel)
        
        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .black
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        miniPlayerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: miniPlayButton.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            timeLabel.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor)
        ])

        
        // Настройка таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MeditationCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Констрейнты для таблицы (чтобы она не перекрывала мини-плеер)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: miniPlayerView.topAnchor) // Таблица заканчивается выше мини-плеера
        ])
    }
    
    @objc private func miniPlayButtonTapped() {
        // Логика нажатия на мини плеер
        if isPlaying {
            audioPlayer?.pause()
            miniPlayButton.setTitle("Play", for: .normal)
            isPlaying = false
            timer?.invalidate() // Останавливаем таймер
        } else {
            audioPlayer?.play()
            miniPlayButton.setTitle("Pause", for: .normal)
            isPlaying = true
            
            // Запускаем таймер для обновления времени
            startTimer()
        }
    }
    
    private func startTimer() {
        // Обновляем время каждую секунду
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        guard let player = audioPlayer else { return }
        
        let elapsedTime = Int(player.currentTime)
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
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
            Meditation(title: "Wake up", duration: "4:47 мин", image: "wake_up", audioURL: "wake_up"),
            Meditation(title: "Relax", duration: "10:04 мин", image: "relax", audioURL: "relax_music"),
            Meditation(title: "Anxiety", duration: "5:33 мин", image: "anxiety", audioURL: "anxiety_music"),
            Meditation(title: "Gratitude", duration: "6:52 мин", image: "gratitude", audioURL: "gratitude_music"),
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
        
        // Если аудио уже проигрывается - ставим на паузу
        if isPlaying {
            audioPlayer?.pause()

            // Считаем, сколько секунд прошло
            let elapsedSeconds = Int(Date().timeIntervalSince(audioStartTime ?? Date()))

            // Читаем текущее значение из UserDefaults
            let oldValue = UserDefaults.standard.integer(forKey: "totalMeditationSeconds")

            // Сохраняем новое значение
            UserDefaults.standard.set(oldValue + elapsedSeconds, forKey: "totalMeditationSeconds")

            // Меняем кнопку на Play (в миниплеере)
            miniPlayButton.setTitle("Play", for: .normal)

            // Меняем флаг
            isPlaying = false

            // Останавливаем таймер
            timer?.invalidate()

        } else {
            // Ищем локальный файл
            if let audioURL = meditation.audioURL,
               let url = Bundle.main.url(forResource: audioURL, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()

                    // Запоминаем время старта
                    audioStartTime = Date()

                    // Меняем кнопку на Pause (в миниплеере)
                    miniPlayButton.setTitle("Pause", for: .normal)

                    // Устанавливаем текущую медитацию и флаг
                    currentMeditation = meditation
                    isPlaying = true
                    
                    // Показываем мини плеер
                    miniPlayerView.isHidden = false
                    
                    // Обновляем название медитации
                    titleLabel.text = meditation.title
                    
                    // Запускаем таймер для обновления времени
                    startTimer()

                } catch {
                    print("Ошибка воспроизведения: \(error)")
                }
            } else {
                print("Неверный URL для аудио.")
            }
        }
    }


    // MARK: - AddMeditationDelegate
    func didAddMeditation(_ meditation: Meditation) {
        meditations.append(meditation) // Добавляем новую медитацию
        tableView.reloadData() // Обновляем таблицу
    }
}
