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
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startClock()

    }
    
    func startClock() {
        timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentHour = Calendar.current.component(.hour, from: self.currentDate)
            if currentHour < 12 {
                // Set AM background image
            } else {
                // Set PM background image
            }
            self.liveClockLabel.text = self.dateFormatter.string(from: self.currentDate)
        }
    }
}

