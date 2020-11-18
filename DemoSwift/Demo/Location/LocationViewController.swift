//
//  LocationViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/18.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    // 定位需要一个CLLocationManager
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // 检查定位权限
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        print("status: \(status.rawValue)")

        // 只需要一次定位
//        locationManager.distanceFilter = 10000
//        // 只需要定位到城市
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 代理
        manager.delegate = self
        // 只在用户登录时定位一次，不需要后台定位
        manager.allowsBackgroundLocationUpdates = false
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    let button = UIButton()
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupUI()
    }

}

// MARK: - user interaction
extension LocationViewController {
    @objc func onLocationButtonAction(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - setup UI
extension LocationViewController {
    func setupUI() {
        button.setTitle("定位", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(onLocationButtonAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        textField.textAlignment = .center
        textField.placeholder = "你的位置"
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(button.snp.top).offset(-20)
            $0.height.equalTo(25)
        }
    }
}

// MARK: - 定位
extension LocationViewController: CLLocationManagerDelegate {
    func setupManager() {
        // 检查定位权限
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        print("status: \(status.rawValue)")

        // 只需要一次定位
//        locationManager.distanceFilter = 10000
//        // 只需要定位到城市
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 代理
        locationManager.delegate = self
        // 只在用户登录时定位一次，不需要后台定位
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    //定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("time: \(location.timestamp)")
            //地理编码的类
            let gecoder = CLGeocoder()
            //反地理编码 转换成 具体的地址
            gecoder.reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
                //CLPlacemark －－ 国家 省 市
                if let placeMark = placeMarks?.first {
                    let defaultValue = ""
                    self?.textField.text = "\(placeMark.country ?? "") -- \(placeMark.administrativeArea ?? "") -- \(placeMark.locality ?? "")"
                    print("location: \(placeMark.location)")
                    print("locality: \(placeMark.locality ?? defaultValue)")
                    print("region: \(placeMark.region)")
                    print("timeZone: \(placeMark.timeZone)")
                    print("name: \(placeMark.name ?? defaultValue)")
                    print("thoroughfare: \(placeMark.thoroughfare ?? defaultValue)")
                    print("subThoroughfare: \(placeMark.subThoroughfare ?? defaultValue)")
                    print("subLocality: \(placeMark.subLocality ?? defaultValue)")
                    print("administrativeArea: \(placeMark.administrativeArea ?? defaultValue)")
                    print("subAdministrativeArea: \(placeMark.subAdministrativeArea ?? defaultValue)")
                    print("postalCode: \(placeMark.postalCode ?? defaultValue)")
                    print("isoCountryCode: \(placeMark.isoCountryCode ?? defaultValue)")
                    print("country: \(placeMark.country ?? defaultValue)")
                    print("inlandWater: \(placeMark.inlandWater ?? defaultValue)")
                    print("ocean: \(placeMark.ocean ?? defaultValue)")
                    print("areasOfInterest: \(placeMark.areasOfInterest)")
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }

    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
