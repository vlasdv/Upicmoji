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

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var selectedColor = Color.blue

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color(selectedColor)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 350, height: 350)
                .clipShape(.rect(cornerRadius: 10))


                ColorPicker("Select background color", selection: $selectedColor)
                    .padding(.horizontal)

                Spacer()

                MemojiTextViewRepresentable(image: $selectedImage)

            }
            .navigationTitle("Upicmoji")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
