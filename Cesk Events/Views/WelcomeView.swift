import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    @State private var pressDuration: CGFloat = 0.0

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

                    ZStack {
                        if let url = URL(string: "https://imgs.search.brave.com/mXHeodIJ2N7S6HPB-1kz5beO79b3q67xLoF8-sIfjxU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/cG5nYWxsLmNvbS93/cC1jb250ZW50L3Vw/bG9hZHMvMjAxNi8w/Ni9GaW5nZXJwcmlu/dC1GcmVlLURvd25s/b2FkLVBORy5wbmc") {
                            NavigationLink(destination: LoginView()) {
                                InvertedImage(url: url)
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 100, height: 100)
                            .background(themeManager.buttonColor)
                            .clipShape(Circle())
                            .scaleEffect(isPressed ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
                            .simultaneousGesture(LongPressGesture(minimumDuration: 1.0)
                                .onChanged { _ in
                                    withAnimation(.linear(duration: 1.0)) {
                                        pressDuration = 1.0
                                    }
                                    withAnimation {
                                        isPressed = true
                                    }
                                }
                                .onEnded { _ in
                                    if pressDuration >= 1.0 {
                                        pressDuration = 0.0
                                        isPressed = false
                                    }
                                })

                            Circle()
                                .stroke(themeManager.buttonColor, lineWidth: 5)
                                .frame(width: 120, height: 120)
                                .opacity(0.2)

                            Circle()
                                .trim(from: 0, to: pressDuration)
                                .stroke(themeManager.buttonColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1.0), value: pressDuration)
                        }
                    }
                    .padding()
                }
            }
            .withThemeToggle()
        }
    }
}

struct InvertedImage: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .colorInvert()
                .contrast(2.0)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Session.shared)
        .environmentObject(ThemeManager())
}
