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
                        } else if let data = attachment.fileWrapper?.regularFileContents, let image = UIImage(data: data) {
                            parent.image = image
                        }
                    }
                }
            }
            textView.text = "" // Reset the text view after processing
        }
    }
}

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var text: String = ""

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFill()
                    .background(.red)
            }
            Spacer()
            MemojiTextViewRepresentable(image: $selectedImage)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
