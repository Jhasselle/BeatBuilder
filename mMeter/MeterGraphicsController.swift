//
//  MeterGraphicsController.swift
//  mMeter
//
//  Created by CampusUser on 2/23/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

import UIKit

class MeterGraphicsController: UIViewController {

    @IBOutlet var audioSliderImage: UIImageView!
    @IBOutlet var testButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func anime (){
        
        // https://stackoverflow.com/questions/5677716/how-to-get-the-screen-width-and-height-in-ios
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        // split screen
        let windowRect = self.view.window?.frame
        let windowWidth = windowRect?.size.width
        let windowHeight = windowRect?.size.height
        
        
        audioSliderImage.center.x  -= view.bounds.width
        print("view.bounds.width", view.bounds.width)
        print("screenWidth", screenWidth)
        print("windowWidth", windowWidth)
        
        UIView.animate(withDuration: 2, delay: 0.0, options: [.repeat, .curveLinear],
                       animations: {self.audioSliderImage.center.x += self.view.bounds.width * 2}, completion: nil)
    }
}
