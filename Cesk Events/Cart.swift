

import Foundation

// Questa classe contiene tutto ciò che riguarda la gestione del carrello dell'app.
class Cart: ObservableObject {
    
    /// Da qui si può accedere al carrello da qualsiasi punto dell'app. (Stiamo usando il pattern Singleton).
    static var shared = Cart()
    
    @Published private(set) var items: [Event] = []
    
    // Funzione da utilizzare per aggiungere un evento al carrello.
    func add(item: Event) {
        self.items.append(item)
    }
    
    // Funzione da utilizzare per rimuovere un evento dal carrello.
    func remove(item: Event) {
        // Troviamo la posizione dell'evento nell'array mediante l'indice
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
        }
    }
    
    // Funzione da utilizzare per svuotare il carrello.
    func removeAll() {
        items.removeAll()
    }
    
    // TODO: Funzione per aggiungere eventi multipli al carrello.
    
    /// La somma dei costi di tutti gli eventi nel carrello (formattata in euro da centesimi).
    var totalPriceInEuro: String {
        var totalPrice = 0.0
        
        for item in items { // per ogni item dentro items
            if let price = item.price { // se c'è un prezzo, if price lo verifica e lo usa, altrimenti non potrei usare la somma con un null
                totalPrice += Double(price)
                
            }
        }
        
        // Converto i centesimi in €
        totalPrice = totalPrice / 100
        
        // formatto il double per lasciare solo due cifre dopo la virgola
        var priceFormatted = String(format:"%.2f €", totalPrice)
        
        // Sostituisco il punto con la virgola
        priceFormatted = priceFormatted.replacingOccurrences(of: ".", with: ",")
        
        return priceFormatted
    }
}
