//
//  PlayerViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//
import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    var meditation: Meditation?
    var audioPlayer: AVAudioPlayer?
    let backgroundImageView = UIImageView()
    let playButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //setupAudio()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Настройка фонового изображения
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: meditation?.image ?? "")
        view.addSubview(backgroundImageView)

        // Настройка кнопки воспроизведения
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .systemBlue
        playButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)
    }

//    private func setupAudio() {
//        guard let audioURL = Bundle.main.url(forResource: meditation?.audioURL, withExtension: nil) else { return }
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
//            audioPlayer?.prepareToPlay()
//        } catch {
//            print("Ошибка загрузки аудио: \(error)")
//        }
//    }

    @objc private func playButtonTapped() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            playButton.setTitle("Play", for: .normal)
        } else {
            audioPlayer?.play()
            playButton.setTitle("Pause", for: .normal)
        }
    }
}
