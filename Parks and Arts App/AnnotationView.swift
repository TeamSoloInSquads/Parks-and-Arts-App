import UIKit
import MapKit

class AnnotationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            //configures the callout
            guard let parks = newValue as? Parks else { return }
           // guard let arts = newValue as? Artwork else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = parks.markerTintColor
            //Sets the information button to look like the map icon, so when the map icon is clicked
            //it will take the app into the map app
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            //sets the image of the annotation to match that of the custom one
            if let imageName = parks.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
            
            /*if let iconName = arts.iconName {
                glyphImage = UIImage(named: iconName)
            } else {
                glyphImage = nil
            }*/
        }
        
    }
    
}

