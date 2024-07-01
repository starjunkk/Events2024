import SwiftUI

struct SplashView: View {
    @State var isAnimating = false
    @State var isAnimationDone = false
    @State var progress: CGFloat = 0.0
    @StateObject var session = Session.shared
    
    var body: some View {
        VStack {
            if isAnimationDone == false {
                ZStack {
                    NetworkImage(url: "https://imgs.search.brave.com/qDZo4rsb9P7yTG9_pIUZS6Gde0QYdaGUogAADN9n5MA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wbmdm/cmUuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy9uaWtlLWxvZ28t/MTktMTAyNHgxMDI0/LnBuZw")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .scaleEffect(isAnimating ? 1.7 : 10)
                        .opacity(isAnimating ? 1 : 0)
                    
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ui.orange)
                            .frame(width: progress * 150, height: 10)
                            .animation(.linear(duration: 2), value: progress)
                            .padding(.top, 200)
                    }
                }
                .onAppear {
                    withAnimation(.bouncy(duration: 2)) {
                        self.isAnimating = true
                    }
                    
                    Task {
                        withAnimation(.linear(duration: 2)) {
                            self.progress = 1.0
                        }
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        // Animazione completata vado all'homepage
                        withAnimation {
                            self.isAnimationDone = true
                            
                            // Carico l'utente precedentemente in sessione
                            Session.shared.load()
                        }
                    }
                }
            } else {
                if let isLogged = session.isLogged {
                    if isLogged {
                        HomeView()
                            .environmentObject(session)
                            .environmentObject(ThemeManager())
                    } else {
                        WelcomeView()
                            .environmentObject(session)
                            .environmentObject(ThemeManager())
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            Session.shared.load()
                        }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(Session.shared)
        .environmentObject(ThemeManager())
}
