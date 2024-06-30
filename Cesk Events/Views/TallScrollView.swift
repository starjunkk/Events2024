import SwiftUI

// Fa funzionare la ScrollView anche con gli spacer che di norma la buggano. Da usare se metti elementi in più a ProfileView ecc.

struct TallScrollView<Content> : View where Content : View {
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    content
                }
                .frame(minHeight: geo.size.height)
            }
            .frame(minWidth: geo.size.width)
        }
    }
}

#Preview {
    TallScrollView {
        VStack {
            Text("Sopra")
            
            Spacer()
            Text("Spacer")
            Spacer()
            
            Text("Sotto")
        }
    }
}
