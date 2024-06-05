import SwiftUI

struct SplashView: View {
    
    @State var isAnimating = false
    
    @State var isAnimationDone = false
    
    // La sessione va salvata fuori dal body,
    // così SwiftuI riesce ad aggiornare la view automaticamente
    @StateObject var session = Session.shared
    
    var body: some View {
            VStack {
                if isAnimationDone == false {
                    ZStack {
                        Image("logoevents")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            .scaleEffect(isAnimating ? 1.7 : 10)
                            .opacity(isAnimating ? 1 : 0)
                    }
                    .onAppear {
                        withAnimation(.bouncy(duration: 2)) {
                            self.isAnimating = true
                        }
                        
                        Task {
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                            
                            // Animazione completata vado all'homepage
                            withAnimation {
                                self.isAnimationDone = true
                                
                                // Carico l'utente precedentemente in sessione
                                Session.shared.load()
                            }
                            
                        }
                        
                    }
                } else if session.isLogged  == true{
                    HomeView()
                } else {
                    WelcomeView()
                }
            }
    }
}

#Preview {
    SplashView()
}
