import SwiftUI

struct ContentView: View {
    // 0 = splash Netflix, 1 = OnlyFans
    @State private var phase: Int = 0

    var body: some View {
        ZStack {
            if phase == 1 {
                WebView(url: URL(string: "https://onlyfans.com")!)
                    .ignoresSafeArea()
            } else {
                // Man hinh cho giong Netflix that
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 48) {
                        NetflixN()
                            .frame(width: 180, height: 260)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            .scaleEffect(1.6)
                    }
                }
            }
        }
        .onAppear {
            // Cho app "load" 4 giay roi vao thang OnlyFans
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if phase == 0 {
                    phase = 1
                }
            }
        }
    }
}

// Chu N do kieu Netflix (2 cot + duong cheo)
struct NetflixN: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 229 / 255, green: 9 / 255, blue: 20 / 255))
                .frame(width: 54, height: 240)
                .offset(x: -54)
            Rectangle()
                .fill(Color(red: 229 / 255, green: 9 / 255, blue: 20 / 255))
                .frame(width: 54, height: 240)
                .offset(x: 54)
            Rectangle()
                .fill(Color(red: 176 / 255, green: 18 / 255, blue: 32 / 255))
                .frame(width: 54, height: 268)
                .rotationEffect(.degrees(24))
        }
    }
}
