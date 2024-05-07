//
//  NetworkImage.swift
//  Events2024
//
//  Created by iedstudent on 07/05/24.
//

import SwiftUI

struct NetworkImage: View {
    
    ///Url dell'immagine da visualizzare
    var url: String?
    
    var body: some View {
        AsyncImage(
            url: URL(string: self.url ?? ""),
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
    NetworkImage()
}
