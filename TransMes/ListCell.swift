//
//  ListCell.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/23.
//

import SwiftUI

struct ListCell<Content : View> : View {
    let image: Image
    let title: String
    let accessory: Content
    
    init(image: Image, title: String, @ViewBuilder accessory: () -> Content) {
        self.image = image
        self.title = title
        self.accessory = accessory()
    }
    
    var body: some View {
        HStack {
            image.frame(width: 28, height: 32)
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
            Spacer()
            accessory
                .font(.callout)
                .foregroundColor(Color(.placeholderText))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
    }
}
