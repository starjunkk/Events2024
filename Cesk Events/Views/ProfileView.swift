import SwiftUI

struct ProfileView: View {
    @State var userToShow = Session.shared.loggedUser
    @State private var showSafariView = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            if let user = userToShow {
                NetworkImage(url: user.avatarUrl ?? "https://imgs.search.brave.com/UigQD9D2I-9V4xyACeddHs5jzPo_qZmO71xwUHqesF8/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9mYnJl/Zi5jb20vcmVxLzIw/MjMwMjAzMC9pbWFn/ZXMvaGVhZHNob3Rz/L2RlYTY5OGQ5XzIw/MjIuanBn")
                    .frame(width: 150, height: 150)
                    .background(.blue)
                    .clipShape(Circle())
                
                Text(user.fullName)
                    .font(.largeTitle)
                    .foregroundColor(themeManager.textColor)
                
                Text(user.bio ?? "")
                    .foregroundColor(themeManager.textColor)
                    .padding(.top, 8)
                
                Button("Logout") {
                    withAnimation {
                        // Cancello utente dalla sessione
                        Session.shared.save(userToSave: nil)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 16)
                
                Button("FAQ") {
                    showSafariView = true
                }
                .foregroundColor(themeManager.buttonColor)
                .bold()
                .padding(.top, 10)
            } else {
                Text("Nessun utente connesso")
                    .foregroundColor(themeManager.textColor)
            }
        }
        .padding()
        .sheet(isPresented: $showSafariView) {
            SafariView(url: "https://edu.davidebalistreri.it/app/events")
        }
        .background(themeManager.backgroundColor.ignoresSafeArea())
        .withThemeToggle()
    }
}

#Preview {
    ProfileView()
        .environmentObject(ThemeManager())
        .environmentObject(Session.shared)
}
