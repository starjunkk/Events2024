//
//  StringHelper.swift
//  Cesk Events
//
//  Created by iedstudent on 14/05/24.
//

import Foundation


struct StringHelper {
    
    static func formatDate(_ date: String?, in format: String) -> String {
        ///Fasi di validazione dei parametri
        if date == nil || format.isEmpty {
            return ""
        }
        
        ///Converto la stringa in un oggetto "Date"
        let dateFormatter = DateFormatter()
        
        ///Il server manda le date in questo modo
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let convertedDate = dateFormatter.date(from:  date ?? "")
        
        ///Riconverto l'oggetto "Date" in una stringa formattata come richiesto
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: convertedDate ?? Date())
        
    }
}
