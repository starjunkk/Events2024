//
//  NetworkImage.swift
//  Cesk Events
//
//  Created by iedstudent on 07/05/24.
//

import SwiftUI

struct NetworkImage: View {
    
    ///L'url dell'immagine da scaricare da internet da visualizzare
    var url: String?
    
    var body: some View {
        AsyncImage(
            url: URL.init(string:self.url ?? ""),
            content: { image in
                VStack {}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        image.resizable().scaledToFill()
                    }
                    },
            placeholder: {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        )
    }
}

#Preview {
    NetworkImage( url: "https://imgs.search.brave.com/tvYm9n_Mzx_Jsu6dpzhF39xQbySASInuQFJN5RLtWOQ/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS50aW1lb3V0LmNv/bS9pbWFnZXMvMTA1/MzAyOTYyLzc1MC81/NjIvaW1hZ2UuanBn")
}
