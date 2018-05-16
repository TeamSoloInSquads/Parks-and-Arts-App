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
    //Drop down menu which displays annotations depending on what category is selected.
    @IBAction func categoryPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
        switch category{
        case .all:
            print("All")
        case .parks:
            print("Parks")
            mapView.addAnnotations(parks)
        case .artwork:
            print("Artwork")
        }
    }
    
    var parks: [Parks] = []
    var arts: [Artwork] = []
    
    func loadInitialData() {
        //gather data from the public park json file and stores that information within the app.
        guard let fileName = Bundle.main.path(forResource: "PublicParks", ofType: "json")
            else{return}
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else{return}
        
        guard let fileNameArtwork = Bundle.main.path(forResource: "PublicArts", ofType: "json")
            else{return}
        let optionalDataArt = try? Data(contentsOf: URL(fileURLWithPath: fileNameArtwork))
        
        guard
            let dataArt = optionalDataArt,
            let jsonArt = try? JSONSerialization.jsonObject(with: dataArt),
            let dictionaryArt = jsonArt as? [String: Any],
            let worksArt = dictionaryArt["data"] as? [[Any]]
            else{return}
        
        let validWorksArt = worksArt.flatMap {Artwork(jsonArt: $0)}
        arts.append(contentsOf: validWorksArt)
        
        
        let validWorks = works.flatMap {Parks(json: $0)}
        parks.append(contentsOf: validWorks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //sets default location of user, which SF State.
        let initialLocation = CLLocation(latitude: 37.7219, longitude: -122.4782)
        let regionRadius: CLLocationDistance = 2000
        func centerMapOnLocation(location: CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        //centers the app at the initial location
        centerMapOnLocation(location: initialLocation)
        
        //registers the annotation class in order to use the custom annotations I created.
        mapView.register(AnnotationMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //loads the data from parks json file
        loadInitialData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
extension ViewController: MKMapViewDelegate {

    //Tells mapkit what to do when the user clicks on the annotation marker.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Parks
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
