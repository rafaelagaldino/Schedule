//
//  ViewController.swift
//  Schedule
//
//  Created by Rafaela Galdino on 06/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import CoreData

class RegisterUserViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let container = UIView()
    private var imageView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
    private var photoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
    private var photoButton = UIButton()
    
    private let stackView = UIStackView()
    private let name = CustomTextField()
    private let nickName = CustomTextField()
    private let cpf = CustomTextField()
    private let email = CustomTextField()
    private let phoneNumber = CustomTextField()
    private let saveButton = UIButton()
    
    private var frameToScroll: CGRect?
    private var scrollTo: CGFloat = 0
    
    let imagePicker = ImagePicker()

    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
        setup()
        setupAppearance()
        registerObservers()
        setupCancelTap()
        addScrollView()
        addView()
        addImageView()
        addPhotoImage()
        addStackView()
        addTextField()
        addButton()
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setup() {
        imagePicker.delegate = self
    }
    
    func setupAppearance() {
        title = "Cadastrar contato"
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func setupCancelTap() {
        let cancelTap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        cancelTap.cancelsTouchesInView = false
        view.addGestureRecognizer(cancelTap)
    }
    
    func addScrollView() {
        view.addSubview(scrollView)
        scrollView.anchorFillSuperview()
    }

    func addView() {
        container.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
        scrollView.addSubview(container)
        container.anchor(
            top: (scrollView.topAnchor, 0.0),
            leading: (view.leadingAnchor, 0.0),
            trailing: (view.trailingAnchor, 0.0),
            bottom: (view.bottomAnchor, 0.0)
        )
    }
    
    func addImageView() {
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
        container.addSubview(imageView)
        imageView.anchor(
            centerX: (container.centerXAnchor, 0.0),
            top: (container.topAnchor, 40.0),
            width: 125.0,
            height: 125.0
        )
    }
    
    func addPhotoImage() {
        photoImage.image = UIImage(named: "eu")
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius =  photoImage.frame.width / 2
        photoImage.contentMode = .scaleAspectFill
        imageView.addSubview(photoImage)
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(onPhotoClickEvent))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(photoTap)
    }
    
    @objc func onPhotoClickEvent() {
        let menu = ImagePicker().optionsMenu { option in
            self.showMultimedia(option)
        }
        present(menu, animated: true, completion: nil)
    }
    
    func addStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        container.addSubview(stackView)
        stackView.anchor(
            top: (imageView.bottomAnchor, 30.0),
            leading: (container.leadingAnchor, 30.0),
            trailing: (container.trailingAnchor, 30.0)
        )
    }
    
    func addTextField() {
        configTextField(
            name,
            placeholder: "Nome",
            mask: .none,
            keyboardType: .default
        )

        configTextField(
            nickName,
            placeholder: "Apelido",
            mask: .none,
            keyboardType: .default
        )

        configTextField(
            phoneNumber,
            placeholder: "Telefone",
            mask: .phone,
            keyboardType: .decimalPad,
            errorMessage: "Informe o telefone"
        )

        configTextField(
            email,
            placeholder: "E-mail",
            mask: .none,
            keyboardType: .default
        )
    }
    
    func addButton() {
        saveButton.setTitle("Salvar", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        saveButton.layer.cornerRadius = 20
        container.addSubview(saveButton)
        saveButton.anchor(
            top: (stackView.bottomAnchor, 50),
            leading: (container.leadingAnchor, 30),
            trailing: (container.trailingAnchor, 30),
            bottom: (scrollView.bottomAnchor, 30),
            height: 44
        )
    }
    
    func configTextField(_ textField: CustomTextField, placeholder: String, mask: StringMaskr, keyboardType: UIKeyboardType, maximumCharacters: Int? = nil, errorMessage: String? = nil) {
        textField.placeholder = placeholder
        textField.stringMask = mask
        textField.keyboardType = keyboardType
        textField.errorText = errorMessage
        textField.customDelegate = self
        
        if let max = maximumCharacters {
            textField.maximumCharacters = max
        }
        stackView.addArrangedSubview(textField)
    }

    func showMultimedia(_ option: OptionsMenu) {
        let multimedia = UIImagePickerController()
        multimedia.delegate = imagePicker
        
        if option == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            multimedia.sourceType = .camera
        } else {
            multimedia.sourceType = .photoLibrary
        }
        self.present(multimedia, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        if let frameToScroll = frameToScroll {
            scrollTo = frameToScroll.origin.y + frameToScroll.height - self.stackView.frame.height
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       scrollView.contentInset = UIEdgeInsets.zero
    }
}

extension RegisterUserViewController: CustomTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: CustomTextField) {
        frameToScroll = textField.frame
        frameToScroll?.origin.y += stackView.frame.minY
    }
    
    func textFieldShouldReturn(_ textField: CustomTextField) -> Bool {
        validate(textField: textField)
        return true
    }
    
    private func validate(textField: CustomTextField) {
        if textField.isEqual(phoneNumber) {
            textField.isError = textField.text?.count ?? 0 == 15
        }
    }
}

extension RegisterUserViewController: ImagePickerSelectedPhoto {
    func imagePickerSelectedPhoto(_ photo: UIImage) {
        photoImage.image = photo
    }
    
    
}
