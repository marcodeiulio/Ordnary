//
//  ContentView.swift
//  Ordnary
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ContentView: View {
    @State private var word = ""
    @State private var isDarkMode = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter a word", text: $word)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .focused($isInputFocused)
                    .onSubmit { showDefinition(for: word) }

                Button(action: {
                    showDefinition(for: word)
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
            .onAppear { isInputFocused = true }
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
        let vc = UIReferenceLibraryViewController(term: word)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.keyWindow {
            window.rootViewController?.present(vc, animated: true)
        }
#endif
    }
}
