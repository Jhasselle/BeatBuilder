//
//  ViewController.swift
//  mMeter
//
//  Created by CampusUser on 2/23/19.
//  Copyright © 2019 Ellessah. All rights reserved.


import AVFoundation
import UIKit

class customButton: UIButton {
    
    var customHeight : Int = 5
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 5, height: customHeight)
        }
    }
    
    func setIntrinsticContentSize(_ newHeight : Int) {
        customHeight = newHeight
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var metronomeDebugLabel: UILabel!
    @IBOutlet var audioSliderImage: UIImageView!
    @IBOutlet var bpmText: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    /////////////////////////////////////////////
    @IBOutlet var MasterStackView: UIStackView!
        @IBOutlet var TopBar: UIView!
        @IBOutlet var PattyBar: UIStackView!
            @IBOutlet var LeftBar: UIView!
            @IBOutlet var TracksPatty: UIStackView!
                @IBOutlet var parentTrackView: UIStackView!
            @IBOutlet var RightBar: UIView!
        @IBOutlet var BottomBar: UIView!
    /////////////////////////////////////////////
    var trackManager: TrackManager!
    var audioSliderDefaultPosition : CGRect!
    var fireCounter: Int!
    var buttonChecker: [[Int]]!
    let trackButtonColors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan]
    var timer: Timer!
    var stackViewTracks : [UIStackView] = []

    
    
    func initializeVC(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(jebaited), userInfo: nil, repeats: false)
        buttonChecker = Array(repeating: Array(repeating: 0, count: 32), count: 5)
        trackManager = TrackManager()
        bpmText.text = "120"
        titleLabel.text = "BeatBuilder v1.1"
        audioSliderDefaultPosition = parentTrackView.bounds
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVC()
        initializeTrackViews()
        
        print("ViewDidLoad() Complete")
    }
    
    func initializeTrackViews() {
        
        parentTrackView.axis = .vertical
        parentTrackView.alignment = .fill
        parentTrackView.distribution = .fillEqually
        
        for i in 0..<5 {
            let newTrack = UIStackView()
            newTrack.axis = .horizontal
            newTrack.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
            newTrack.distribution = .fillEqually // .fillEqually .fillProportionally .equalSpacing .equalCentering
            newTrack.spacing = CGFloat(5.0)
            
            for j in 0..<32 {
                // let bColor : Double = (1.0/32.0) * (Double(i) + 1.0)
                let button = customButton()
                let indexStr : String = String(i)
                button.setTitle( indexStr, for:   UIControl.State.normal)
                button.setTitleColor(UIColor.init(white: 1.0, alpha: 0.0), for: UIControl.State.normal)
                button.tag = j
                
                if (j) % 8 == 0 {
                    button.setIntrinsticContentSize(30)
//                    trackButtonPressed(button)
                    button.backgroundColor = UIColor.gray
                }
                else {
                    button.backgroundColor = UIColor.darkGray
                }
                
                button.addTarget(self, action: #selector(trackButtonPressed(_:) ), for: .touchUpInside)
                newTrack.addArrangedSubview(button)
            }
            stackViewTracks.append(newTrack)
            
            parentTrackView.addArrangedSubview(newTrack)
        }
        PattyBar.axis = .horizontal
        PattyBar.alignment = .fill
        PattyBar.distribution = .fill
    }
    
    @IBAction func instrumentSelection(_ sender: UIButton) {
        print("Instrument Selection Button Activated")
    }

    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        
        let trackIndex = sender.tag
        let temp = sender.currentTitle
        let trackTitle = Int(String(temp!))
        let trackID = trackTitle ?? 2 - 1
        if buttonChecker[trackID][trackIndex] == 0 {
            // Was off, turning on.
            sender.backgroundColor = trackButtonColors[trackID]
            buttonChecker[trackID][trackIndex] = 1
            trackManager.setTrackButton(trackID, trackIndex)
        }
        else {
            // Was on, turning off.
            if sender.tag % 8 == 0 {
                sender.backgroundColor = UIColor.gray

            }
            else {
                sender.backgroundColor = UIColor.darkGray

            }
            buttonChecker[trackID][trackIndex] = 0
            trackManager.setTrackButton(trackID, trackIndex)
        }
    }

    



    
    
    
    
    
    
    
    
    
    
    

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        bpmText.resignFirstResponder()
//        instrumentView.layer.zPosition = 0
    }
    
    func startSlider (){
        timer = Timer.scheduledTimer(timeInterval: trackManager.metronomeInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        // Reset Position of the slider
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
        
        UIView.animate(withDuration: trackManager.timerInterval * 32, delay: 0.0, options: [.repeat, .curveLinear], animations: {self.audioSliderImage.center.x = self.parentTrackView.bounds.maxX}, completion: nil)
    }
    
    func stopSlider() {
        timer.invalidate()
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
        audioSliderImage.stopAnimating()
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
    }

    
    @IBAction func stop() {
        print("VC stop()")
        trackManager.stop()
        stopSlider()
        fireCounter = 1;
        fireTimer()
        
    }
    
    @IBAction func start() {
        print("VC start()")
        stop()
        trackManager.start()
        startSlider()
    }
    
    @IBAction func bpmChanged(_ textField: UITextField) { // yes
        stop()
        if let text = textField.text, let value = Double(text) {
            
            if value > 300 {
                trackManager.bpm = 300
                textField.text = "300"
            }
            else if value < 0 {
                trackManager.bpm = 1
                textField.text = "1"
            }
            else {
                trackManager.bpm = value
            }
        } else {
            trackManager.bpm = 120
        }
    }
    
    @objc func jebaited() {
    }

    @objc func fireTimer() {
        
        if fireCounter >= 4 {
            metronomeDebugLabel.backgroundColor = UIColor.green
            metronomeDebugLabel.text = "4"
            fireCounter = 0
        }
        else {
            metronomeDebugLabel.backgroundColor = UIColor.blue
            metronomeDebugLabel.text = String(fireCounter)
        }

        fireCounter += 1

    }
}

