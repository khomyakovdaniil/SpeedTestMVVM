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
    
    var theme = UIUserInterfaceStyle(rawValue: SettingsManager.shared.getTheme()) ?? .unspecified
    
    var downloadUrl = SettingsManager.shared.getDownloadURL() ?? URL(string: Constants.DefaultServerUrls.download)!
    
    var uploadUrl = SettingsManager.shared.getUploadURL() ?? URL(string: Constants.DefaultServerUrls.upload)!
    
    var shouldTestDownload = !SettingsManager.shared.getSkipDownloadSpeed()
    
    var shouldTestUpload = !SettingsManager.shared.getSkipUploadSpeed()
    
    func userSelected(theme: Int) {
        guard let style = UIUserInterfaceStyle(rawValue: theme) else { return }
        SettingsManager.shared.saveTheme(theme)
    }
    
    func userEntered(downloadUrl: String) {
        guard let url = URL(string: downloadUrl) else { return }
        SettingsManager.shared.saveDownloadURL(url: url)
    }
    
    func userEntered(uploadUrl: String) {
        guard let url = URL(string: uploadUrl) else { return }
        SettingsManager.shared.saveUploadURL(url: url)
    }
    
    func userChecked(testDownload: Bool) {
        SettingsManager.shared.saveSkipDownloadSpeed(!testDownload)
    }
    
    func userChecked(testUpload: Bool) {
        SettingsManager.shared.saveSkipUploadSpeed(!testUpload)
    }
    
}
