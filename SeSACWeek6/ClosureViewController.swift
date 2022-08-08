//
//  ClosureViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "color picker", message: "ok?", okTitle: "yes") {
            let picker = UIColorPickerViewController()
            self.present(picker, animated: true)
        }
    }
    
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "background change", message: "ok?", okTitle: "yes") {
            self.view.backgroundColor = .gray
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in

            
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
