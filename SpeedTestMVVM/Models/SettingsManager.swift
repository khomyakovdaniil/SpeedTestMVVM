//
//  SettingsManager.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 09.04.2024.
//

import Foundation
import UIKit

final class SettingsManager {
    
    static let shared = SettingsManager()
    
    // Only used for simpler syntax
    let setting = UserDefaults.standard
    
    
    // This is a helper class, and it has set of functions used for easier access to UserDefaults where we store all the user setting, all of them are just pairs of getting and setting values for keys
    
    func saveTheme(_ theme: Int) {
        self.setting.set(theme, forKey: Constants.SettinsKeys.theme)
        changeTheme(to: theme)
    }
    
    func getTheme() -> Int {
        return self.setting.integer(forKey: Constants.SettinsKeys.theme)
    }
    
    func saveDownloadURL( url: URL) {
        self.setting.set(url, forKey: Constants.SettinsKeys.downloadURL)
    }
    
    func getDownloadURL() -> URL? {
        // Here we provide a default value
        guard let url = URL(string: Constants.DefaultServerUrls.download) else { return nil }
        return self.setting.url(forKey: Constants.SettinsKeys.downloadURL) ?? url
    }
    
    func saveUploadURL( url: URL) {
        self.setting.set(url, forKey: Constants.SettinsKeys.uploadURL)
    }
    
    func getUploadURL() -> URL? {
        // Here we provide a default value
        guard let url = URL(string: Constants.DefaultServerUrls.upload) else { return nil }
        return self.setting.url(forKey: Constants.SettinsKeys.uploadURL) ?? url
    }
    
    func saveSkipDownloadSpeed(_ skip: Bool) {
        self.setting.set(skip, forKey: Constants.SettinsKeys.skipDownloadSpeed)
    }
    
    func getSkipDownloadSpeed() -> Bool {
        return self.setting.bool(forKey: Constants.SettinsKeys.skipDownloadSpeed)
    }
    
    func saveSkipUploadSpeed(_ skip: Bool) {
        self.setting.set(skip, forKey: Constants.SettinsKeys.skipUploadSpeed)
    }
    
    func getSkipUploadSpeed() -> Bool {
        return self.setting.bool(forKey: Constants.SettinsKeys.skipUploadSpeed)
    }

    
    // MARK: - Private functions
    
    private func changeTheme(to theme: Int) {
        switch theme {
        case 1:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
        case 2:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
        default:
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
