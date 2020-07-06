import UIKit
import Photos
import Foundation
import CropViewController

class ImageViewController: UIViewController{
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageViewBackGround: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var arr = [ModelItem]()
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
//        imageView.addBlurEffect()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        arr.append(ModelItem(id: 1,img: "trim", title: "RESIZE"))
        arr.append(ModelItem(id: 2,img: "rotate", title: "ROTATE"))
        arr.append(ModelItem(id: 3,img: "trim", title: "RESIZE"))
        arr.append(ModelItem(id: 4,img: "rotate", title: "ROTATE"))
        arr.append(ModelItem(id: 5,img: "trim", title: "RESIZE"))
        arr.append(ModelItem(id: 6,img: "rotate", title: "ROTATE"))
        arr.append(ModelItem(id: 7,img: "trim", title: "RESIZE"))
        arr.append(ModelItem(id: 8,img: "rotate", title: "ROTATE"))
        arr.append(ModelItem(id: 9,img: "trim", title: "RESIZE"))
        arr.append(ModelItem(id: 10,img: "rotate", title: "ROTATE"))
    }
    
}

extension ImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage ] as? UIImage {
            imageView.image = pickedImage
            setImageViewBackground()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let data = arr[indexPath.row]
        cell.initCollectionCell(title: data.title, img: data.img)
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width/8.25, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print(indexPath.row)
//            imageView.image = UIImage(cgImage: (imageView.image?.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: 300, height: 300)))!)?
            presentCropViewController()
        case 1:
            print(indexPath.row)
            imageView.transform = imageView.transform.rotated(by: .pi/2)
        default:
            print(indexPath.row)
        }
    }
}

extension ImageViewController: CropViewControllerDelegate {
    func presentCropViewController() {
        let cropViewController = CropViewController(image: imageView.image!)
        cropViewController.delegate = self
//        cropViewController.showActivitySheetOnDone = true
        cropViewController.rotateClockwiseButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageView.image = image
        setImageViewBackground()
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIImageView{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension ImageViewController{
    func setImageViewBackground(){
        let x = (imageView.image!.size.width) / 4
        let y = (imageView.image!.size.height) / 4
        let width = (imageView.image!.size.width) / 2
        let height = (imageView.image!.size.height) / 2
        imageViewBackGround.image = UIImage(cgImage: (imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height)))!)
        imageViewBackGround.addBlurEffect()
    }
}
