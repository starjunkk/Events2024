//
//  LocationHelper.swift
//  Eventi Balistreri
//
//  Created by Balistreri Davide on 29/11/22.
//

import MapKit

struct LocationHelper {
    
    static func address(from coordinate: CLLocationCoordinate2D?) async -> String? {
        guard let coordinate = coordinate else { return nil }
        
        // Converto le coordinate geografiche nel nome dell'indirizzo
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        
        // Solitamente il geocoding restituisce un array con un solo risultato
        return address(from: placemarks?.first)
    }
    
    static func coordinate(from address: String?) async -> CLLocationCoordinate2D? {
        // Converto l'indirizzo inserito dall'utente in coordinate geografiche
        let geocoder = CLGeocoder()
        
        let placemarks = try? await geocoder.geocodeAddressString(address ?? "")
        
        // Solitamente il geocoding restituisce un array con un solo risultato
        return placemarks?.first?.location?.coordinate
    }
    
    /// Questa funzione restituisce una stringa composta dell'indirizzo partendo da un CLPlacemark.
    private static func address(from placemark: CLPlacemark?) -> String {
        // Creo un array per inserire tutte le proprietà dell'indirizzo che mi servono ed esistono
        var components: [String] = []
        
        // Aggiungo il nome della via (solo se il geocoder è riuscito a determinarla)
        if let thoroughfare = placemark?.thoroughfare {
            components.append(thoroughfare)
        }
        
        // Aggiungo il civico
        if let subThoroughfare = placemark?.subThoroughfare {
            components.append(subThoroughfare)
        }
        
        // Aggiungo il CAP
        if let postalCode = placemark?.postalCode {
            components.append(postalCode)
        }
        
        // Aggiungo la città
        if let locality = placemark?.locality {
            components.append(locality)
        }
        
        // Aggiungo la regione
        // if let administrativeArea = placemark?.administrativeArea {
        //     components.append(administrativeArea)
        // }
        
        // Aggiungo lo stato
        if let country = placemark?.country {
            components.append(country)
        }
        
        // Creo una stringa con gli elementi presenti sull'array, separandoli con una virgola
        return components.joined(separator: ", ")
    }
    
    static func navigateTo(
        destinationCoordinate: CLLocationCoordinate2D,
        destinationName: String
    ) {
        // Controllo che le coordinate siano valide
        if check(coordinate: destinationCoordinate) == false {
            // Coordinate non valide
            // Interrompo l'esecuzione di questa funzione con un "return"
            return
        }
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let mapItem = MKMapItem(placemark: destinationPlacemark)
        mapItem.name = destinationName
        
        // Apro le mappe di Apple
        mapItem.openInMaps(launchOptions: nil)
    }
    
    static func check(coordinate: CLLocationCoordinate2D?) -> Bool {
        // 1. Controllo se effettivamente esistono le coordinate specificate
        if coordinate == nil {
            // Coordinate non valide (non esistono)
            return false
        }
        
        // 2. Controllo con la funzione di Apple
        if CLLocationCoordinate2DIsValid(coordinate!) == false {
            // Apple dice che non sono valide
            return false
        }
        
        // 3. Controllo se sono in mezzo all'oceano atlantico (null island)
        if coordinate?.latitude == 0 || coordinate?.longitude == 0 {
            // Isola di null
            return false
        }
        
        // Controlli superati, le coordinate sono valide
        return true
    }
    
    private init() {}
    
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
