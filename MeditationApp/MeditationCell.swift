//
//  MeditationCell.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class MeditationCell: UITableViewCell {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let durationLabel = UILabel()
    private let meditationImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // Контейнер
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)

        // Изображение
        meditationImageView.contentMode = .scaleAspectFill
        meditationImageView.layer.cornerRadius = 8
        meditationImageView.clipsToBounds = true
        containerView.addSubview(meditationImageView)

        // Заголовок
        titleLabel.font = .subtitle
        titleLabel.textColor = .textPrimary
        containerView.addSubview(titleLabel)

        // Длительность
        durationLabel.font = .body
        durationLabel.textColor = .textSecondary
        containerView.addSubview(durationLabel)

        // Констрейнты
        containerView.translatesAutoresizingMaskIntoConstraints = false
        meditationImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            meditationImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            meditationImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            meditationImageView.widthAnchor.constraint(equalToConstant: 60),
            meditationImageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: meditationImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            durationLabel.leadingAnchor.constraint(equalTo: meditationImageView.trailingAnchor, constant: 16),
            durationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            durationLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with meditation: Meditation) {
        titleLabel.text = meditation.title
        durationLabel.text = meditation.duration
        meditationImageView.image = UIImage(named: meditation.image)
    }

    // Анимация нажатия
    func animateTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = .identity
            }
        })
    }
}
