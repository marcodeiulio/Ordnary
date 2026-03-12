//
//  ContentView.swift
//  Ordnary
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

#if os(iOS)
struct SelectAllTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.delegate = context.coordinator
        tf.returnKeyType = .search
        tf.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        DispatchQueue.main.async { tf.becomeFirstResponder() }
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text { uiView.text = text }
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
    @State private var word = ""
    @State private var isDarkMode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                SelectAllTextField(text: $word, placeholder: "Enter a word", onSubmit: { word = word.trimmingCharacters(in: .whitespaces); showDefinition(for: word) })
                    .padding()
                    .frame(height: 50)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)

                Button(action: {
                    word = word.trimmingCharacters(in: .whitespaces); showDefinition(for: word)
                }) {
                    Text("Define")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding(25)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    func showDefinition(for word: String) {
#if os(iOS)
        guard !word.isEmpty else { return }
        let vc = UIReferenceLibraryViewController(term: word)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.keyWindow {
            window.rootViewController?.present(vc, animated: true)
        }
#endif
    }
}
