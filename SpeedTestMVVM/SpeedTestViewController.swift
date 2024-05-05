//
//  ViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 07.04.2024.
//

import UIKit

final class SpeedTestViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var downloadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var downloadSpeedMeasuredLabel: UILabel!
    @IBOutlet weak var uploadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var uploadSpeedMeasuredLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func userDidTapTestSpeedButton(_ sender: Any) {
        // Running test
        speedTestManager?.checkSpeed()
    }
    
    // MARK: - Properties
    
    var speedTestManager: SpeedTestManager?
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        let manager = SpeedTestManager()
        manager.configure()
        manager.delegate = self
        speedTestManager = manager
    }
}

extension SpeedTestViewController: SpeedTestDelegateProtocol {
    func downloadSpeedChanged(to value: String) {
        DispatchQueue.main.async {
            self.downloadSpeedCurrentLabel.text = value
        }
        
    }
    
    func uploadSpeedChanged(to value: String) {
        DispatchQueue.main.async {
            self.uploadSpeedCurrentLabel.text = value
        }
    }
}

