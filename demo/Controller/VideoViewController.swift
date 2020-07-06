//
//  VideoViewController.swift
//  demo
//
//  Created by Z on 6/26/20.
//  Copyright © 2020 Z. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import PryntTrimmerView

class VideoViewController: UIViewController {

    var temp : String!
    var arrFuncCell = [ModelItem]()
    var arrTimeline = [UIImage]()
    var videoURL:NSURL!
    var avpController = AVPlayerViewController()
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timelineView: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrFuncCell.append(ModelItem(id: 1,img: "trim", title: "RESIZE"))
        arrFuncCell.append(ModelItem(id: 2,img: "rotate", title: "ROTATE"))
        arrFuncCell.append(ModelItem(id: 3,img: "trim", title: "RESIZE"))
        arrFuncCell.append(ModelItem(id: 4,img: "rotate", title: "ROTATE"))
        arrFuncCell.append(ModelItem(id: 5,img: "trim", title: "RESIZE"))
        arrFuncCell.append(ModelItem(id: 6,img: "rotate", title: "ROTATE"))
        arrFuncCell.append(ModelItem(id: 7,img: "trim", title: "RESIZE"))
        arrFuncCell.append(ModelItem(id: 8,img: "rotate", title: "ROTATE"))
        arrFuncCell.append(ModelItem(id: 9,img: "trim", title: "RESIZE"))
        arrFuncCell.append(ModelItem(id: 10,img: "rotate", title: "ROTATE"))
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension VideoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? NSURL
        self.videoURL = videoURL
        let player = AVPlayer(url: videoURL! as URL)
        avpController.player = player
        avpController.view.frame.size.height = videoView.frame.size.height
        avpController.view.frame.size.width = videoView.frame.size.width
        self.videoView.addSubview(avpController.view)
        imagePickerController.dismiss(animated: true, completion: nil)
        
        previewVideo()
        timelineView.register(UINib(nibName: "TimeLineViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeLineViewCell")
    }
}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView){
            return arrFuncCell.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionView){
            let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let data = arrFuncCell[indexPath.row]
            cellView.initCollectionCell(title: data.title, img: data.img)
            print("collection collection")
            return cellView
        }
        else{
            let cellTimeline = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineViewCell", for: indexPath) as! TimeLineViewCell
            let data = arrTimeline[indexPath.row]
            cellTimeline.initTimelineCell(img: data)
            print("collection timeline")
            return cellTimeline
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.collectionView){
            return CGSize(width: collectionView.frame.size.width/8.25, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: 60, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print(indexPath.row)
        case 1:
            print(indexPath.row)
        default:
            print(indexPath.row)
        }
    }
}

extension VideoViewController{
    func previewVideo() {

        let asset = AVURLAsset(url:videoURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let duration = CMTimeGetSeconds(asset.duration)
        
        for  i in 0...Int(duration){
            let timestamp = CMTime(seconds: Double(i*10), preferredTimescale: 60)
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                arrTimeline.append(UIImage(cgImage: imageRef))
            }
            catch let error as NSError{
                print("Image generation failed with error \(error)")
            }
        }
    }
}
