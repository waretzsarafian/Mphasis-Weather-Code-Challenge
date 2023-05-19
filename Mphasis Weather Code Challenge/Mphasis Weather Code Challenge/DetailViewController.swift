//
//  DetailViewController.swift
//  Mphasis Weather Code Challenge
//
//  Created by Brett Sarafian on 5/18/23.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    var city: City?

    var weatherImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var tempLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var mainLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var visibilityLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCity()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupCity() {
        viewModel.getCityData { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let _ = self.viewModel.parseCityData(data)
                    self.city = self.viewModel.city
                    self.descriptionLabel.text = self.city?.weather.first?.description.uppercased()
                    self.tempLabel.text = "\(self.city?.main?.temp ?? 0.0) degrees Fahrenheit"
                    self.mainLabel.text = "\(self.city?.weather.first?.main ?? "")"
                    self.visibilityLabel.text = "Visibility: \(self.city?.visibility ?? 0)"
                    self.getIcon()
                }

            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }

    }

    private func setupUI() {
        self.view.backgroundColor = .white
        let safeArea = self.view.safeAreaLayoutGuide

        self.view.addSubview(weatherImageView)
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])

        self.view.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 16),
            tempLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        ])

        self.view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])

        self.view.addSubview(visibilityLabel)
        self.view.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            visibilityLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            mainLabel.topAnchor.constraint(equalTo: visibilityLabel.topAnchor),
            visibilityLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            mainLabel.leadingAnchor.constraint(equalTo: visibilityLabel.trailingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            mainLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            visibilityLabel.widthAnchor.constraint(equalTo: mainLabel.widthAnchor)
        ])
    }

    private func getIcon() {

        guard let iconString = viewModel.city?.weather[0].icon, let url = URL(string: "https://openweathermap.org/img/wn/\(iconString)@2x.png") else  { return }

        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    self.weatherImageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}
