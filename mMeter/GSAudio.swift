//
//  GSAudio.swift
//  mMeter
//
//  Created by CampusUser on 3/10/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

// Source used: https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time
import AVFoundation
import Foundation

class GSAudio: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = GSAudio()
    
    private override init() {}
    
    var players = [NSURL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    func playSound (_ soundFileName: String){
        
        let soundFileNameURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: soundFileName, ofType: "wav", inDirectory: "Audio")!)
        if let player = players[soundFileNameURL] { //player for sound has been found
            
            if player.isPlaying == false { //player is not in use, so use that one
                player.prepareToPlay()
                player.play()
                
            } else { // player is in use, create a new, duplicate, player and use that instead
                
                do {
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                    //use 'try!' because we know the URL worked before.
                    
                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing
                    
                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing
                    
                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch let error{
                    print(error.localizedDescription)
                }
            }
        } else { //player has not been found, create a new player with the URL if possible
            do{
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func playSounds(_ soundFileNames: [String]){
        
        for soundFileName in soundFileNames {
            playSound(soundFileName)
        }
    }
    
    func playSounds(_ soundFileNames: String...){
        for soundFileName in soundFileNames {
            playSound(soundFileName)
        }
    }
    
    func playSounds(soundFileNames: [String], withDelay: Double) { //withDelay is in seconds
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay*Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification(_:)), userInfo: ["fileName":soundFileName], repeats: false)
        }
    }
    
    @objc func playSoundNotification(_ notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.index(of: player) {
            duplicatePlayers.remove(at: index)
        }
        
    }
    
}
