//
//  CustomTextField.swift
//  Schedule
//
//  Created by Rafaela Galdino on 06/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CustomTextFieldDelegate {
    func textFieldShouldReturn(_ textField: CustomTextField) -> Bool
    func textFieldDidBeginEditing(_ textField: CustomTextField)
}

class CustomTextField: UITextField {
    private var placeholderLabel = UILabel()
    private let errorLabel = UILabel()
    private var placeholderBottomConstraint: NSLayoutConstraint?
    private var line = UIView()
    private var icon = UIButton()
    private var disposeBag = DisposeBag()
        
    open override var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    public var errorText: String? {
        get { return errorLabel.text }
        set { errorLabel.text = newValue }
    }
    
    open var isError: Bool = false {
        didSet {
            showError()
        }
    }
    
    public var stringMask: StringMaskr?
    public var maximumCharacters: Int = .max

    var customDelegate: CustomTextFieldDelegate?
    open var onIconClick: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        anchor(height: 60.0)
        setupPlaceholderLabel()
        addLine()
        addIconTextField()
        addEvents()
        setupErrorLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupPlaceholderLabel() {
        placeholderLabel.font = self.placeholderLabel.font.withSize(16.0)
        placeholderLabel.textColor = UIColor.gray
        addSubview(placeholderLabel)
        placeholderBottomConstraint = placeholderLabel.anchor(top: (topAnchor, 0.0),
                                leading: (leadingAnchor, 0.0),
                                trailing: (trailingAnchor, 0.0),
                                bottom: (bottomAnchor, 0.0)).bottom
    }
    
    func addLine() {
        line.backgroundColor = UIColor.gray
        addSubview(line)
        line.anchor(leading: (leadingAnchor, 0.0),
                    trailing: (trailingAnchor, 0.0),
                    bottom: (bottomAnchor, 15.0),
                    height: 1
        )
    }

    private func addIconTextField() {
        icon.isHidden = true
        icon.setImage(UIImage(named: "icon-close-rounded")?.withRenderingMode(.alwaysTemplate), for: .normal)
        icon.tintColor = .white
        rightView = icon
        rightViewMode = .always
        
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(onIconClickEvent(_:)))
        iconTap.cancelsTouchesInView = false
        icon.addGestureRecognizer(iconTap)
    }
    
    @objc open func onIconClickEvent(_ sender: UITapGestureRecognizer) {
        onIconClick?()
    }
    
    func addEvents() {
        rx.text.orEmpty.bind { [weak self] _ in
            guard let self = self else { return }
            let textIsEmpty = self.text?.isEmpty ?? false
            self.placeholderBottomConstraint?.isActive = textIsEmpty
            self.placeholderLabel.font = textIsEmpty ? UIFont.systemFont(ofSize: 16.0) : UIFont.boldSystemFont(ofSize: 14)
            self.icon.isHidden = textIsEmpty
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        icon.rx.tap.bind {
            self.text = ""
            self.icon.isHidden = true
            self.placeholderBottomConstraint?.isActive = true
            self.placeholderLabel.font = UIFont.systemFont(ofSize: 16.0)
        }.disposed(by: disposeBag)

        rx.text.orEmpty.map { self.format(with: self.stringMask ?? StringMaskr.none, phone: $0) }.distinctUntilChanged().bind(to: rx.text).disposed(by: disposeBag)
    }
    
    func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addSubview(errorLabel)
        errorLabel.anchor(
            top: (line.bottomAnchor, 2.5),
            leading: (leadingAnchor, 0),
            trailing: (trailingAnchor, 0)
        )
    }
    
    private func showError() {
        errorLabel.rx.observe(String.self, "text").bind { [weak self] text in
            guard let self = self else { return }
            if !(self.text?.isEmpty ?? true) {
                self.errorLabel.isHidden = self.isError
                self.icon.setImage(self.isError ? UIImage(named: "icon-close-rounded")?.withTintColor(UIColor.gray) : UIImage(named: "icon-warning")?.withTintColor(UIColor.red), for: .normal)
                self.line.backgroundColor = self.isError ? UIColor.gray : UIColor.red
                self.placeholderLabel.textColor = self.isError ? UIColor.gray : UIColor.red
                self.textColor = self.isError ? UIColor.gray : UIColor.red
            }
        }.disposed(by: disposeBag)
    }
    
    func format(with stringMask: StringMaskr, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        let mask = stringMask.mask()
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

extension CustomTextField: UITextFieldDelegate {
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        textColor = UIColor.white
        placeholderLabel.textColor = UIColor.white
        line.backgroundColor = UIColor.white
        icon.tintColor = UIColor.white
        errorLabel.isHidden = true
        icon.setImage(UIImage(named: "icon-close-rounded")?.withRenderingMode(.alwaysTemplate), for: .normal)
     
        guard let customTextField = textField as? CustomTextField else { return }
        customDelegate?.textFieldDidBeginEditing(customTextField)

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textColor = UIColor.gray
        placeholderLabel.textColor = UIColor.gray
        line.backgroundColor = UIColor.gray
        icon.tintColor = UIColor.gray
        
        guard let customTextField = textField as? CustomTextField else { return true }
        return customDelegate?.textFieldShouldReturn(customTextField) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= stringMask?.maxLength ?? maximumCharacters
    }
}
