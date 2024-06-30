import SwiftUI
import DBNetworking

struct LoginView: View {
    
    // MARK: - Variabili
    @State var email = "g.zarrelli@ied.edu"
    @State var password = "password"
    @State private var isPasswordVisible = false
    @State private var showSafariView = false
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var session: Session
    
    // Elenco di views che possono avere il focus
    enum Field: Int, Hashable {
        case email
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background color
            themeManager.backgroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Benvenuto! 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textColor) // Usa il colore del tema
                
                Text("Inserisci i tuoi dati per accedere")
                    .font(.callout)
                    .foregroundColor(themeManager.textColor)
                    .padding(.bottom, 8)
                
                // Email
                VStack(alignment: .leading) {
                    Text("Email:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor)
                    
                    TextField("Inserisci la tua email", text: $email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(PrimaryTextFieldStyle())
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                }
                
                // Password
                VStack(alignment: .leading) {
                    Text("Password:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor)
                    
                    ZStack(alignment: .trailing) {
                        Group {
                            if isPasswordVisible {
                                TextField("Inserisci la tua password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(PrimaryTextFieldStyle())
                            } else {
                                SecureField("Inserisci la tua password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(PrimaryTextFieldStyle())
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            // Premo il pulsante "Accedi"
                            Task { await login() }
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        .frame(height: 56)
                    }
                }
                
                // Link per recuperare la password
                HStack {
                    Text("Non ricordi la password?")
                        .foregroundColor(themeManager.textColor)
                    Button(action: {
                        showSafariView = true
                    }) {
                        Text("Recuperala")
                            .foregroundColor(themeManager.buttonColor)
                            .bold()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                // Pulsante di login
                HStack {
                    Spacer()
                    Button("Accedi") {
                        Task { await login() }
                    }
                    .buttonStyle(PrimaryButtonStyle(width: 320))
                    Spacer()
                }
                
                // Pulsante di accesso con Google
                HStack {
                    Spacer()
                    Button(action: {
                        // Azione di accesso con Google
                    }) {
                        HStack {
                            Spacer()
                            Spacer()
                            AsyncImage(url: URL(string: "https://imgs.search.brave.com/lBtw7l3MhojeV-JYt7sjdC3YR7IeRPqIBsZV4cpJMiM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9mcmVl/bG9nb3BuZy5jb20v/aW1hZ2VzL2FsbF9p/bWcvMTY1Nzk1MjQ0/MGdvb2dsZS1sb2dv/LXBuZy10cmFuc3Bh/cmVudC5wbmc")) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                            Text("Accedi con Google")
                                .foregroundColor(.white)
                            Spacer()
                            Spacer()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(width: 320))
                    Spacer()
                }
                
                HStack(spacing: 5) {
                    Spacer()
                    Text("Non hai un account?")
                        .foregroundColor(themeManager.textColor)
                    Button("Registrati") {}
                        .bold()
                        .foregroundColor(themeManager.buttonColor)
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showSafariView) {
                SafariView(url: "https://edu.davidebalistreri.it/app/events")
            }
        }
        .withThemeToggle() // Applica il modificatore per il toggle del tema
    }
    
    @MainActor func login() async {
        let request = DBNetworking.request(
            url: "https://edu.davidebalistreri.it/app/v3/login",
            type: .post,
            parameters: [
                "email": self.email,
                "password": self.password,
            ]
        )
        
        let response = await request.response(
            type: UserResponse.self
        )
        
        if let user = response.body?.data as? User {
            print("Nome: " + user.fullName)
            Session.shared.save(userToSave: user)
            session.isLogged = true // Aggiorna lo stato di autenticazione
        } else {
            print("Qualcosa è andato storto...")
        }
    }
}

#Preview {
    NavigationView {
        LoginView()
            .environmentObject(ThemeManager())
            .environmentObject(Session.shared)
    }
}
