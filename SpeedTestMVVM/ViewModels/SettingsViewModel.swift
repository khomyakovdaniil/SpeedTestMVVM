//
//  SettingsViewModel.swift
//  SpeedTestMVVM
//
//  Created by  Даниил Хомяков on 07.05.2024.
//

import Foundation
import UIKit

protocol SettingsViewModelProtocol {
    var theme: UIUserInterfaceStyle { get }
    var downloadUrl: URL { get }
    var uploadUrl: URL { get }
    var shouldTestDownload: Bool { get }
    var shouldTestUpload: Bool { get }
    func userSelected(theme: Int)
    func userEntered(downloadUrl: String)
    func userEntered(uploadUrl: String)
    func userChecked(testDownload: Bool)
    func userChecked(testUpload: Bool)
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    var settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        theme = UIUserInterfaceStyle(rawValue: settingsManager.getTheme()) ?? .unspecified
        downloadUrl = settingsManager.getDownloadURL() ?? URL(string: Constants.DefaultServerUrls.download)!
        uploadUrl = settingsManager.getUploadURL() ?? URL(string: Constants.DefaultServerUrls.upload)!
        shouldTestDownload = !settingsManager.getSkipDownloadSpeed()
        shouldTestUpload = !settingsManager.getSkipUploadSpeed()
    }
    
    var theme: UIUserInterfaceStyle
    
    var downloadUrl: URL
    
    var uploadUrl: URL
    
    var shouldTestDownload: Bool
    
    var shouldTestUpload: Bool
    
    
    func userSelected(theme: Int) {
        guard let style = UIUserInterfaceStyle(rawValue: theme) else { return }
        settingsManager.saveTheme(theme)
    }
    
    func userEntered(downloadUrl: String) {
        guard let url = URL(string: downloadUrl) else { return }
        settingsManager.saveDownloadURL(url: url)
    }
    
    func userEntered(uploadUrl: String) {
        guard let url = URL(string: uploadUrl) else { return }
        settingsManager.saveUploadURL(url: url)
    }
    
    func userChecked(testDownload: Bool) {
        settingsManager.saveSkipDownloadSpeed(!testDownload)
    }
    
    func userChecked(testUpload: Bool) {
        settingsManager.saveSkipUploadSpeed(!testUpload)
    }
    
}
