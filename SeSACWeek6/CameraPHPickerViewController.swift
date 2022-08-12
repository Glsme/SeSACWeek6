//
//  CameraPHPickerViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/12.
//

import UIKit
import PhotosUI

class CameraPHPickerViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func phPickerButtonClicked(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos, .livePhotos])
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        
        self.present(phPicker, animated: true)
    }
}

extension CameraPHPickerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemProvider = results[0].itemProvider
        
        itemProvider.canLoadObject(ofClass: UIImage.self)
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                self.imageView.image = image as? UIImage
            }
        }
        
    }
    
    
}
