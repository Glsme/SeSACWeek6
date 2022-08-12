//
//  MapViewController.swift
//  SeSACWeek6
//
//  Created by Seokjune Hong on 2022/08/11.
//

import UIKit
import MapKit
// Location 1. 임포트
import CoreLocation
/*
 MapView
 - 지도와 위치 권한은 상관 X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한을 등록해주어야 함.
 - 중심, 범위 지정
 - 핀(어노테이션)
 */

/*
 권한: 반영이 조금씩 느릴 수 있음. 지웠다가 실행한다고 하더라도 한번 허용
 */

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //Location 2. 위치에 대한 대부분을 담당
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location 3. 프로토콜 연결
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorization()
        
        let center = CLLocationCoordinate2D(latitude: 37.621068, longitude: 127.041060)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 설정: 애플맵 활용하여 좌표 복사
        
        
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "산책하기 좋은 장소"
        
        // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }

}

// 위치 관련된 User Defined 메서드
extension MapViewController {
    // Location 7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    // 위치 서비스가 켜져있다면 권한을 요청하고, 꺼져있다면 커스텀 얼럿으로 상황 알려주기
    // CLAuthorizationStatus
    //- denined: 허용 안함/ 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    //- restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은 것으로 아예 제한
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //프로퍼티를 통해 lcationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인( 단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()  // 앱을 사용하는 동안에 위치 권한 요청
            // plist WhenInUse -> request 메서드 OK
//            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치를 허용해둔 상태라면, startUPdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}

// Location 4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    // Location 5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //ex. 위도 경도 기반으로 날씨 정보 조회
        //ex. 지도를 다시 세팅
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        
        // 위치 업데이트 멈춰!!
        locationManager.stopUpdatingLocation()
    }
    
    // Location 6. 사용자의 위치를 못가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // Location 9. 사용자의 권한 상태가 바뀔 때를 알려줌
    // 거부했다가 설정에서 변경, 혹은 not determined에서 허용을 했거나 등
    // iOS 14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}


//extension MapViewController: MKMapViewDelegate {
//     지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        <#code#>
//    }
//}
