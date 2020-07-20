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
import ZKProgressHUD
import Photos

class VideoViewController: UIViewController, TimelinePlayStatusReceiver {
    var videoTimelineView : VideoTimelineView!
    var arrFuncCell = [ModelItem]()
    var videoURL:NSURL!
    var avpController = AVPlayerViewController()
    let imagePickerController = UIImagePickerController()
    var playButtonStatus: Bool = true
    @IBOutlet weak var collectionViewFunc: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var tlView: UIView!
    @IBOutlet weak var buttonPlay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVideoTimeline(url: videoURL as URL)
        
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
        
        collectionViewFunc.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let player : AVPlayer =  videoTimelineView.player!
        avpController.player = player
        avpController.view.frame.size.height =  videoView.frame.size.height
        avpController.view.frame.size.width = videoView.frame.size.width
        avpController.showsPlaybackControls = false
        self.videoView.addSubview(avpController.view)
        print("Z")
        print(videoURL!)
        //assets-library://asset/asset.MP4?id=5CA941CA-BD96-491D-8867-E6AB61FCC5CD&ext=MP4
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let alert = UIAlertController(title: "Save video to your device", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in
        }))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoURL.path!, self, nil, nil)
            ZKProgressHUD.showSuccess()
            ZKProgressHUD.dismiss(0.7)
        }))
        present(alert, animated: true)
    }

    
    @IBAction func btnPlay(_ sender: Any) {
        playButtonStatus = !playButtonStatus
        if playButtonStatus {
            videoTimelineView.play()
        } else {
            videoTimelineView.stop()
        }
        setPlayButtonImage()
    }
    
    
    @IBAction func playButton(_ sender: Any) {
        playButtonStatus = !playButtonStatus

        if playButtonStatus {
            videoTimelineView.play()
        } else {
            videoTimelineView.stop()
        }
        setPlayButtonImage()
    }
    
    func videoTimelineStopped() {
        playButtonStatus = false
        setPlayButtonImage()
    }
    
    func videoTimelineMoved() {
        let time = videoTimelineView.currentTime
        print("time: \(time)")
    }
    
    func videoTimelineTrimChanged() {
//        let trim = videoTimelineView.currentTrim()
//        print("start time: \(trim.start)")
//        print("end time: \(trim.end)")
    }
}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrFuncCell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let data = arrFuncCell[indexPath.row]
            cellView.initCollectionCell(title: data.title, img: data.img)
            return cellView
    }
    	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width/8.25, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Index: \(indexPath.row)")
        guard let filePath = Bundle.main.path(forResource: "testVideo", ofType: "mp4") else {
            debugPrint("Video not found")
            return
        }
        
        let furl = createUrlInApp(name: "video.mp4")
        removeFileIfExists(fileURL: furl)
        let str = "-i \(filePath) -ss 00:00:00 -codec copy -t 60 \(furl)"
        MobileFFmpeg.execute(str)
        let furl1 = createUrlInApp(name: "video1.mp4")
        removeFileIfExists(fileURL: furl1)
        let str1 = "-i \(furl) -i \(furl) -i \(furl) -filter_complex \"[0:v:0] [0:a:0] [1:v:0] [1:a:0] [2:v:0] [2:a:0] concat=n=3:v=1:a=1 [v] [a]\" -map \"[v]\" -map \"[a]\" \(furl1)"
        MobileFFmpeg.execute(str1)
        videoTimelineView.removeFromSuperview()
        initVideoTimeline(url: furl1)
        print(videoTimelineView.duration)
        avpController.player = videoTimelineView.player!
//        tlView.addSubview(videoTimelineView)
        self.videoView.addSubview(avpController.view)
        print(furl1)
//  file:///Users/z/Library/Developer/CoreSimulator/Devices/61468387-0861-4AAE-873C-5CBBE64DE66C/data/Containers/Data/Application/5598F371-D5FB-4C20-BE0A-D8B7F01274E4/tmp/video1.mp4
        UISaveVideoAtPathToSavedPhotosAlbum(furl1.path, nil, nil, nil)
    }
}

extension VideoViewController {
    func initVideoTimeline(url : URL){
        videoTimelineView = VideoTimelineView()
        videoTimelineView.backgroundColor = UIColor.clear
        videoTimelineView.frame = CGRect(x: 0, y: tlView.frame.size.height/4, width: tlView.frame.size.width, height: tlView.frame.size.height/2)
        videoTimelineView.new(asset:AVAsset(url: url))
        videoTimelineView.playStatusReceiver = self
        videoTimelineView.repeatOn = true
        videoTimelineView.setTrimIsEnabled(false)
        videoTimelineView.setTrimmerIsHidden(true)
        tlView.addSubview(videoTimelineView)
        videoTimelineView.play()
    }
    
    func setPlayButtonImage(){
        let x = UIView(frame: (CGRect(x: (videoView.frame.size.width - 60)/2, y: (videoView.frame.size.height - 60)/2, width: 60, height: 60)))
        x.backgroundColor = UIColor.white
        if playButtonStatus {
            print("true")
            x.removeFromSuperview()
            self.buttonPlay.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .medium)), for: .normal)
        } else {
            print("false")
            videoView.addSubview(x)
            self.buttonPlay.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .medium)), for: .normal)
        }
    }
    
    func createUrlInApp(name: String ) -> URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())\(name)")
    }
    
    func removeFileIfExists(fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
