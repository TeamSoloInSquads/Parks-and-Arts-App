import UIKit
import MapKit
import Contacts

class Parks : NSObject, MKAnnotation {
    let title: String?
    let parkType: String
    let geo: [Any]
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, parkType: String, geo: [Any], coordinate: CLLocationCoordinate2D){
        self.title = title
        self.parkType = parkType
        self.coordinate = coordinate
        self.geo = geo
        
        super.init()
    }
    
    init?(json: [Any]){
        self.title = json[8] as? String ?? "No Title"
        self.parkType = json[9] as! String
        
        self.geo = json[18] as! [Any]
        
        if let latitude = Double(geo[1] as? String ?? ""),
            let longitude = Double(geo[2] as? String ?? ""){
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }else{
            self.coordinate = CLLocationCoordinate2D()
        }
    }
 
    
    var subtitle: String?{
        return parkType
    }
    
    var imageName: String?{
        return "parkIcon"
    }
    
    var markerTintColor: UIColor{
        switch parkType{
        case "Neighborhood Park or Playground":
            return .green
        case "Mini Park":
            return .blue
        case "Community Garden":
            return .yellow
        default:
            return .black
        }
        
    }
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

