import SwiftUI

struct ProfileView: View {
    
    @State var userToShow = Session.shared.loggedUser
    @State private var showSafariView = false
    
    var body: some View {
        VStack {
            NetworkImage(url: userToShow?.avatarUrl ?? "https://imgs.search.brave.com/UigQD9D2I-9V4xyACeddHs5jzPo_qZmO71xwUHqesF8/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9mYnJl/Zi5jb20vcmVxLzIw/MjMwMjAzMC9pbWFn/ZXMvaGVhZHNob3Rz/L2RlYTY5OGQ5XzIw/MjIuanBn")
                .frame(width: 150, height: 150)
                .background(.blue)
                .clipShape(Circle())
            
            Text(userToShow?.fullName ?? "Giovanni Zarrelli")
                .font(.largeTitle)
            
            Text(userToShow?.bio ?? "Siu")
                .padding(.top, 8)
            
            Button("Logout") {
                withAnimation {
                    // cancello utente dalla sessione
                    Session.shared.save(userToSave: nil)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 16)
            
            Button("FAQ") {
                showSafariView = true
            }
            .bold()
            .padding(.top, 10)
        }
        .padding()
        .sheet(isPresented: $showSafariView) {
            SafariView(url: "https://edu.davidebalistreri.it/app/events")
        }
    }
}

#Preview {
    Session.shared.load()
    return ProfileView()
}
