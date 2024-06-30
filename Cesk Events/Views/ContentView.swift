import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: Session

    var body: some View {
        Group {
            if session.isLogged == true {
                MainView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            session.load()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
        .environmentObject(Session.shared)
}
