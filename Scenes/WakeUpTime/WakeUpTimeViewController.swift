//
//  WakeUpTimeViewController.swift
//  Sleepy-time
//
//  Created by Michael Sidoruk on 22.11.2019.
//  Copyright (c) 2019 Michael Sidoruk. All rights reserved.
//

import UIKit

protocol WakeUpTimeDisplayLogic: class {
    func displayData(viewModel: WakeUpTime.Model.ViewModel.ViewModelData)
}

class WakeUpTimeViewController: UIViewController, WakeUpTimeDisplayLogic {
    
    //MARK: - Bar buttons
    lazy var alarmBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: AppImages.addAlarm), style: .plain, target: self, action: #selector(handleBarButtonItemTapped))
        return barButtonItem
    }()
    
    @objc func handleBarButtonItemTapped() {
        guard let date = viewModel?.sleepyTime.choosenDate else { return }
        let alert = self.createAlarmTimeAlert(date: date)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Info Label. Up side
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            label.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        label.textAlignment = .center
        label.font = UIFont(name: AppFonts.avenirBook, size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Table View. Down side
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = #colorLiteral(red: 0.2570016384, green: 0.382270813, blue: 0.5108541846, alpha: 1)
        return tableView
    }()
    lazy var mpVolumeView: HiddenMPVolumeView = {
           let mpVolumeView = HiddenMPVolumeView()
           view.addSubview(mpVolumeView)
           return mpVolumeView
    }()
    
    // MARK: - Properties
    var interactor: WakeUpTimeBusinessLogic?
    var router: (NSObjectProtocol & WakeUpTimeRoutingLogic & WakeUpTimeDataPassing)?
    var viewModel: WakeUpTimeViewModel?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = WakeUpTimeInteractor()
        let presenter             = WakeUpTimePresenter()
        let router                = WakeUpTimeRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
    
    // MARK: - Routing
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        setupConstraints()
        setupTableView()
        setupNavigationBar()
        interactor?.makeRequest(request: .getWakeUpTime)
    }
    
    //MARK: - UI Configuration
    private func setupConstraints() {
        view.addSubview(infoLabel)
        view.backgroundColor = #colorLiteral(red: 0.2570016384, green: 0.382270813, blue: 0.5108541846, alpha: 1)
        view.addSubview(tableView)
        
        infoLabel.backgroundColor = #colorLiteral(red: 0.2570016384, green: 0.382270813, blue: 0.5108541846, alpha: 1)
        
        
        
        if #available(iOS 11.0, *) {
            infoLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: tableView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12))
        } else {
            // Fallback on earlier versions
        }
        tableView.anchor(top: infoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WakeUpTimeCell.self, forCellReuseIdentifier: WakeUpTimeCell.reuseId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Alarm Time"
        if viewModel?.sleepyTime.type == .toTime {
            self.navigationItem.rightBarButtonItem = alarmBarButton
        }
    }
    
    private func setupInfoLbl() {
        let date = viewModel?.sleepyTime.choosenDate.shortStyleString() ?? ""
        infoLabel.text = viewModel?.sleepyTime.type.getDescription(from: date)
    }
    
    func displayData(viewModel: WakeUpTime.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayWakeUpTime(let viewModel):
            self.viewModel = viewModel
            setupInfoLbl()
            setupNavigationBar()
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension WakeUpTimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpTimeCell.reuseId, for: indexPath) as? WakeUpTimeCell {
            if let alarmTime = viewModel?.cells[indexPath.row], let cellType = viewModel?.sleepyTime.type {
                cell.set(alarmTime: alarmTime, cellType: cellType)
                cell.contentView.backgroundColor = #colorLiteral(red: 0.2570016384, green: 0.382270813, blue: 0.5108541846, alpha: 1)
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let date = viewModel?.cells[indexPath.row].date else { return }
        if viewModel?.sleepyTime.type == .fromNowTime {
            let alert = self.createAlarmTimeAlert(date: date)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel?.sleepyTime.type == .toTime {
            tableView.isUserInteractionEnabled = false
        }
    }
}
