//
//  ViewController.swift
//  Monkenizer
//
//  Created by Ko Kyaw on 28/11/2021.
//

import UIKit
import Vision
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnMonkenize: UIButton!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var imageOrientation = CGImagePropertyOrientation(.up)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.publisher(for: \.image)
            .map { $0 == nil ? false : true }
            .assign(to: \.isEnabled, on: btnMonkenize)
            .store(in: &subscriptions)
    }
    
    // MARK: - Vision methods
    
    private func setupVision(image: CGImage) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFaceDetectionRequest(request:error:))
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: imageOrientation, options: [:])
        
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch let error as NSError {
            print(error)
            return
        }
    }
    
    private func handleFaceDetectionRequest(request: VNRequest?, error: Error?) {
        if let error = error as NSError? {
            print(error)
            return
        }
        
        guard let image = imageView.image else { return }
        guard let cgImage = image.cgImage else { return }
        
        let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: imageView.frame)
        self.imageView.layer.sublayers = nil
        
        if let results = request?.results as? [VNFaceObservation] {
            for observation in results {
                let faceRect = self.convertUnitToPoint(originalImgRect: imageRect, targetRect: observation.boundingBox)
                
                let monkeyHeadRect = CGRect(
                    x: faceRect.origin.x,
                    y: faceRect.origin.y - 10,
                    width: faceRect.size.width + 40,
                    height: faceRect.size.height + 40
                )
                
                let textLayer = CATextLayer()
                textLayer.string = "🐵"
                textLayer.fontSize = faceRect.width
                textLayer.frame = monkeyHeadRect
                textLayer.contentsScale = UIScreen.main.scale
                
                self.imageView.layer.addSublayer(textLayer)
            }
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction private func onAddBtnTap(_ sender: Any) {
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        imgPickerController.allowsEditing = true
        self.present(imgPickerController, animated: true, completion: nil)
    }
    
    @IBAction private func onMonkenizeTap(_ sender: Any) {
        guard let image = imageView.image else { return }
        imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgImage = image.cgImage else { return }
        setupVision(image: cgImage)
    }
    
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.imageView.layer.sublayers = nil
        self.imageView.image = img
        self.dismiss(animated: true, completion: nil)
    }
}
