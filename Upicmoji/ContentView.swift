//
//  ContentView.swift
//  Upicmoji
//
//  Created by Dmitrii Vlasov on 20/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedColor = Color.blue
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack {
//                Spacer()
                ZStack(alignment: .bottomTrailing, content: {
                    UserpicView(uiImage: selectedImage, bgColor: selectedColor)
                        .clipShape(.rect(cornerRadius: 10))

                    CustomImagePasteButton(image: $selectedImage)
                        .frame(alignment: .bottomTrailing)
                        .padding()
                })

                ColorPicker("Select background color", selection: $selectedColor)
                    .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Upicmoji")
            .padding()
            .toolbar {
                if let imageToShare = imageToShare() {
                    let _ = print("here")
                    ShareLink(item: imageToShare, preview: SharePreview("Userpic", image: imageToShare))
                }
            }
        }
    }

    @MainActor private func imageToShare() -> Image? {
        let renderer = ImageRenderer(content: UserpicView(uiImage: selectedImage, bgColor: selectedColor))
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
}

#Preview {
    ContentView()
}
