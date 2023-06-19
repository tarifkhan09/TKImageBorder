//
//  ViewController.swift
//  TKImageBorder
//
//  Created by MD Tarif khan on 19/6/23.
//

import UIKit
import AVKit
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var pickImgBtn: UIButton!{
        didSet{
            pickImgBtn.backgroundColor = .cyan
            pickImgBtn.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var borderSlider: UISlider!
    @IBOutlet weak var cornerSlider: UISlider!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    
    var containerLayer = CALayer()
    var subContainerLayer = CALayer()
    var imgLayer = CALayer()
    var isFirstBuild = true
    
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    
    var canvasSizeDataSource = [String]()
    var image = UIImage(named: "image")
    var mainBounds = CGRect()
    var containerFrame = CGRect()
    
    let colors = [UIColor.white,UIColor.cyan,UIColor.gray,UIColor.yellow,UIColor.blue,UIColor.red,UIColor.brown,UIColor.purple,UIColor.magenta,UIColor.orange,UIColor.lightGray,UIColor.darkGray,UIColor.green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllLayer()
//        test()
    }
    
    
    func setupAllLayer(){
        
        let bgViewH = bgView.bounds.size.height
        let bgViewW = bgView.bounds.size.width
        
        mainBounds = CGRect(x: 0, y: 0, width: bgViewW, height: bgViewH)
        
        containerLayer.frame = mainBounds
        containerLayer.backgroundColor = UIColor.clear.cgColor
        
        mainBounds = CGRect(origin: .zero,
                            size: AVMakeRect(aspectRatio: image!.size,
                                             insideRect: self.bgView.bounds).size)
        
        containerFrame = CGRectMake((bgViewW-mainBounds.size.width)/2.0,
                                    (bgViewH-mainBounds.size.height)/2.0,
                                    mainBounds.size.width,mainBounds.size.height)
        
        subContainerLayer.frame = containerFrame
        
        guard let image = image else{return}
        
        imgLayer.frame = mainBounds
        imgLayer.contents = image.cgImage
        imgLayer.contentsGravity = .resizeAspect
        imgLayer.masksToBounds = true
        imgLayer.backgroundColor = UIColor.green.cgColor
        
        subContainerLayer.backgroundColor = UIColor.white.cgColor
        subContainerLayer.masksToBounds = true
        
        bgView.layer.addSublayer(containerLayer)
        containerLayer.addSublayer(subContainerLayer)
        subContainerLayer.addSublayer(imgLayer)
    }
    
    
    @IBAction func didPickImg(_ sender: UIButton) {
        self.openPHPicker()
    }
    
    
    @IBAction func didChangeBorder(_ sender: UISlider) {
        CATransaction.disableActions()
        CATransaction.begin()
        
        let value = CGFloat(borderSlider.value)
        
        let w = subContainerLayer.bounds.size.width
        let h = subContainerLayer.bounds.size.height
        
        let width = w / value
        let height = h / value
        
        xOffset = (w - width) / 2
        yOffset = (h - height) / 2
        
        
        self.imgLayer.frame = CGRect(x: self.xOffset, y: self.yOffset, width: width, height: height)
        let imgLCR = (self.imgLayer.bounds.size.width / 2) * CGFloat(self.cornerSlider.value)
        self.imgLayer.cornerRadius = imgLCR
        
        CATransaction.commit()
    }
    
    
    
    @IBAction func didChangeCornerRadius(_ sender: UISlider) {
        CATransaction.disableActions()
        CATransaction.begin()
        
        let value = CGFloat(cornerSlider.value)
        
        let subLCR = (subContainerLayer.bounds.size.width / 2) * value
        let imgLCR = (imgLayer.bounds.size.width / 2) * value
        
        self.subContainerLayer.cornerRadius = subLCR
        self.imgLayer.cornerRadius = imgLCR
        CATransaction.commit()
        
    }
    
    
    
    @IBAction func didChangeSize(_ sender: UISlider) {
        CATransaction.disableActions()
        CATransaction.begin()
        
        let value = CGFloat(sizeSlider.value)
        let width = containerFrame.width / value
        let height = containerFrame.height / value
        
        let xOffset = (containerLayer.bounds.size.width - width) / 2
        let yOffset = (containerLayer.bounds.size.height - height) / 2
        
        self.subContainerLayer.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        let subLCR = (self.subContainerLayer.bounds.size.width / 2) * CGFloat(self.cornerSlider.value)
        self.subContainerLayer.cornerRadius = subLCR
        
        let imgW = subContainerLayer.bounds.size.width - (self.xOffset * 2)
        let imgH = subContainerLayer.bounds.size.height - (self.yOffset * 2)
        
        self.imgLayer.frame = CGRect(x: self.xOffset, y: self.yOffset, width: imgW, height: imgH)
        let imgLCR = (self.imgLayer.bounds.size.width / 2) * CGFloat(self.cornerSlider.value)
        self.imgLayer.cornerRadius = imgLCR
        CATransaction.commit()
    }
    
}


//MARK: collectionView Delegate and Datasource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as? ColorsCollectionViewCell else{return UICollectionViewCell()}
        cell.colorView.backgroundColor = colors[indexPath.row]
        cell.colorView.layer.cornerRadius = 5.0
        cell.isSelected = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colorsCollectionView.bounds.size.width / 8, height: colorsCollectionView.bounds.size.height / 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.subContainerLayer.backgroundColor = colors[indexPath.row].cgColor
    }
}



