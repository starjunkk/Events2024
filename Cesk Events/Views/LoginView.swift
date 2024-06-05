//
//  LoginView.swift
//  Cesk Events
//
//  Created by iedstudent on 21/05/24.
//

import SwiftUI
import DBNetworking

struct LoginView: View {
    
    //MARK: - Variabili
    
    @State var email = "g.zarrelli@ied.edu"
    
    @State var password = "password"
    
    //MARK:  - UI
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Inserisci i tuoi dati per accedere")
                .font(.callout)
                .padding(.bottom, 8)
            TextField("", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .textFieldStyle(PrimaryTextFieldStyle())
            
            TextField("", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(PrimaryTextFieldStyle())
            
            Spacer()
            
            Button("Accedi"){

                            Task { await login() }

                        } .buttonStyle(PrimaryButtonStyle())

                        

                        HStack(spacing: 5) {

                            Text("Non hai un account?")

                            Button("Registrati"){}

                                .bold()

                                .foregroundStyle(.blue)

                        }

                    }

                    .padding()

                    .navigationTitle("Bentornato")

                }

                

                

                

                @MainActor func login() async {

                    let request = DBNetworking.request(

                        url:"https://edu.davidebalistreri.it/app/v3/login",

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

                        

                        Session.shared.save(userToSave : user)

                        

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
