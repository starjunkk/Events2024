import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    AsyncImage(url: URL(string: "https://imgs.search.brave.com/QglKxd_WqEIDfD8Ahox9SZ7zpAw1O19WscizLNGZ99I/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9wbmdm/cmUuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy9uaWtlLWxvZ28t/MTktMTAyNHgxMDI0/LnBuZw")) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .padding(.bottom, 80)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 80)
                    }
                    
                    Text("Benvenuto! 👋")
                        .bold()
                        .font(.title)
                        .foregroundColor(themeManager.textColor)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Accedi")
                    }
                    .buttonStyle(PrimaryButtonStyle(width: 320))
                }
            }
            .withThemeToggle()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Session.shared)
        .environmentObject(ThemeManager())
}
