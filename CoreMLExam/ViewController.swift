//
//  ViewController.swift
//  CoreMLExam
//
//  Created by KimMinKu on 2018. 7. 25..
//  Copyright © 2018년 KimMinKu. All rights reserved.
//

import UIKit

// MARK: - Overrides
class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictLabel: UILabel!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.predictLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - Actions
extension ViewController {
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        self.showCamera()
    }
    
    @IBAction func openAlbum(_ sender: UIBarButtonItem) {
        self.showAlbum()
    }
}

// MARK: - Functions
extension ViewController {
    func showCamera() {
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            self.predictLabel.text = "Not Image Data!"
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.imageView.image = image
        // TODO: - set Image Label
        self.dismiss(animated: true, completion: nil)
    }
}

