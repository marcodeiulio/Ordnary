//
//  ContentView.swift
//  Ordnary
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var word = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter a word", text: $word)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Define") {
                showDefinition(for: word)
            }
        }
    }

    func showDefinition(for word: String) {
        guard UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) else {
            print("No definition found")
            return
        }

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let vc = UIReferenceLibraryViewController(term: word)
            window.rootViewController?.present(vc, animated: true)
        }
    }
}
