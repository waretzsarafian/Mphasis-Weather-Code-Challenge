//
//  ViewController.swift
//  Mphasis Weather Code Challenge
//
//  Created by Brett Sarafian on 5/18/23.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    var locationManager: CLLocationManager?

    let searchTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let searchButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Get Weather", for: .normal)
        view.backgroundColor = .blue
        view.isEnabled = true
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        setupUI()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }

    private func setupUI() {
        let safeArea = self.view.safeAreaLayoutGuide
        let phoneSize = UIScreen.main.bounds
        self.view.addSubview(searchTextField)
        self.view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: phoneSize.width / 2),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: phoneSize.width / 2),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        searchButton.addTarget(self, action: #selector(getCityData), for: .touchUpInside)
    }

    @objc func getCityData() {
        if let cityName = searchTextField.text, cityName != "" {
            let viewModel = DetailViewModel(cityName: cityName)
            viewModel.getCityData { result in
                switch result {
                case .success(let data):
                    if viewModel.parseCityData(data) {
                        let viewController = DetailViewController(viewModel: viewModel)
                        self.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Error",
                                                      message: "We've encountered an error looking for that city, please check that it is spelled correctly", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Done", style: .cancel))
                        self.present(alert, animated: true)
                    }

                case .failure(_):
                    let alert = UIAlertController(title: "Error",
                                                  message: "We've encountered an error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension SearchViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    // do stuff
//                }
//            }
//        }
//    }
}

