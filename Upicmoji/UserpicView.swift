//
//  UserpicView.swift
//  Upicmoji
//
//  Created by Dmitrii Vlasov on 21/08/2024.
//

import SwiftUI

struct UserpicView: View {
    var uiImage: UIImage?
    var bgColor: LinearGradient

    var body: some View {
            ZStack {
//                Color(bgColor)
                Rectangle()
                    .fill(bgColor)

                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 350, height: 350)
    }
}

#Preview {
    UserpicView(uiImage: UIImage(), bgColor: LinearGradient(colors: [.blue, .green], startPoint: .bottom, endPoint: .top))
}
