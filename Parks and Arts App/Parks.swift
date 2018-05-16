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
    //initializes the variables to the data within the json array depending on the value.
    init?(json: [Any]){
        self.title = json[8] as? String ?? "No Title"
        self.parkType = json[9] as! String
        //The coordinates were hidden within an array of different data types, so i had to make an array of Any to store that information.
        
        self.geo = json[18] as! [Any]
        //Then I to set the latitude and longitude to the specific element in that array of Any to get the corresponding coordinates.
        if let latitude = Double(geo[1] as? String ?? ""),
            let longitude = Double(geo[2] as? String ?? ""){
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }else{
            self.coordinate = CLLocationCoordinate2D()
        }
    }
 
    //What you read within the bubble when the annotation is clicked
    var subtitle: String?{
        return parkType
    }
    //Custom annotation icon
    var imageName: String?{
        return "parkIcon"
    }
    //Sets annotation colors depending on what the park type is. 
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
    
    //The Maps app takes this information to display the correct data
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

