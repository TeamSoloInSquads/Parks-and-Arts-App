import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: UIButton) {
        categoryButtons.forEach{(button) in UIView.animate(withDuration: 0.3, animations: { button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()})
        }
    }
    enum Categories: String {
        case all = "All"
        case parks = "Parks"
        case artwork = "Artwork"
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
        
        switch category{
            
        case .all:
            print("All")
        case .parks:
            print("Parks")
        case .artwork:
            print("Artwork")
        }
    }
    
    var parks: [Parks] = []
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "PublicParks", ofType: "json")
            else{return}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else{return}
        
        let validWorks = works.flatMap {Parks(json: $0)}
        parks.append(contentsOf: validWorks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 37.74140787, longitude: -122.43319872)
        let regionRadius: CLLocationDistance = 3000
        func centerMapOnLocation(location: CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        mapView.register(AnnotationMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialData()
        mapView.addAnnotations(parks)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Parks
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
