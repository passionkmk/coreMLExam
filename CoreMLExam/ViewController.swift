//
//  ViewController.swift
//  CoreMLExam
//
//  Created by KimMinKu on 2018. 7. 25..
//  Copyright © 2018년 KimMinKu. All rights reserved.
//

import UIKit
import CoreML
import Vision

// MARK: - Overrides
class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictLabel: UILabel!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.predictLabel.isHidden = false
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
    func detecScene(image: UIImage) {
        self.predictLabel.text = "detecting scene...."
        
        // 1. 모델을 생성
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("can't load Places ML model")
        }
        
        // 2. 요청을 생성
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard error == nil else {
                fatalError(error.debugDescription)
            }
            
            // 모델에 따른 Observation을 변환하여 사용
            // MobileNet는 Classification Model (분류, 라벨링)
            guard let result = request.results as? [VNClassificationObservation],
                let topResult = result.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // confidence 정확도(0~1), identifier 라벨링
            DispatchQueue.main.async {
                self.predictLabel.text = "\(Int(topResult.confidence * 100))% \(topResult.identifier)"
            }
        }
        
        // 3. 핸들러 생성성
        // VNImageRequestHandler는 Vision 프레임워크의 표준 요청 핸들러
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
        
        // 4. 작업 수행 (스레드에 할당)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch let error {
                print(error)
            }
        }
    }
    
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

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            self.predictLabel.text = "Not Image Data!"
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.predictLabel.text = nil
        self.imageView.image = image
        self.detecScene(image: image)
        self.dismiss(animated: true, completion: nil)
    }
}

