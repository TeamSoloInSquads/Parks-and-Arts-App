import UIKit
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let type: String
    let geo: [Any]
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, type: String, geo: [Any], coordinate: CLLocationCoordinate2D){
        self.title = title
        self.type = type
        self.geo = geo
        self.coordinate = coordinate
        
        super.init()
    }
    
    init?(jsonArt: [Any]){
        self.title = jsonArt[9] as? String ?? "No Title"
        self.type = jsonArt[10] as! String
        self.geo = jsonArt[17] as! [Any]
        
        if let latitude = Double(geo[1] as? String ?? ""),
            let longitude = Double(geo[2] as? String ?? ""){
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }else{
            self.coordinate = CLLocationCoordinate2D()
        }
        
    }
    
    var subtitle: String?{
        return type
    }
    
    var iconName: String?{
        return "artIcon"
    }
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
}
