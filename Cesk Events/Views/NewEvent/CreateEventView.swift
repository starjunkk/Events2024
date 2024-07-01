import SwiftUI
import PhotosUI

struct CreateEventView: View {
    @StateObject private var viewModel = CreateEventViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) private var presentationMode // Per poter chiudere la view
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Crea Evento")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                        
                        // Nome Evento
                        VStack(alignment: .leading) {
                            Text("Nome:")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            TextField("Inserisci il nome dell'evento", text: $viewModel.event.name)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .foregroundColor(themeManager.textFieldTextColor)
                                .background(themeManager.textFieldBackgroundColor)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themeManager.textFieldBorderColor, lineWidth: 1)
                                )
                        }
                        
                        // Descrizione Evento
                        VStack(alignment: .leading) {
                            Text("Descrizione:")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            TextField("Inserisci la descrizione dell'evento", text: $viewModel.event.description)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .foregroundColor(themeManager.textFieldTextColor)
                                .background(themeManager.textFieldBackgroundColor)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themeManager.textFieldBorderColor, lineWidth: 1)
                                )
                        }
                        
                        // Prezzo Evento
                        VStack(alignment: .leading) {
                            Text("Prezzo:")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            TextField("Inserisci il prezzo dell'evento", text: $viewModel.event.price)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .foregroundColor(themeManager.textFieldTextColor)
                                .background(themeManager.textFieldBackgroundColor)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themeManager.textFieldBorderColor, lineWidth: 1)
                                )
                        }
                        
                        // Data Evento
                        VStack(alignment: .leading) {
                            Text("Data:")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            DatePicker("Seleziona la data", selection: $viewModel.event.date, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .accentColor(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange) // Cambia il pallino blu in arancione
                                .environment(\.colorScheme, themeManager.isDarkMode ? .dark : .light)
                                .tint(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange)
                        }
                        
                        // Copertina Evento
                        VStack(alignment: .leading) {
                            Text("Copertina:")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            if let image = viewModel.event.cover {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(themeManager.textColor, lineWidth: 1)
                                    )
                            }
                            
                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Text("Seleziona immagine di copertina")
                                   
                            }.buttonStyle(PrimaryButtonStyle(width: 320))
                            
                            .onChange(of: selectedPhoto) { _ in
                                Task {
                                    await viewModel.updateCover(selectedPhoto: selectedPhoto)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Pulsante per creare l'evento
                        HStack {
                            Spacer()
                            Button("Crea Evento") {
                                print("Evento creato: \(viewModel.event)")
                            }
                            .buttonStyle(PrimaryButtonStyle(width: 320))
                            Spacer()
                        }
                    }
                    .padding()
                }
                .navigationTitle("Crea Evento")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            themeManager.isDarkMode.toggle()
                        }) {
                            Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                                .foregroundColor(themeManager.buttonColor)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(themeManager.buttonColor)
                        }
                    }
                }
            }
        }
    }
}

@MainActor class CreateEventViewModel: ObservableObject {
    @Published var event = CreateEventModel()
    
    func updateCover(selectedPhoto: PhotosPickerItem?) async {
        guard let photoData = try? await selectedPhoto?.loadTransferable(type: Data.self),
              let image = UIImage(data: photoData) else {
            return
        }
        
        self.event.cover = image
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateEventView()
                .environmentObject(ThemeManager())
                .environmentObject(Session.shared)
        }
    }
}
