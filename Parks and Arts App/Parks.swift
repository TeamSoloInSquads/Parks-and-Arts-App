import UIKit
import MapKit

class Parks : NSObject, MKAnnotation {
    let title: String?
    let parkType: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, parkType: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.parkType = parkType
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return title
    }
}

