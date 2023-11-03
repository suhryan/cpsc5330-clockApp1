//
//  ViewController.swift
//  cpsc5330-clockApp1
//
//  Created by ryan suh on 10/31/23.
//

import UIKit

class ViewController: UIViewController {

    var timer1: Timer?
    
    var countDownTimer: Timer?
    var totalRemainingSeconds: Int = 0
    
    var currentDate: Date {
        return Date()
    }
    
    var timerRunning:Bool = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        return formatter
    }()
    @IBOutlet weak var liveClockLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var amPmImage: UIImageView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var remainTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // put black border for the button
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1.0

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
    

    // button click event handler
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
            stopCountdown()
        }
    }
    
    // function to update time remaining label every second
    @objc func updateCountdown() {
        if totalRemainingSeconds > 0 {
            totalRemainingSeconds -= 1

            let hours = totalRemainingSeconds / 3600
            let minutes = (totalRemainingSeconds % 3600) / 60
            let seconds = totalRemainingSeconds % 60
            remainTimeLabel.text = String(format: "Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
        } else {
            stopCountdown()
            startButton.setTitle("Start Timer", for: .normal)
        }
    }

    // function to stop the count down
    func stopCountdown() {
        countDownTimer?.invalidate()
        countDownTimer = nil
        startButton.setTitle("Start Timer", for: .normal)
    }

    /* start the live clock */
    func startClock() {
        timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentHour = Calendar.current.component(.hour, from: self.currentDate)
            if currentHour < 12 {
                //self.view.backgroundColor = .systemBackground // set AM color
                self.amPmImage.image = UIImage(named: "day.jpg")
            } else {
                //self.view.backgroundColor = UIColor.gray // set PM color
                self.amPmImage.image = UIImage(named: "night.jpg")            }
            self.liveClockLabel.text = self.dateFormatter.string(from: self.currentDate)
        }
    }
    

}