// MARK: - PHPicker Configurations (PHPickerViewControllerDelegate)
extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async { [self] in
                    self.image = image
                    self.imgLayer.contents = image.cgImage
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    /// call this method for `PHPicker`
    func openPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }

}




///test
extension ViewController{
    func test(){
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        parentLayer.backgroundColor = UIColor.red.cgColor
        
        let childLayer = CALayer()
        childLayer.frame = parentLayer.bounds
        childLayer.backgroundColor = UIColor.gray.cgColor
        parentLayer.addSublayer(childLayer)
        
        parentLayer.setAffineTransform(CGAffineTransformRotate(parentLayer.affineTransform(),
                                                               Double.pi/4))
//
//        childLayer.setAffineTransform(CGAffineTransformRotate(childLayer.affineTransform(),
//                                                              Double.pi/4))
        
        let paerntTransform = parentLayer.affineTransform()
        let parentAngle = atan2(paerntTransform.b, paerntTransform.a)
        print("parent angle", parentAngle)
        
        let childTransfrom = childLayer.affineTransform()
        let childANgle  = atan2(childTransfrom.b, childTransfrom.a)
        print("child angle", childANgle)
        
        let path = drawSquareBezierPath(startingPoint: CGPoint(x: childLayer.frame.width/2.0,
                                                               y: childLayer.frame.height/2.0),
                                        sideLength: 100)
        path.apply(CGAffineTransform(rotationAngle: Double.pi/4))
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = path.bounds
        maskLayer.path = path.cgPath
        maskLayer.position = childLayer.position
        childLayer.mask = maskLayer
        
        bgView.layer.addSublayer(parentLayer)
    }
    
    func drawSquareBezierPath(startingPoint: CGPoint, sideLength: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startingPoint)
        
        let topRightPoint = CGPoint(x: startingPoint.x + sideLength, y: startingPoint.y)
        let bottomRightPoint = CGPoint(x: startingPoint.x + sideLength, y: startingPoint.y + sideLength)
        let bottomLeftPoint = CGPoint(x: startingPoint.x, y: startingPoint.y + sideLength)
        
        path.addLine(to: topRightPoint)
        path.addLine(to: bottomRightPoint)
        path.addLine(to: bottomLeftPoint)
        path.close()
        
        return path
    }
}

