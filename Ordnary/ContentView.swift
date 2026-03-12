//
//  ContentView.swift
//  Ordnary
//

import SwiftUI
#if os(iOS)
import UIKit

struct SelectAllTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.delegate = context.coordinator
        tf.returnKeyType = .search
        tf.backgroundColor = .clear
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 17, weight: .regular)
        tf.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        DispatchQueue.main.async { tf.becomeFirstResponder() }
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text { uiView.text = text }
        let appearance: UIKeyboardAppearance = colorScheme == .dark ? .dark : .light
        if uiView.keyboardAppearance != appearance {
            uiView.keyboardAppearance = appearance
            uiView.reloadInputViews()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: SelectAllTextField
        init(_ parent: SelectAllTextField) { self.parent = parent }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.selectAll(nil)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onSubmit()
            return true
        }

        @objc func textChanged(_ tf: UITextField) {
            parent.text = tf.text ?? ""
        }
    }
}
#endif

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var word = ""
    @State private var colorSchemeOverride: ColorScheme? = nil

#if os(iOS)
    private var keyWindow: UIWindow? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
    }
#endif

    func define() {
        word = word.trimmingCharacters(in: .whitespaces)
        showDefinition(for: word)
    }

    var body: some View {
        NavigationStack {
            Spacer()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: toggleColorScheme) {
                            Image(systemName: colorScheme == .dark ? "sun.max.fill" : "moon.fill")
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 8) {
                        SelectAllTextField(text: $word, placeholder: "Enter a word", onSubmit: define)
                            .padding(.leading, 16)
                            .frame(height: 44)

                        Button(action: define) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32, weight: .medium))
                                .symbolRenderingMode(.multicolor)
                                .foregroundStyle(.blue)
                        }
                        .padding(.trailing, 6)
                    }
                    .frame(height: 52)
                    .glassEffect(in: Capsule())
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .background {
                    Image("letters-wallpaper")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .overlay(alignment: .top) {
                            LinearGradient(
                                colors: [.black.opacity(0.4), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 120)
                            .ignoresSafeArea()
                        }
                }
        }
        .preferredColorScheme(colorSchemeOverride)
    }

    func toggleColorScheme() {
        let newScheme: ColorScheme = colorScheme == .dark ? .light : .dark
        colorSchemeOverride = newScheme
#if os(iOS)
        keyWindow?.overrideUserInterfaceStyle = newScheme == .dark ? .dark : .light
#endif
    }

    func showDefinition(for word: String) {
#if os(iOS)
        guard !word.isEmpty else { return }
        let vc = UIReferenceLibraryViewController(term: word)
        keyWindow?.rootViewController?.present(vc, animated: true)
#endif
    }
}
