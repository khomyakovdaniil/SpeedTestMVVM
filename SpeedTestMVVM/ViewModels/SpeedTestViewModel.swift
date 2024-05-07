//
//  SpeedTestViewModel.swift
//  SpeedTestMVVM
//
//  Created by  Даниил Хомяков on 06.05.2024.
//

import Foundation
import Combine

protocol SpeedTestViewModelProtocol: AnyObject {
    // Properties, declared with wrappers to ensure they are @Published
    var downloadSpeedCurrent: Double { get }
    var downloadSpeedCurrentPublished: Published<Double> { get }
    var downloadSpeedCurrentPublisher: Published<Double>.Publisher { get }
    
    var uploadSpeedCurrent: Double { get }
    var uploadSpeedCurrentPublished: Published<Double> { get }
    var uploadSpeedCurrentPublisher: Published<Double>.Publisher { get }
    
    var downloadSpeedMeasured: Double { get }
    var downloadSpeedMeasuredPublished: Published<Double> { get }
    var downloadSpeedMeasuredPublisher: Published<Double>.Publisher { get }
    
    var uploadSpeedMeasured: Double { get }
    var uploadSpeedMeasuredPublished: Published<Double> { get }
    var uploadSpeedMeasuredPublisher: Published<Double>.Publisher { get }
    
    // Runs the test, should be user initiated
    func startTest()
}

class SpeedTestViewModel: SpeedTestViewModelProtocol {
    
    init(speedManager: SpeedTestManager) {
        // SpeedTestManager returns speed via delegate
        speedManager.delegate = self
        self.speedTestManager = speedManager
        self.settingsManager = SettingsManager.shared
    }
    
    // Manager used to check speed
    private var speedTestManager: SpeedTestManager?
    
    private var settingsManager: SettingsManager?
    
    // Measured properies
    @Published var downloadSpeedCurrent: Double = 0
    @Published var uploadSpeedCurrent: Double = 0
    @Published var downloadSpeedMeasured: Double = 0
    @Published var uploadSpeedMeasured: Double = 0
    
    // Measured properies wrappers
    var downloadSpeedCurrentPublished: Published<Double> { _downloadSpeedCurrent }
    var downloadSpeedCurrentPublisher: Published<Double>.Publisher { $downloadSpeedCurrent }
    var uploadSpeedCurrentPublished: Published<Double> { _uploadSpeedCurrent }
    var uploadSpeedCurrentPublisher: Published<Double>.Publisher { $uploadSpeedCurrent }
    var downloadSpeedMeasuredPublished: Published<Double> { _downloadSpeedMeasured }
    var downloadSpeedMeasuredPublisher: Published<Double>.Publisher { $downloadSpeedMeasured }
    var uploadSpeedMeasuredPublished: Published<Double> { _uploadSpeedMeasured }
    var uploadSpeedMeasuredPublisher: Published<Double>.Publisher { $uploadSpeedMeasured }
    
    func startTest() {
        guard let settingsManager else { return }
        // Retrieve URL only if user wants a specific test, otherwise pass nil to speedTestManager
        let downloadURL = settingsManager.getSkipDownloadSpeed() ? nil : settingsManager.getDownloadURL()
        let uploadURL = settingsManager.getSkipUploadSpeed() ? nil : settingsManager.getUploadURL()
        
        speedTestManager?.checkSpeed(downloadURL: downloadURL, uploadURL: uploadURL)
    }
}

extension SpeedTestViewModel: SpeedTestManagerDelegateProtocol {
    
    // Receive values from speedTestManager
    
    func downloadTestFinished(with result: Double) {
        downloadSpeedMeasured = result
    }
    
    func uploadTestFinished(with result: Double) {
        uploadSpeedMeasured = result
    }
    
    func downloadSpeedChanged(to speed: Double) {
        downloadSpeedCurrent = speed
    }
    
    func uploadSpeedChanged(to speed: Double) {
        uploadSpeedCurrent = speed
    }
    
}
