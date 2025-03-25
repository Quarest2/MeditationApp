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
    
    private var selectedImage: UIImage?
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupUI()
        setupGestures()
    }
            
    private func setupBackButton() {
        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem = backButton
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
                self.navigationController?.popViewController(animated: true)
            })
            
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(titleLabel)
        
        // Name TextField
        nameTextField.placeholder = "Название медитации"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)
        
        // Duration Picker
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.minuteInterval = 1
        durationPicker.countDownDuration = 300 // 5 минут по умолчанию
        contentView.addSubview(durationPicker)
        
        // Image Button
        imageButton.setTitle("Выбрать изображение", for: .normal)
        imageButton.setTitleColor(.systemBlue, for: .normal)
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = UIColor.systemBlue.cgColor
        imageButton.layer.cornerRadius = 8
        contentView.addSubview(imageButton)
        
        // Audio Button
        audioButton.setTitle("Выбрать аудиофайл", for: .normal)
        audioButton.setTitleColor(.systemBlue, for: .normal)
        audioButton.layer.borderWidth = 1
        audioButton.layer.borderColor = UIColor.systemBlue.cgColor
        audioButton.layer.cornerRadius = 8
        contentView.addSubview(audioButton)
        
        // Save Button
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        contentView.addSubview(saveButton)
        
        // Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        durationPicker.translatesAutoresizingMaskIntoConstraints = false
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            durationPicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            durationPicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageButton.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: 30),
            imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageButton.heightAnchor.constraint(equalToConstant: 50),
            
            audioButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 20),
            audioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            audioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            audioButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupGestures() {
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        audioButton.addTarget(self, action: #selector(selectAudio), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveMeditation), for: .touchUpInside)
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
