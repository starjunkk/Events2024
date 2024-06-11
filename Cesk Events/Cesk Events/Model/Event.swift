import Foundation

struct Event: Codable, Identifiable {

    var id: Int?
    
    var name: String?
    var description: String?
    var shortDescription: String?
    var date: String?
    
    var coverUrl: String?
    var price: Int?
    var address: String?
    var lat: Double?
    var lng: Double?
    
    var viewsCount: Int?
    var attendeesCount: Int?
    var likesCount: Int?
    var commentsCount: Int?
    var createdAt: String?
    var updatedAt: String?
    
    var user: User?
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Event {
    
    static var testEvent: Event {
        return Event(
            id: 1,
            name: "Evento per la preview",
            description: "È sopravvissuto non solo a più di cinque secoli, ma anche al passaggio alla videoimpaginazione, pervenendoci sostanzialmente inalterato. Fu reso popolare, negli anni ’60, con la diffusione dei fogli di caratteri trasferibili “Letraset”, che contenevano passaggi del Lorem Ipsum, e più recentemente da software di impaginazione come Aldus PageMaker, che includeva versioni del Lorem Ipsum.",
            date: "2024-07-21 12:30:00",
            coverUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Rondodasosa_2023.jpg/1200px-Rondodasosa_2023.jpg",
            price: 1999,
            address: "Via Roma, 18A",
            lat: 42, lng: 27, viewsCount: 1000,
            likesCount: 203,
            user: User(
                firstName: "David",
                lastName: "Ao"))
    }
    
    var priceInEuro: String {
        if price == nil || price! <= 0 {
            return "Gratis"
        }
        
        var priceDouble = Double(price!)
        
        // Converto i centesimi in €
        
        priceDouble = priceDouble / 100
        
        
        // formatto il double per lasciare solo due cifre dopo la virgola
        var priceFormatted = String(format:"%.2f €", priceDouble)
        
        // Sostituisco il punto con la virgola
        priceFormatted = priceFormatted.replacingOccurrences(of: ".", with: ",")
        
        return priceFormatted
    }
}
