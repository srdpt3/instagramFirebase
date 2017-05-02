//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 27..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import AVFoundation
class CameraController: UIViewController , AVCapturePhotoCaptureDelegate , UIViewControllerTransitioningDelegate{
    let dissmissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        
        return button
    }()
    
    
    
    let capturePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        
        return button
    }()
    
    func handleDissmiss(){
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        
        
        setupCaptureSession()
        view.addSubview(capturePhotoButton)
        view.addSubview(dissmissButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        dissmissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
    }
    
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismiss = CustomAnimationDismiss()

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor;
        
        
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismiss
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func handleCapturePhoto(){
        let setting = AVCapturePhotoSettings()
        
        guard let previewFormatType = setting.availablePreviewPhotoPixelFormatTypes.first else { return }
        setting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        output.capturePhoto(with: setting, delegate: self)
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        let previewImage = UIImage(data: imageData!)
//
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
    }
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession(){
        
        let captureSession = AVCaptureSession()
        
        // 1. setup Input
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let input = try  AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
                
            }
            
            
        } catch let err{
            print("Could not setup camera input", err)
        }
        
        // 2 setup Output
        
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        // 3. Setup output preview
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
}
