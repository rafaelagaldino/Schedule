//
//  ImagePicker.swift
//  Schedule
//
//  Created by Rafaela Galdino on 24/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

enum OptionsMenu {
    case camera
    case biblioteca
}

protocol ImagePickerSelectedPhoto {
    func imagePickerSelectedPhoto(_ photo: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: ImagePickerSelectedPhoto?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[.originalImage] as! UIImage
        delegate?.imagePickerSelectedPhoto(photo)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func optionsMenu(completion: @escaping(_ opcao: OptionsMenu) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (acao) in
            completion(.camera)
        }
        menu.addAction(camera)
        
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            completion(.biblioteca)
        }
        menu.addAction(biblioteca)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        return menu
    }
}
