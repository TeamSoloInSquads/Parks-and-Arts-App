import UIKit
import MapKit
import Contacts

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
    
    init?(json: [Any]){
        self.title = json[8] as? String ?? "No Title"
        self.parkType = json[9] as! String
        
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[18] as! String){
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }else{
            self.coordinate = CLLocationCoordinate2D()
        }
    }
 
    
    var subtitle: String?{
        return parkType
    }
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

