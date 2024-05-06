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
    
    // Labels to display test results
    @IBOutlet weak var downloadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var downloadSpeedMeasuredLabel: UILabel!
    @IBOutlet weak var uploadSpeedCurrentLabel: UILabel!
    @IBOutlet weak var uploadSpeedMeasuredLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func userDidTapTestSpeedButton(_ sender: Any) {
        vm?.startTest() // Initiate the test on button tap
    }
    
    // MARK: - Properties
    
    var vm: SpeedTestViewModelProtocol? // ViewModel
    
    private var cancellables: Set<AnyCancellable> = [] // Cancellables for Combine subscibers
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        
        // TODO: - proper dependecy injection for SpeedTestManager
        vm = SpeedTestViewModel(speedTestManager: SpeedTestManager()) // Creating viewModel
        
        bindData() // Binding viewModels data to UI
    }
    
    func bindData() {
        
        // vm downloadSpeedCurrent to relevant label
        vm?.downloadSpeedCurrentPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.downloadSpeedCurrentLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        // vm uploadSpeedCurrent to relevant label
        vm?.uploadSpeedCurrentPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.uploadSpeedCurrentLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        // vm downloadSpeedMeasured to relevant label
        vm?.downloadSpeedMeasuredPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.downloadSpeedMeasuredLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
        
        // vm uploadSpeedMeasured to relevant label
        vm?.uploadSpeedMeasuredPublisher
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.uploadSpeedMeasuredLabel.text = String(format: "%.2f", value)
                }
            }
            .store(in: &cancellables)
    }
}

