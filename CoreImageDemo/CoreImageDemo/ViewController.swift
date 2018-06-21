//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Satabdi Das on 21/06/18.
//  Copyright © 2018 Satabdi Das. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var sepiaImageView:UIImageView!
    @IBOutlet weak var bloomImageView:UIImageView!
    @IBOutlet weak var amountSlider:UISlider!
    
    var context:CIContext!
    var beginImage: CIImage!
    var sliderValue:Double!
    var outPutImage:CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: "image.png")
        
        let imageURL = Bundle.main.url(forResource: "image", withExtension: "png")
        self.beginImage = CIImage(contentsOf: imageURL!)!
        self.context = CIContext(options: nil)
        self.outPutImage = self.sepiaFilter(beginImage,intensity: 0.5)
        let cgimg = context.createCGImage(outPutImage!, from: outPutImage!.extent)
        self.sepiaImageView.image = UIImage(cgImage: cgimg!)
        
       // let bloomCIImage = self.bloomFilter(outputImage!, intensity:1, radius:10)
        //self.bloomImageView.image = UIImage(ciImage:bloomCIImage!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func amountValueChanged(_ sender: UISlider) {
         self.sliderValue = Double(sender.value)
        
        self.outPutImage = self.sepiaFilter(beginImage,intensity: sliderValue)
        let cgimg = context.createCGImage(outPutImage!, from: outPutImage!.extent)
         self.sepiaImageView.image = UIImage(cgImage: cgimg!)
        
       /* let outputBloomImage = self.bloomFilter(outputImage!, intensity: sliderValue, radius: 10)
        let cgBloomimg = context.createCGImage(outputBloomImage!, from: outputBloomImage!.extent)
        self.bloomImageView.image = UIImage(cgImage: cgBloomimg!)*/
        
    }
    
    
    @IBAction func bringUpPhotoAlbum(_ sender: Any) {
        
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.present(pickerC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func savePhoto(_ sender: Any) {
        
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let cgimg = context.createCGImage(outPutImage!, from: outPutImage!.extent)
       
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage?
    {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }

}

extension ViewController:UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = gotImage
        beginImage = CIImage(image:gotImage)
        self.amountValueChanged(amountSlider)
    }
}

