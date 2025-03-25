//  StatisticsViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let progressRing = UIView()
    private let statsStackView = UIStackView()
    private let calendarView = UIView()
    
    private var totalSeconds: Int {
        return UserDefaults.standard.integer(forKey: "totalMeditationSeconds")
    }
    
    private var streakDays: Int {
        return UserDefaults.standard.integer(forKey: "meditationStreakDays")
    }
    
    private var sessionsCount: Int {
        return UserDefaults.standard.integer(forKey: "meditationSessionsCount")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateUI()
        updateStreak()  // Обновляем стрик на старте
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        updateStreak()  // Обновляем стрик при возвращении на экран
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        // Configure ScrollView
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title Label
        titleLabel.text = "Ваша статистика"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        // Progress Ring
        progressRing.layer.cornerRadius = 80
        progressRing.layer.borderWidth = 10
        progressRing.layer.borderColor = UIColor.systemTeal.cgColor
        contentView.addSubview(progressRing)
        
        // Stats Stack View
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 16
        contentView.addSubview(statsStackView)
        
        // Calendar View
        calendarView.backgroundColor = .secondarySystemBackground
        calendarView.layer.cornerRadius = 12
        contentView.addSubview(calendarView)
        
        // Add stat views to stack
        let totalTimeView = createStatView(title: "Общее время", value: formattedTime(totalSeconds))
        let streakView = createStatView(title: "Дней подряд", value: "\(streakDays) 🔥")
        let sessionsView = createStatView(title: "Сеансы", value: "\(sessionsCount)")
        
        statsStackView.addArrangedSubview(totalTimeView)
        statsStackView.addArrangedSubview(streakView)
        statsStackView.addArrangedSubview(sessionsView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Progress Ring
            progressRing.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            progressRing.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressRing.widthAnchor.constraint(equalToConstant: 160),
            progressRing.heightAnchor.constraint(equalToConstant: 160),
            
            // Stats Stack
            statsStackView.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 40),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Calendar View
            calendarView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 150),
            calendarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Helpers
    private func createStatView(title: String, value: String) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        
        valueLabel.text = value
        valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .medium)
        valueLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func updateUI() {
        // Update progress ring animation
        let progress = min(Float(totalSeconds) / 36000.0, 1.0) // 10 hours max for 100%
        animateProgressRing(progress: progress)
    }
    
    private func animateProgressRing(progress: Float) {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 80, y: 80),
            radius: 70,
            startAngle: -CGFloat.pi / 2,
            endAngle: 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2,
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        
        progressRing.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        progressRing.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "progressAnimation")
    }
    
    // MARK: - Streak Update
    private func updateStreak() {
        let lastDate = UserDefaults.standard.object(forKey: "lastMeditationDate") as? Date ?? Date()
        
        // Проверяем, если медитация была вчера
        if Calendar.current.isDateInYesterday(lastDate) {
            // Увеличиваем стрик (если была медитация вчера)
            let streak = UserDefaults.standard.integer(forKey: "meditationStreakDays") + 1
            UserDefaults.standard.set(streak, forKey: "meditationStreakDays")
        } else {
            // Если новая медитация - обнуляем стрик
            UserDefaults.standard.set(1, forKey: "meditationStreakDays")
        }
        
        // Сохраняем дату последней медитации
        UserDefaults.standard.set(Date(), forKey: "lastMeditationDate")
    }
}
