import UIKit
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let type: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, type: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.type = type
        self.coordinate = coordinate
        
        super.init()
    }
    
    
}
