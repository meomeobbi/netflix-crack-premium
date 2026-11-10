import SwiftUI

struct ContentView: View {
    // 0 = splash Gemini, 1 = OnlyFans
    @State private var phase: Int = 0
    @State private var showPopup = false

    var body: some View {
        ZStack {
            if phase == 1 {
                WebView(url: URL(string: "https://onlyfans.com")!)
                    .ignoresSafeArea()
            } else {
                // Man hinh cho giong Gemini that (khong thay doi)
                ZStack {
                    Color.white.ignoresSafeArea()
                    VStack(spacing: 28) {
                        Image("gemini_sparkle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        Text("Gemini")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 66 / 255, green: 133 / 255, blue: 244 / 255)))
                            .scaleEffect(1.4)
                    }
                }
            }

            // Popup nho hien khi vua vao OnlyFans
            if showPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showPopup = false }
                    VStack(spacing: 10) {
                        Text("haha bị lừa rồi")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("tele : uwalie")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Divider()
                            .padding(.top, 4)
                        Button("OK") {
                            showPopup = false
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(width: 250)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(radius: 12)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            // Cho app "load" 4 giay roi vao OnlyFans
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if phase == 0 {
                    phase = 1
                    // Vua vao OnlyFans thi hien popup
                    showPopup = true
                }
            }
        }
    }
}
