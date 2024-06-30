//
//  Session.swift
//  Cesk Events
//
//  Created by iedstudent on 28/05/24.
//

import Foundation

class Session: ObservableObject {
    
    /// Utilizzo il pattern "Singleton" per avere un'unica Sessione di tutta l'app
    static var shared = Session()
    
    /// L'utente eventualmente connesso all'app
    @Published var loggedUser: User?
    
    /// Indica se un utente è connesso
    /// true : utente connesso
    /// false : utente non connesso
    /// nil : ancora non abbiamo controllato se l'utente è connesso
    @Published var isLogged: Bool?
    
    private let databaseKey = "LoggedUser"
    
    /// Da utilizzare per salvare un utente in sessione
    /// oppure eliminarlo dalla sessione (passando nil).
    func save(userToSave: User?) {
        // Aggiorno le proprietà osservate dalla SplashView
        self.loggedUser = userToSave
        
        // Salvo l'utente sul database dell'app
        if let user = userToSave {
            self.isLogged = true
            // Converto l'oggetto da user a dati, così posso salvarlo
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: databaseKey)
            }
        } else {
            self.isLogged = false
            UserDefaults.standard.removeObject(forKey: databaseKey)
        }
    }
    
    /// Da utilizzare per caricare l'utente dal database.
    func load() {
        guard let data = UserDefaults.standard.data(forKey: databaseKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            self.loggedUser = nil
            self.isLogged = false
            return
        }
        
        self.loggedUser = user
        self.isLogged = true
    }
}
