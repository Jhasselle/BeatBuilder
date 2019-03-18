//
//  TrackManager.swift
//  mMeter
//
//  Created by CampusUser on 2/23/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//
import Foundation
import AVFoundation

struct Track {
    var measure = Array(repeating: false, count: 32)
    var volume = 1.0
    var soundFileName = ""
    var id = 999 // special number
    mutating func resetTrackNotes() {
        measure = Array(repeating: false, count: 32)
    }
}

class TrackManager: NSObject {
    
    var session : AVAudioSession!
    var isAudioReady: Bool!
    var tracks: [Track]!
    var bpm: Double! // beats per minute
    var metronomeInterval: Double! // metronome beat
    var timerInterval: Double!
    var isPlaying: Bool!
    var timer: Timer!
    var MASTER_COUNTER: Int!
    var NUMBER_OF_TRACKS = 5
    let defaultInstruments = ["hihat1", "crash1", "snare1", "tom1", "kick1"]
    
    override init(){
        print("Initializing TrackManager")
        super.init()

        // Some fookery is afoot here
        tracks = Array(repeating: Track(), count: NUMBER_OF_TRACKS)
        
        for i in 0..<NUMBER_OF_TRACKS {
            tracks[i].id = i
            tracks[i].soundFileName = defaultInstruments[i]
        }
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(jebaited), userInfo: nil, repeats: false)
        MASTER_COUNTER = 0
        isPlaying = false
        bpm = 120.00
        metronomeInterval = 1 / (bpm / 60) // 1/4th of a measure
        timerInterval = metronomeInterval / 8 //32 beats per measure
    }

    
    
    @objc func fireTimer() {
        var soundFileNames: [String] = []
        for track in tracks {
            if track.measure[MASTER_COUNTER] {
                soundFileNames.append(track.soundFileName)
            }
        }
        
        if soundFileNames.count > 0 {
            GSAudio.sharedInstance.playSounds(soundFileNames)
        }
        
        MASTER_COUNTER += 1
        if MASTER_COUNTER > 31 {
            MASTER_COUNTER = 0
        }
    }
    
    func findInterval() {
        metronomeInterval = 1 / (bpm / 60)
        // Dividing 1/4 of a whole note by 8.
        // This is for 32 notes for the entire measure
        timerInterval = metronomeInterval / 8
    }
    
    func stop() {
        isPlaying = false
        timer.invalidate()
        MASTER_COUNTER = 0
        print ("Stopped")

    }
    
    func start() {
        MASTER_COUNTER = 0
        isPlaying = true
        timer.invalidate()
        findInterval()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func setTrackButton(_ trackID : Int, _ measureIndex : Int) {

        if tracks[trackID].measure[measureIndex] {
            tracks[trackID].measure[measureIndex] = false
        }
        else {
            tracks[trackID].measure[measureIndex] = true
        }
    }
    
    func clearTrackNotes(_ trackID : Int) {
        tracks[trackID].resetTrackNotes()
    }
    
    func setTrackInstrument(_ trackID : Int, _ instrumentFileName : String) {
        tracks[trackID].soundFileName = instrumentFileName
    }
    
    @objc func jebaited() {
    }
    
}



