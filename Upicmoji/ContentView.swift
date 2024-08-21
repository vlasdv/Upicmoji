//
//  ContentView.swift
//  Upicmoji
//
//  Created by Dmitrii Vlasov on 20/08/2024.
//

import SwiftUI

enum BackgroundStyle {
    case plain, gradient
}

struct ContentView: View {
    @State private var selectedImage: UIImage?

    @State private var backgroundStyle = BackgroundStyle.plain
    
    var selectedColor: LinearGradient {
        if backgroundStyle == .plain {
            return LinearGradient(colors: [firstColor, firstColor], startPoint: .bottom, endPoint: .top)
        } else {
            return LinearGradient(colors: [firstColor, secondColor], startPoint: .bottom, endPoint: .top)
        }
    }
    
    @State private var firstColor = Color.blue
    @State private var secondColor = Color.black

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
                Divider()
                    .padding(.vertical)

                Picker("Background Style", selection: $backgroundStyle) {
                    Text("Plain").tag(BackgroundStyle.plain)
                    Text("Gradient").tag(BackgroundStyle.gradient)
                }
                .pickerStyle(.segmented)
                
                if backgroundStyle == .plain {
                    ColorPicker("Select background color", selection: $firstColor)
                        .padding(.horizontal)
                } else {
                    ColorPicker("Select first color", selection: $firstColor)
                        .padding(.horizontal)
                    ColorPicker("Select second color", selection: $secondColor)
                        .padding(.horizontal)
                }
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
