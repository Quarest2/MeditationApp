//
//  AddMeditationViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit

class AddMeditationViewController: UIViewController {

    weak var delegate: AddMeditationDelegate? // Ссылка на делегат

    let titleTextField = UITextField()
    let durationTextField = UITextField()
    let imageTextField = UITextField()
    let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Добавить медитацию"

        // Поле для названия медитации
        titleTextField.placeholder = "Название медитации"
        titleTextField.borderStyle = .roundedRect
        titleTextField.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
        view.addSubview(titleTextField)

        // Поле для длительности медитации
        durationTextField.placeholder = "Длительность (например, 10 мин)"
        durationTextField.borderStyle = .roundedRect
        durationTextField.frame = CGRect(x: 20, y: 160, width: 300, height: 40)
        view.addSubview(durationTextField)

        // Поле для названия изображения
        imageTextField.placeholder = "Название изображения (например, morning.jpg)"
        imageTextField.borderStyle = .roundedRect
        imageTextField.frame = CGRect(x: 20, y: 220, width: 300, height: 40)
        view.addSubview(imageTextField)

        // Кнопка сохранения
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.frame = CGRect(x: 20, y: 300, width: 300, height: 50)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text,
              let duration = durationTextField.text,
              let image = imageTextField.text else { return }

        // Создаем новую медитацию
        // let newMeditation = Meditation(title: title, duration: duration, image: image)

        // Вызываем метод делегата
        //delegate?.didAddMeditation(newMeditation)

        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
}
