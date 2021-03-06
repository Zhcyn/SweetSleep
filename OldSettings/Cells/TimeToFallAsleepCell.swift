//
//  TimeToFallAsleepCell.swift
//  Sleepy-time
//
//  Created by Michael Sidoruk on 24.11.2019.
//  Copyright © 2019 Michael Sidoruk. All rights reserved.
//

import UIKit

protocol SettingsFallAlseepCellProtocol {
    var value: Double { get set }
}

class TimeToFallAsleepCell: UITableViewCell, SettingsCellProtocol {
    weak var settings: ManagedSettings!
    
    func set(with viewModel: OldSettingsItemProtocol) {
        guard let viewModel = viewModel as? OldSettingsFallAlseepItem else { return }
        fallAsleepSlider.value = Float(viewModel.value)
        fallAsleepLabel.text = generatedTextForLabel(Float(viewModel.value))
    }
    

    static let reuseId = "TimeToFallAsleepCell"
    
    //MARK: - FallAsleep Views
    lazy var fallAsleepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = generatedTextForLabel(self.fallAsleepSlider.value)
        label.textAlignment = .left
        label.font = UIFont(name: AppFonts.avenirBook, size: 17)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var fallAsleepSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 1
        slider.maximumValue = 45
        slider.value = 15
        // it's not necessarily, but just keep it here for an example
        if #available(iOS 13.0, *) {
            slider.minimumValueImage = UIImage(systemName: "zzz")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            slider.maximumValueImage = UIImage(systemName: "moon.zzz.fill")
        } else {
            // Fallback on earlier versions
        }
        slider.addTarget(self, action: #selector(self.sliderChangedValue), for: .valueChanged)
        return slider
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()

    //MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Configuration
    private func setupConstraints() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(fallAsleepLabel)
        stackView.addArrangedSubview(fallAsleepSlider)

        stackView.fillSuperview(padding: Constraints.cellPaddings)
    }
    
    @objc func sliderChangedValue(sender: UISlider) {
        fallAsleepLabel.text = generatedTextForLabel(sender.value)
        settings.fallAsleepTime = Int16(sender.value) as NSNumber
    }
    
    func generatedTextForLabel(_ value: Float) -> String {
        return "I usually fall asleep in around: \(Int16(value)) min"
    }
}
