import SwiftUI

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @EnvironmentObject var themeManager: ThemeManager

    // Elenco di views che possono avere il focus
    enum Field: Int, Hashable {
        case email
        case password
        case confirmPassword
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            // Background color
            themeManager.backgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Registrati")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textColor)

                Text("Inserisci i tuoi dati per registrarti.")
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
                        .environmentObject(themeManager) // Assicura che il themeManager sia passato al TextField
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
                                    .environmentObject(themeManager)
                            } else {
                                SecureField("Inserisci la tua password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(PrimaryTextFieldStyle())
                                    .environmentObject(themeManager)
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            focusedField = .confirmPassword
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

                // Confirm Password
                VStack(alignment: .leading) {
                    Text("Conferma Password:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor)

                    ZStack(alignment: .trailing) {
                        Group {
                            if isConfirmPasswordVisible {
                                TextField("Conferma la tua password", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(PrimaryTextFieldStyle())
                                    .environmentObject(themeManager)
                            } else {
                                SecureField("Conferma la tua password", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(PrimaryTextFieldStyle())
                                    .environmentObject(themeManager)
                            }
                        }
                        .focused($focusedField, equals: .confirmPassword)
                        .onSubmit {
                            // Azione di registrazione
                        }

                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        .frame(height: 56)
                    }
                }

                Spacer()

                // Pulsante di registrazione
                HStack {
                    Spacer()
                    Button("Registrati") {
                        // Azione di registrazione
                    }
                    .buttonStyle(PrimaryButtonStyle(width: 320))
                    Spacer()
                }

                // Pulsante di registrazione con Google
                HStack {
                    Spacer()
                    Button(action: {
                        // Azione di registrazione con Google
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
                            Text("Registrati con Google")
                                .foregroundColor(.white)
                            Spacer()
                            Spacer()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(width: 320))
                    Spacer()
                }

                Spacer()
            }
            .padding()
            .withThemeToggle()
        }
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(ThemeManager())
            .environmentObject(Session.shared)
    }
}
