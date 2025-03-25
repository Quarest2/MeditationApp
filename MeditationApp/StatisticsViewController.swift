//  StatisticsViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let progressRing = UIView()
    private let timeLabel = UILabel()
    private let sessionsLabel = UILabel()
    private let streakLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatistics()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupTitle()
        setupProgressRing()
        setupStatsLabels()
    }
    
    private func setupTitle() {
        titleLabel.text = "Статистика"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupProgressRing() {
        progressRing.layer.cornerRadius = 60
        progressRing.layer.borderWidth = 8
        progressRing.layer.borderColor = UIColor.systemTeal.cgColor
        view.addSubview(progressRing)
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
        timeLabel.textAlignment = .center
        progressRing.addSubview(timeLabel)
        
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressRing.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressRing.widthAnchor.constraint(equalToConstant: 120),
            progressRing.heightAnchor.constraint(equalToConstant: 120),
            
            timeLabel.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: progressRing.centerYAnchor)
        ])
    }
    
    private func setupStatsLabels() {
        let statsStack = UIStackView()
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 10
        
        sessionsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        sessionsLabel.textAlignment = .center
        
        streakLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        streakLabel.textAlignment = .center
        
        let sessionsView = createStatBox(title: "Сеансы", valueLabel: sessionsLabel)
        let streakView = createStatBox(title: "Дней подряд", valueLabel: streakLabel)
        
        statsStack.addArrangedSubview(sessionsView)
        statsStack.addArrangedSubview(streakView)
        view.addSubview(statsStack)
        
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsStack.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 20),
            statsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createStatBox(title: String, valueLabel: UILabel) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    // MARK: - Data
    private func loadStatistics() {
        let totalSeconds = UserDefaults.standard.integer(forKey: "totalMeditationSeconds")
        let sessions = UserDefaults.standard.integer(forKey: "meditationSessionsCount")
        let streak = UserDefaults.standard.integer(forKey: "meditationStreakDays")
        
        timeLabel.text = formatTime(totalSeconds)
        sessionsLabel.text = "\(sessions)"
        streakLabel.text = "\(streak) 🔥"
        
        updateProgressRing(totalSeconds: totalSeconds)
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateProgressRing(totalSeconds: Int) {
        let maxSeconds = 3600 * 10 // 10 часов = 100%
        let progress = min(Float(totalSeconds) / Float(maxSeconds), 1.0)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 60, y: 60),
            radius: 54,
            startAngle: -CGFloat.pi / 2,
            endAngle: 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2,
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = .round
        
        progressRing.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        progressRing.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "progressAnimation")
    }
}
