//
//  ViewController.swift
//  mMeter
//
//  Created by CampusUser on 2/23/19.
//  Copyright © 2019 Ellessah. All rights reserved.

import Foundation
import AVFoundation
import UIKit

class customButton: UIButton {
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 5, height: 5)
        }
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
    @IBOutlet var mixerView: UIView!
    
    
    /////////////////////////////////////////////
    @IBOutlet var MasterStackView: UIStackView!
    
    @IBOutlet var TopBar: UIView!
    @IBOutlet var PattyBar: UIStackView!
    @IBOutlet var BottomBar: UIView!
    
    @IBOutlet var LeftBar: UIView!
    @IBOutlet var TracksPatty: UIStackView!
    @IBOutlet var RightBar: UIView!
    /////////////////////////////////////////////
    
    @IBOutlet var parentTrackView: UIStackView!
    
    var stackViewTracks : [UIStackView] = []
    let buttonsArray: Array<UIButton> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTrackViews()
        //        helper_initializer()
        //        initialize()
        print("ViewDidLoad() Complete")
    }
    
    func initializeTrackViews() {
        parentTrackView.axis = .vertical
        parentTrackView.alignment = .fill
        parentTrackView.distribution = .fillEqually
        
        for _ in 0..<5 {
            let newTrack = UIStackView()
            newTrack.axis = .horizontal
            newTrack.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
            newTrack.distribution = .fillEqually // .fillEqually .fillProportionally .equalSpacing .equalCentering
            for j in 0..<32 {
                // let bColor : Double = (1.0/32.0) * (Double(i) + 1.0)
                let button = customButton()
                let indexStr : String = String(j)
                button.setTitle( indexStr, for:   UIControl.State.normal)
                button.tag = j
                button.backgroundColor = UIColor.init(displayP3Red: CGFloat(Float.random(in: 0 ..< 1)), green: CGFloat(Float.random(in: 0 ..< 1)), blue: CGFloat(Float.random(in: 0 ..< 1)), alpha: 1)
                newTrack.addArrangedSubview(button)
            }
            stackViewTracks.append(newTrack)
            parentTrackView.addArrangedSubview(newTrack)
        }
    }
    
    func initializePattyView() {
        //LeftBar.
    }
    
    
    
    
    
    
    
    
    
    
    
    var trackManager: TrackManager!
    var audioSliderDefaultPosition : CGRect!
    var fireCounter: Int!
    var buttonChecker: [[Int]]!
    let trackButtonColors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan]
    var timer: Timer!
 
    
    
    @IBAction func instrumentSelection(_ sender: UIButton) {
        print("Instrument Selection Button Activated")
    }

    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        
        let trackIndex = sender.tag
        let temp = sender.currentTitle
        print("*********** ", temp ?? 000)
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
            sender.backgroundColor = UIColor.darkGray
            buttonChecker[trackID][trackIndex] = 0
            trackManager.setTrackButton(trackID, trackIndex)
        }
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

    func initialize(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(jebaited), userInfo: nil, repeats: false)
        buttonChecker = Array(repeating: Array(repeating: 0, count: 32), count: 5)
        trackManager = TrackManager()
        bpmText.text = "120"
        titleLabel.text = "BeatBuilder v1.0"
        audioSliderDefaultPosition = audioSliderImage.bounds
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        bpmText.resignFirstResponder()
//        instrumentView.layer.zPosition = 0
    }
    
    func startSlider (){
        timer = Timer.scheduledTimer(timeInterval: trackManager.metronomeInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        // Reset Position of the slider
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
        UIView.animate(withDuration: trackManager.timerInterval * 32, delay: 0.0, options: [.repeat, .curveLinear], animations: {self.audioSliderImage.center.x = self.mixerView.bounds.maxX}, completion: nil)
    }
    
    func stopSlider() {
        timer.invalidate()
        audioSliderImage.center.x = audioSliderDefaultPosition.minX
//        UIView.animate(withDuration: trackManager.timerInterval * 32, delay: 0.0, options: [.curveLinear], animations: {self.audioSliderImage.center.x = self.mixerView.bounds.maxX}, completion: nil)
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
    
    
    @objc func jebaited() {
    }

    @objc func fireTimer() {
        //print("Timer fired. bpm=", bpm, " interval=", interval )
        if fireCounter == 1 {
            metronomeDebugLabel.backgroundColor = UIColor.blue
            metronomeDebugLabel.text = "1"
        }
        else if fireCounter == 2 {
            metronomeDebugLabel.backgroundColor = UIColor.blue
            metronomeDebugLabel.text = "2"
        }
        else if fireCounter == 3 {
            metronomeDebugLabel.backgroundColor = UIColor.blue
            metronomeDebugLabel.text = "3"
        }
        else { //4
            metronomeDebugLabel.backgroundColor = UIColor.green
            metronomeDebugLabel.text = "4"
            fireCounter = 0
        }

        fireCounter += 1

    }
}

