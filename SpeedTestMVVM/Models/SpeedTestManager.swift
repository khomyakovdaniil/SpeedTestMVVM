//
//  SpeedTestManager.swift
//  SpeedTestMVVM
//
//  Created by  Даниил Хомяков on 05.05.2024.
//

import Foundation
import UIKit

protocol SpeedTestManagerProtocol: NSObject {
    // Manager passes the results via delegate
    var delegate: SpeedTestManagerDelegateProtocol? { get }
}

protocol SpeedTestManagerDelegateProtocol: AnyObject {
    // Sending the test results to delegate
    func downloadSpeedChanged(to: Double)
    func uploadSpeedChanged(to: Double)
    func downloadTestFinished(with result: Double)
    func uploadTestFinished(with result: Double)
}



class SpeedTestManager: NSObject, SpeedTestManagerProtocol {
    
    // MARK: - Init
    
    override init() {
        super.init()
        configureSession() // Initial URLSession setup
    }
    
    private func configureSession() {
        // Conguring URLSession, no cache storage and long timeout, delegate to self to read actual speed
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = Constants.standartTimeout
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    // MARK: - main properties
    
    weak var delegate: SpeedTestManagerDelegateProtocol? // Delegate to pass results
    
    // Values passed to delegate here for easy syntax
    var downloadSpeed: Double = 0 {
        didSet {
            delegate?.downloadSpeedChanged(to: downloadSpeed)
        }
    }
    var uploadSpeed: Double = 0 {
        didSet {
            delegate?.uploadSpeedChanged(to: uploadSpeed)
        }
    }
    
    // MARK: - private properties
    
    // Used to show result speed and launch upload test if needed
    private var downloadCompletionBlock: (() -> Void)?
    
    // Used to track progress
    private var startTime: CFAbsoluteTime!
    private var stopTime: CFAbsoluteTime!
    private var bytesReceived: Int!
    
    // Shared URL session
    private weak var session: URLSession?
    
    // Used to define if the test is currently in progress
    private var stateIsTestInProgress = false
    
    // Is either downloaded data or test image data
    private var data = NSMutableData()
    
    // Test image to get data for uploading
    private let image = UIImage(named: Constants.testImageName)!
    
    func checkSpeed() {
        
        guard !stateIsTestInProgress else { return }
        
        // Changing state to prevent user from starting multiple tests at the same time
        stateIsTestInProgress = true
        
        // Checking if the user wants to check download and upload speed
        let checkState: (Bool, Bool) = (!SettingsManager.shared.getSkipDownloadSpeed(), !SettingsManager.shared.getSkipUploadSpeed())
        
        switch checkState {
        case (true, false):
            // Running testDownload and showing results in completion
            testDownload { [weak self] in
                guard let self else { return }
                // Passing the result speed to delegate
                delegate?.downloadTestFinished(with: self.downloadSpeed)
                print("finished download")
                // Changing the state, so the user can run the test again
                stateIsTestInProgress = false
            }
        case (false, true):
            // If no data was downloaded previously then we use data from test image
            if data.isEmpty {
                data.append(image.pngData()!)
            }
            // Running test upload with given data
            self.testUpload(with: data as Data)
        case (true, true):
            // Running testDownload and testUpload afterwards
            testDownload { [weak self] in
                guard let self else { return }
                // Passing the result speed to delegate
                delegate?.downloadTestFinished(with: self.downloadSpeed)
                print("finished download")
                // Starting upload task
                self.testUpload(with: self.data as Data)
            }
        case (false, false):
            return
        }
    }
    
    // MARK: - Private functions
    
    private func testDownload(completionBlock: @escaping () -> Void) {
        
        // Retrieving server URL which is either default or user provided
        guard let url = SettingsManager.shared.getDownloadURL() else { return }
        
        // Resetting the timestamps and data count to calculate speed
        startTime = CFAbsoluteTimeGetCurrent()
        bytesReceived = 0
        
        // Saving the completion block to run it from delegate later
        downloadCompletionBlock = completionBlock
        
        // Running the download task
        session?.dataTask(with: url).resume()
    }
    
    private func testUpload(with data: Data) {
        
        // Retrieving server URL which is either default or user provided
        guard let url = SettingsManager.shared.getUploadURL() else { return }
        
        // Creating a upload request with proper body syntax
        guard let urlRequest = URLRequest(url: url).createDataUploadRequest(fileName: Constants.testImageName, data: data, mimeType: Constants.testImageMimeType) else {
            return
        }
        
        // Resetting the timer
        self.startTime = CFAbsoluteTimeGetCurrent()
        
        // Creating upload task with showing results in completion
        let uploadTask = session?.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            // Just basic debugging, can be removed
            guard let self else { return }
            if let error {
                print("error \(error.localizedDescription)")
            }
            else if let response {
                print("response \(response)")
            }
            print("finished uploading data \(data)")
            
            // Passing the result speed to delegate
            delegate?.uploadTestFinished(with: self.uploadSpeed)
            print("finished upload")
            
            // Changing the state, so the user can run the test again
            stateIsTestInProgress = false
        }
        
        // Running the upload task
        uploadTask?.resume()
    }
}

extension SpeedTestManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        // Calculate the size of data downloaded
        bytesReceived! += data.count
        
        // Saving the data to use it for upload test in the future
        self.data.append(data)
        
        // Calculating speed by dividing size by time
        stopTime = CFAbsoluteTimeGetCurrent()
        let elapsed = stopTime - startTime
        let speed = elapsed != 0 ? (Double(bytesReceived) / elapsed).bytesToMbit() : 0
        
        // Setting current speed
        self.downloadSpeed = speed
        
        print("download speed \(speed)")
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        // Running the completion block for download task which is either just showing
        downloadCompletionBlock?()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        // Calculating speed by dividing size by time
        self.stopTime = CFAbsoluteTimeGetCurrent()
        let elapsed = self.stopTime - self.startTime
        let speed = (Double(totalBytesSent) / elapsed ).bytesToMbit()
        
        // Setting current speed
        self.uploadSpeed = speed
        
        print("upload speed \(speed)")
    }
}

