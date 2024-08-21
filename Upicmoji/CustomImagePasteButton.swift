//
//  CustomImagePasteButton.swift
//  Upicmoji
//
//  Created by Dmitrii Vlasov on 21/08/2024.
//

import SwiftUI

struct CustomImagePasteButton: View {
    @State private var isPasteAvailable = false
    @Binding var image: UIImage?
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Button(action: handlePaste) {
            Text("Paste")
                .padding()
                .background(isPasteAvailable ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .onAppear(perform: checkPasteboard)
        .onChange(of: UIPasteboard.general.string, checkPasteboard)
        .onChange(of: scenePhase, checkPasteboard)
    }

    private func checkPasteboard() {
        if let _ = UIPasteboard.general.image {
            isPasteAvailable = true
            print("paste available")
        } else {
            isPasteAvailable = false
        }
    }

    private func handlePaste() {
        if let pastedImage = UIPasteboard.general.image {
//            print("Pasted Image: \(image)")
            // Handle pasted image
            image = pastedImage
        }
    }
}
#Preview {
    CustomImagePasteButton(image: .constant(UIImage()))
}
