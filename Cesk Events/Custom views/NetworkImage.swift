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
    NetworkImage( url: "https://lh3.googleusercontent.com/proxy/4973GJPvdYPfiMuI9O-MRKtPAKcXrhKPFNkXUBK0Pg-bDBI40daBGPXk1Yuqr-cEZd3j-LdrVqHbSLTZqAXQZFuBt-9nSLC4iwD-bNmuTWgBEUVpMGJ4S3HDvy8CyOemg1PY")
}
