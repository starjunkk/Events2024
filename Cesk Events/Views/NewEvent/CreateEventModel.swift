import SwiftUI
import CoreLocation

struct CreateEventModel {
    var name: String = ""
    var description: String = ""
    var price: String = ""
    var date: Date = Date()
    var address: String = ""
    var cover: UIImage?
    
    var coordinate: CLLocationCoordinate2D?
    
    // Formato della data per il server
    var dateStringForServer: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
