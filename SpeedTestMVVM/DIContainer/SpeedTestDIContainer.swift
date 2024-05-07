//
//  SpeedTestDIContainer.swift
//  SpeedTestMVVM
//
//  Created by  Даниил Хомяков on 07.05.2024.
//

import Foundation
import UIKit

final class SpeedTestDIContainer {
    
    static let shared = SpeedTestDIContainer()
    
    private var services: [String: Any] = [:]
    
    func bind<Service>(service: Service.Type, resolver: @escaping (SpeedTestDIContainer) -> Service) {
        let key = String(describing: Service.self)
        self.services[key] = resolver(self)
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let service = services[key] as? Service else {
            fatalError("\(type) service not registered")
        }
        return service
    }
    
    static func registerDependencies() {
        shared.bind(service: SettingsManager.self) { resolver in
            return SettingsManager.shared
        }
        
        shared.bind(service: SpeedTestManagerProtocol.self) { resolver in
            return SpeedTestManager()
        }
        
        shared.bind(service: SpeedTestViewController.self) { resolver in
            let settingsManager = resolver.resolve(SettingsManager.self)
            let speedTestManager = resolver.resolve(SpeedTestManagerProtocol.self)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vm = SpeedTestViewModel(speedManager: speedTestManager, settingsManager: settingsManager)
            let vc = storyboard.instantiateViewController(identifier: "SpeedTestViewController", creator: { coder in
                return SpeedTestViewController(coder: coder, speedTestViewModel: vm)
            })
            return vc
        }
        
        shared.bind(service: SettingsViewController.self) { resolver in
            let settingsManager = resolver.resolve(SettingsManager.self)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vm = SettingsViewModel(settingsManager: settingsManager)
            let vc = storyboard.instantiateViewController(identifier: "SettingsViewController", creator: { coder in
                return SettingsViewController(coder: coder, settingsViewModel: vm)
            })
            return vc
        }
        
    }
}
