//
//  ViewController.swift
//  demo
//
//  Created by Z on 6/26/20.
//  Copyright © 2020 Z. All rights reserved.
//

import UIKit
import Photos
import AVKit

class ViewController: UIViewController{
    
    let videoPicker = UIImagePickerController()
    let imagePicker = UIImagePickerController()
    var videoURL:NSURL!
    var image: UIImage!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var ImageButton: UIButton!
    
    override func viewDidLoad() {
        setGradientBackground()
        super.viewDidLoad()

    }
    
    @IBAction func goto_videoView(_ sender: UIButton) {
        if(checkPhotoLibraryPermission()){
            videoPicker.sourceType = .photoLibrary
            videoPicker.delegate = self
            videoPicker.mediaTypes = ["public.movie"]
            videoPicker.modalPresentationStyle = .overFullScreen
            present(videoPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func goto_ImageView(_ sender: UIButton) {
        if checkPhotoLibraryPermission(){
            imagePicker.delegate = self
            //imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == self.videoPicker {
            videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? NSURL
            print(info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")]!)
            videoPicker.dismiss(animated: true, completion: nil)
            navigateOtherView(view: "VideoView")
        }
        else{
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage ] as? UIImage {
                image = pickedImage
            }
            imagePicker.dismiss(animated: true, completion: nil)
            navigateOtherView(view: "ImageView")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker == self.videoPicker {
            videoPicker.dismiss(animated: true, completion: nil)        }
        else{
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ViewController{
    func navigateOtherView(view: String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if view == "ImageView" {
            let View = sb.instantiateViewController(withIdentifier: view) as! ImageViewController
            View.img = self.image
            self.navigationController?.pushViewController(View, animated: false)
        }
        else{
            let View = sb.instantiateViewController(withIdentifier: view) as! VideoViewController
            View.videoURL = self.videoURL
            self.navigationController?.pushViewController(View, animated: false)
        }
    }
}

extension UIViewController {
    func checkPhotoLibraryPermission() ->Bool {
        var flag:Bool! = false
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
                print("authorized")
                flag = true
            case .denied, .restricted :
                let alert = UIAlertController(title: "Allow Demo to access photos and videos on your device", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in
                    print("Cancel")
                }))
                alert.addAction(UIAlertAction(title: "Open Setting", style: .default, handler: {(action: UIAlertAction) in
                    print("OK")
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                present(alert, animated: true)
                print("denied")
        case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Determined/authorized")
                        flag = true
                    case .denied, .restricted, .notDetermined:
                        print("Determined/denied")
                    @unknown default:
                        print("Determined/default")
                    }
                }
        @unknown default:
            print("default")
        }
        return flag
    }

    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.systemRed.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.3]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

//extension UIButton{
//    func applyGradient() {
//        self.backgroundColor = nil
//        self.layoutIfNeeded()
//
//        let colorTop = UIColor(red: (255/255.0), green: (170/255.0), blue: 140/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: (210/255.0), green: (50/255.0), blue: 110/255.0, alpha: 1.0).cgColor
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.locations = [-0.5, 1.0]
//        gradientLayer.frame = self.bounds
//        gradientLayer.masksToBounds = false
//        gradientLayer.cornerRadius = self.frame.height/2
//
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    func animationOnPress(){
//        let flash = CABasicAnimation(keyPath: "opacity")
//        flash.duration = 0.5
//        flash.fromValue = 1
//        flash.toValue = 0.5
//        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        flash.autoreverses = true
//
//        self.layer.add(flash, forKey: nil)
//    }
//}
