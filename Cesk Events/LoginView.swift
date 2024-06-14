import SwiftUI
import DBNetworking

struct LoginView: View {
    
    //MARK: - Variabili
    
    @State var email = "g.zarrelli@ied.edu"
    @State var password = "password"
    @State private var isPasswordVisible = false
    @State private var showSafariView = false
    
    // Elenco di views che possono avere il focus
    enum Field: Int, Hashable {
        case email
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    //MARK: - UI
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Inserisci i tuoi dati per accedere")
                .font(.callout)
                .padding(.bottom, 8)
            
            Text("Email:")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .textFieldStyle(PrimaryTextFieldStyle())
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
            
            Text("Password:")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(PrimaryTextFieldStyle())
                    } else {
                        SecureField("", text: $password)
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
            
            HStack {
                Text("Non ricordi la password?")
                Button(action: {
                    showSafariView = true
                }) {
                    Text("Recuperala")
                        .foregroundColor(.blue)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            Button("Accedi") {
                Task { await login() }
            }
            .buttonStyle(PrimaryButtonStyle())
            
            HStack(spacing: 5) {
                Spacer()
                Text("Non hai un account?")
                Button("Registrati") {}
                    .bold()
                    .foregroundStyle(.blue)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Bentornato")
        .sheet(isPresented: $showSafariView) {
            SafariView(url: "https://edu.davidebalistreri.it/app/events")
        }
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
        } else {
            print("Qualcosa è andato storto...")
        }
    }
}

#Preview {
    NavigationView {
        LoginView()
    }
}
