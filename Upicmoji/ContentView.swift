//
//  ContentView.swift
//  Upicmoji
//
//  Created by Dmitrii Vlasov on 20/08/2024.
//

import SwiftUI

class MemojiTextView: UITextView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            self.becomeFirstResponder()
        }
    }
}

struct MemojiTextViewRepresentable: UIViewRepresentable {
    @Binding var image: UIImage?

    func makeUIView(context: Context) -> MemojiTextView {
        let textView = MemojiTextView()
        textView.allowsEditingTextAttributes = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: MemojiTextView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MemojiTextViewRepresentable

        init(_ parent: MemojiTextViewRepresentable) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            if let attributedText = textView.attributedText {
                attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributedText.length), options: []) { value, range, _ in
                    if let attachment = value as? NSTextAttachment {
                        if let image = attachment.image {
                            parent.image = image
                            textView.resignFirstResponder()
                        }
                    }
                }
            }
            textView.text = ""
        }
    }
}

struct MemojiView: View {
    var uiImage: UIImage?
    var bgColor: Color

    var body: some View {
            ZStack {
                Color(bgColor)

                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 350, height: 350)
            .clipShape(.rect(cornerRadius: 10))
    }
}

struct ContentView: View {
    @State private var selectedColor = Color.blue
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack {
                MemojiView(uiImage: selectedImage, bgColor: selectedColor)
                ColorPicker("Select background color", selection: $selectedColor)
                    .padding(.horizontal)
                Spacer()
                MemojiTextViewRepresentable(image: $selectedImage)
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
        let renderer = ImageRenderer(content: MemojiView(uiImage: selectedImage, bgColor: selectedColor))
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
