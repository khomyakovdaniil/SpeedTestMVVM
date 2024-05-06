//
//  ViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 07.04.2024.
//

import UIKit
import Combine

final class SpeedTestViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var downloadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var downloadSpeedMeasuredLabel: UILabel!
    @IBOutlet weak var uploadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var uploadSpeedMeasuredLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func userDidTapTestSpeedButton(_ sender: Any) {
        vm?.startTest()
    }
    
    // MARK: - Properties
    
    var vm: SpeedTestViewModelProtocol?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        vm = SpeedTestViewModel(speedTestManager: SpeedTestManager())
        bindData()
    }
    
    func bindData() {
        
        vm?.downloadSpeedCurrentPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.downloadSpeedCurrentLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        vm?.uploadSpeedCurrentPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.uploadSpeedCurrentLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        vm?.downloadSpeedMeasuredPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.downloadSpeedMeasuredLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        vm?.uploadSpeedMeasuredPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.uploadSpeedMeasuredLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        
        
    }
}

