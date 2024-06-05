import SwiftUI

struct ProfileView: View {
    
    @State var userToShow = Session.shared.loggedUser
    
    var body: some View {
        VStack{
            NetworkImage(url: "")
                .frame(width: 150, height: 150)
                .background(.blue)
                .clipShape(Circle())
            Text(userToShow?.fullName ?? "-")
                .font(.largeTitle)
            Text("Biografia")
            Button("Logout"){
                withAnimation{
                    // cancello utente dalla sessione
                    Session.shared.save(userToSave: nil)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}

#Preview {
    Session.shared.load()
    return ProfileView()
}
