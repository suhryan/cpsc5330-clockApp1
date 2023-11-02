//
//  ViewController.swift
//  cpsc5330-clockApp1
//
//  Created by ryan suh on 10/31/23.
//

import UIKit

class ViewController: UIViewController {

    var timer1: Timer?
    var currentDate: Date {
        return Date()
    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        return formatter
    }()
    @IBOutlet weak var liveClockLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var amPmImage: UIImageView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // put black border for the button
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1.0

        startClock()
        
        //time picker element backgroundcolor to black and
        //change the letters to white
        timePicker.backgroundColor = .black
        if #available(iOS 14.0, *) {
            // For iOS 14 and later
            timePicker.overrideUserInterfaceStyle = .dark
        } else {
            // For iOS versions prior to 14
            timePicker.setValue(UIColor.white, forKey: "textColor")
        }
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

