//
//  ViewController.swift
//  cpsc5330-clockApp1
//
//  Created by ryan suh on 10/31/23.
//

import UIKit
import AVFoundation // for mp3 audio play

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var timer1: Timer?
    
    // timer for counting down time
    var countDownTimer: Timer?
    
    // total remaining count down time
    var totalRemainingSeconds: Int = 0
    
    var currentDate: Date {
        return Date()
    }
    
    var timerRunning:Bool = false
    var musicPlaying:Bool = false
    
    var audioPlayer: AVAudioPlayer?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/Chicago")
        return formatter
    }()
    
    @IBOutlet weak var liveClockLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var amPmImage: UIImageView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var remainTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioPlayer()
        
        // put black border for the start timer button
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1.0

        //start the live clock
        startClock()
        
        //time picker element backgroundcolor to black and
        //change the letters to white for better visibility
        timePicker.backgroundColor = .black
        if #available(iOS 14.0, *) {
            // For iOS 14 and later
            timePicker.overrideUserInterfaceStyle = .dark
        } else {
            // For iOS versions prior to 14
            timePicker.setValue(UIColor.white, forKey: "textColor")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // Perform additional actions if needed, like updating the UI
            startButton.setTitle("Start Timer", for: .normal)
            
            // stop and reset audio play
            audioPlayer?.stop()
            // Rewind the audio to the beginning
            audioPlayer?.currentTime = 0
            
            // reset timer
            stopCountdown()
            
            //needed to restart the count down with one click of 'Start Timer' button
            musicPlaying = false
        }
    }

    // setup audio player to play
    func setupAudioPlayer() {
        guard let audioUrl = Bundle.main.url(forResource: "der-kleber-sting", withExtension: "mp3")
        else {
            print("Unable to find the audio file")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer?.delegate = self  // Set the delegate
            audioPlayer?.prepareToPlay()
        } catch {
            print("There was an error loading the audio file: \(error)")
        }
    }


    // start timer button click event handler
    @IBAction func startStopTapped(_ sender: UIButton) {
        if countDownTimer == nil {
            let selectedTime = timePicker.date
            let calendar = Calendar.current
            
            totalRemainingSeconds = calendar.component(.hour, from: selectedTime) * 3600
            + calendar.component(.minute, from: selectedTime) * 60
            + calendar.component(.second, from: selectedTime)

            countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
            startButton.setTitle("Stop Timer", for: .normal)
        } else {
            //stop count down if 'stop timer' pressed again
            stopCountdown()
        }
        
        // if music is playing then stop the music and
        // reset music playing and total remaining time to  0 and
        // call stopCountdown() to reset button title and timer
        if (musicPlaying == true) {
            audioPlayer?.stop()
            // Rewind the audio to the beginning
            audioPlayer?.currentTime = 0
            
            musicPlaying = false
            totalRemainingSeconds = 0
            stopCountdown()
        }
    }
    
    // function to update time remaining label every second.
    @objc func updateCountdown() {
        if totalRemainingSeconds > 0 {
            totalRemainingSeconds -= 1

            let hours = totalRemainingSeconds / 3600
            let minutes = (totalRemainingSeconds % 3600) / 60
            let seconds = totalRemainingSeconds % 60
            remainTimeLabel.text = String(format: "Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
        } else { //time ran out
            stopCountdown()
            
            // since time ran out, change button title and play
            // music
            startButton.setTitle("Stop Music", for: .normal)
            audioPlayer?.play() //play the audio on countdown stop
            musicPlaying = true
        }
    }

    // function to stop the count down
    func stopCountdown() {
        startButton.setTitle("Start Timer", for: .normal)
        startButton.isEnabled = true
        
        countDownTimer?.invalidate()
        countDownTimer = nil
    }

    /* start the live clock */
    func startClock() {
        timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentHour = Calendar.current.component(.hour, from: self.currentDate)
            if currentHour < 12 { // set daytime image
                //self.view.backgroundColor = .systemBackground // set AM color
                self.amPmImage.image = UIImage(named: "day.jpg")
            } else { // set night time image
                //self.view.backgroundColor = UIColor.gray // set PM color
                self.amPmImage.image = UIImage(named: "night.jpg")
                
            }
            
            self.liveClockLabel.text = self.dateFormatter.string(from: self.currentDate)
        }
    }
    

}

