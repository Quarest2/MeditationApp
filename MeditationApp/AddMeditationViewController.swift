//
//  AddMeditationViewController.swift
//  MeditationApp
//
//  Created by Аскар Ахметьянов on 13.03.2025.
//

import UIKit
import AVFoundation
import UniformTypeIdentifiers

class AddMeditationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let durationPicker = UIDatePicker()
    private let imageButton = UIButton()
    private let audioButton = UIButton()
    private let saveButton = UIButton()
    private let backButton = UIButton()
    
    private var selectedImage: UIImage?
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Новая медитация"
        
        // ScrollView setup
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Title Label
        titleLabel.text = "Добавить медитацию"
        titleLabel.font = UIFont.systemFont(ofSize: Constants.addFontOffSize, weight: .bold)
        contentView.addSubview(titleLabel)
        
        // Name TextField
        nameTextField.placeholder = "Название медитации"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)
        
        // Duration Picker
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.minuteInterval = Constants.minute
        durationPicker.countDownDuration = Constants.fiveMinutes // 5 минут по умолчанию
        contentView.addSubview(durationPicker)
        
        // Image Button
        imageButton.setTitle("Выбрать изображение", for: .normal)
        imageButton.setTitleColor(.systemBlue, for: .normal)
        imageButton.layer.borderWidth = Constants.buttonBorderWidth
        imageButton.layer.borderColor = UIColor.systemBlue.cgColor
        imageButton.layer.cornerRadius = Constants.imageButtonCornerRadius
        contentView.addSubview(imageButton)
        
        // Audio Button
        audioButton.setTitle("Выбрать аудиофайл", for: .normal)
        audioButton.setTitleColor(.systemBlue, for: .normal)
        audioButton.layer.borderWidth = Constants.buttonBorderWidth
        audioButton.layer.borderColor = UIColor.systemBlue.cgColor
        audioButton.layer.cornerRadius = Constants.audioButtonCornerRadius
        contentView.addSubview(audioButton)
        
        // Save Button
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Constants.saveButtonCornerRadius
        contentView.addSubview(saveButton)
        
        // Back Button
        saveButton.setTitle("Назад", for: .normal)
        saveButton.backgroundColor = .systemRed
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Constants.saveButtonCornerRadius
        contentView.addSubview(backButton)
        
        // Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        durationPicker.translatesAutoresizingMaskIntoConstraints = false
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.titleConstraint),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.nameTextTopConstraing),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.nameTextLeadingConstraint),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.nameTextTrailingConstraint),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.nameTextHeightConstraint),
            
            durationPicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.durationTopConstraint),
            durationPicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageButton.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: Constants.imageTopConstraint),
            imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageLeadingConstraint),
            imageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.imageTrailingConstraint),
            imageButton.heightAnchor.constraint(equalToConstant: Constants.imageHeightConstraint),
            
            audioButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: Constants.audioTopConstraint),
            audioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.audioLeadingConstraint),
            audioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.audioTrailingConstraint),
            audioButton.heightAnchor.constraint(equalToConstant: Constants.audioHeightConstraint),
            
            saveButton.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: Constants.saveTopConstraint),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.saveLeadingConstraint),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.saveTrailingConstraint),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.saveHeightConstraint),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.saveBottomConstraint),
            
            backButton.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: Constants.backTopConstraint),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.backLeadingConstraint),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.backTrailingConstraint),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backHeightConstraint),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.backBottomConstraint)
        ])
    }
    
    private func setupGestures() {
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        audioButton.addTarget(self, action: #selector(selectAudio), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveMeditation), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        
        if nameTextField.text?.isEmpty == false || selectedImage != nil || audioURL != nil {
            // Есть несохраненные данные
            let alert = UIAlertController(
                title: "Выйти без сохранения?",
                message: "Все изменения будут потеряны",
                preferredStyle: .alert
            )
        
            alert.addAction(UIAlertAction(title: "Остаться", style: .cancel))
            alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { _ in
                let libraryVC = LibraryViewController()
                let navigationController = UINavigationController(rootViewController: libraryVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            })
        
            present(alert, animated: true)
        } else {
            let libraryVC = LibraryViewController()
            let navigationController = UINavigationController(rootViewController: libraryVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }
      
    }
    
    // MARK: - Actions
    @objc private func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc private func selectAudio() {
        if #available(iOS 14.0, *) {
            // Новый API для iOS 14+
            let supportedTypes: [UTType] = [.audio]
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            // Старый API для обратной совместимости
            let legacyTypes = ["public.audio"]
            let picker = UIDocumentPickerViewController(documentTypes: legacyTypes, in: .import)
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    @objc private func saveMeditation() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите название медитации")
            return
        }
        
        guard selectedImage != nil else {
            showAlert(title: "Ошибка", message: "Выберите изображение")
            return
        }
        
        guard audioURL != nil else {
            showAlert(title: "Ошибка", message: "Выберите аудиофайл")
            return
        }
        
        let duration = Int(durationPicker.countDownDuration)
        
        // Сохранение медитации
        var newMeditation = CustomMeditation(
            name: name,
            duration: duration,
            image: selectedImage!,
            audioURL: audioURL!
        )
        
        saveCustomMeditation(meditation: &newMeditation)
        showAlert(title: "Успешно", message: "Медитация сохранена") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Save Logic
    private func saveCustomMeditation(meditation: inout CustomMeditation) {
        // 1. Сохраняем изображение
        if let imageData = meditation.image.pngData() {
            let imageName = UUID().uuidString + ".png"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            do {
                try imageData.write(to: imagePath)
                meditation.imagePath = imageName
            } catch {
                print("Ошибка сохранения изображения: \(error)")
            }
        }
        
        // 2. Копируем аудиофайл
        let audioName = UUID().uuidString + ".\(meditation.audioURL.pathExtension)"
        let audioPath = getDocumentsDirectory().appendingPathComponent(audioName)
        
        do {
            try FileManager.default.copyItem(at: meditation.audioURL, to: audioPath)
            meditation.audioPath = audioName
        } catch {
            print("Ошибка копирования аудио: \(error)")
        }
        
        // 3. Сохраняем метаданные в UserDefaults
        var savedMeditations = UserDefaults.standard.array(forKey: "customMeditations") as? [[String: Any]] ?? []
        
        let meditationData: [String: Any] = [
            "name": meditation.name,
            "duration": meditation.duration,
            "imagePath": meditation.imagePath ?? "",
            "audioPath": meditation.audioPath ?? ""
        ]
        
        savedMeditations.append(meditationData)
        UserDefaults.standard.set(savedMeditations, forKey: "customMeditations")
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Helper
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddMeditationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            imageButton.setTitle("Изображение выбрано", for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imageButton.setTitle("Изображение выбрано", for: .normal)
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension AddMeditationViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // Проверяем расширение файла
        let fileExtension = url.pathExtension.lowercased()
        guard ["mp3", "m4a", "wav", "aac"].contains(fileExtension) else {
            showAlert(title: "Ошибка", message: "Поддерживаются только аудиофайлы (MP3, M4A, WAV, AAC)")
            return
        }
        
        audioURL = url
        audioButton.setTitle("Аудио выбрано: \(url.lastPathComponent)", for: .normal)
    }
}

// MARK: - UITextFieldDelegate
extension AddMeditationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CustomMeditation Model
struct CustomMeditation {
    var name: String
    var duration: Int // в секундах
    var image: UIImage
    var audioURL: URL
    var imagePath: String?
    var audioPath: String?
}
