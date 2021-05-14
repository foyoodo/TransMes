//
//  CircleImage.swift
//  TransMes
//
//  Created by foyoodo on 2021/5/13.
//

import SwiftUI

struct CircleImage: View {
    let diameter: CGFloat
    let systemName: String

    init(diameter: CGFloat, systemName: String) {
        self.diameter = diameter
        self.systemName = systemName
    }

    init(_ systemName: String) {
        self.diameter = 30
        self.systemName = systemName
    }

    var body: some View {
        ZStack {
            Circle()
                .frame(width: diameter, height: diameter)
                .foregroundColor(Color("AccentColor"))
                .shadow(radius: 2)

            Image(systemName: systemName)
                .foregroundColor(Color.white)
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage("arrow.up")
    }
}
