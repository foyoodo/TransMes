//
//  MesModifier.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/20.
//

import SwiftUI

struct MesModifierView: View {
    @State var names = ["ZhangSan", "LiSi", "WangWu"]
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    Button("Scroll to bottom") {
                        value.scrollTo(99, anchor: .bottom)
                    }
                    LazyVStack {
                        ForEach(0..<100) { index in
                            Text(String(index))
                                .mesStyle()
                                .id(index)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct MesModifier_Previews: PreviewProvider {
    static var previews: some View {
        MesModifierView()
    }
}

struct MesModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("BlankDetailColor"))
            .cornerRadius(12)
    }
}

extension View {
    func mesStyle() -> some View {
        self.modifier(MesModifier())
    }
}
