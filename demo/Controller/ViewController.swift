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
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var ImageButton: UIButton!
    override func viewDidLoad() {
        setGradientBackground()
        videoButton.applyGradient()
        ImageButton.applyGradient()
        super.viewDidLoad()
    }
    
    @IBAction func goto_videoView(_ sender: Any) {
        if(checkPhotoLibraryPermission()){
            navigateOtherView(view: "VideoView")
        }
        //        else {
//            let alert = UIAlertController(title: "", message: "Error!!!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ok", style: .default))
//            present(alert, animated: true)
//        }
    }
    
    @IBAction func goto_ImageView(_ sender: Any) {
        if checkPhotoLibraryPermission(){
            navigateOtherView(view: "ImageView")
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
                print("denied")
                return false
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

    
    func navigateOtherView(view: String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let View = sb.instantiateViewController(withIdentifier: view)
        self.navigationController?.pushViewController(View, animated: true)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.systemPink.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.3]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension UIButton{
    func applyGradient() {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let colorTop = UIColor(red: (255/255.0), green: (170/255.0), blue: 140/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: (210/255.0), green: (50/255.0), blue: 110/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.locations = [-0.5, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = false
        gradientLayer.cornerRadius = self.frame.height/2
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
