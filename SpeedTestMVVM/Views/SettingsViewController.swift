//
//  SettingsViewController.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 09.04.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var themePickerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var downloadUrlTextField: UITextField!
    @IBOutlet weak var uploadUrlTextField: UITextField!
    @IBOutlet weak var downloadSpeedCheckBox: UIButton!
    @IBOutlet weak var uploadSpeedCheckBox: UIButton!
    
    // MARK: - ViewModel
    
    var vm: SettingsViewModelProtocol = SettingsViewModel(settingsManager: SettingsManager.shared)
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    
    @IBAction func themePickerValueChanged(_ sender: UISegmentedControl) {
        // Passing input to viewModel
        vm.userSelected(theme: sender.selectedSegmentIndex)
    }
    @IBAction func downloadUrlTextFieldChanged(_ sender: UITextField) {
        // Passing input to viewModel
        vm.userEntered(downloadUrl: sender.text ?? "")
    }
    @IBAction func uploadUrlTextFieldChanged(_ sender: UITextField) {
        // Passing input to viewModel
        vm.userEntered(uploadUrl: sender.text ?? "")
    }
    @IBAction func downloadSpeedCheckBoxTapped(_ sender: UIButton) {
        // Emulate checkbox behaviour
        sender.isSelected = !sender.isSelected
        
        // Passing input to viewModel
        vm.userChecked(testDownload: sender.isSelected)
    }
    @IBAction func uploadSpeedCheckBoxTapped(_ sender: UIButton) {
        // Emulate checkbox behaviour
        sender.isSelected = !sender.isSelected
        
        // Passing input to viewModel
        vm.userChecked(testUpload: sender.isSelected)
    }
    
    private func setupViews() {
        // Retrieving actual settings and settings the views accordingly
        themePickerSegmentedControl.selectedSegmentIndex = vm.theme.rawValue
        downloadUrlTextField.text = vm.downloadUrl.absoluteString
        uploadUrlTextField.text = vm.uploadUrl.absoluteString
        downloadSpeedCheckBox.isSelected = vm.shouldTestDownload
        uploadSpeedCheckBox.isSelected = vm.shouldTestUpload
    }

}
