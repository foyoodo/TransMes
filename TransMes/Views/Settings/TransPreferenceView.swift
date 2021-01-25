//
//  TransPreferenceView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/25.
//

import SwiftUI

let TransMode = [
    "自动检测",
    "中 → 英",
    "英 → 中"
]

struct TransPreferenceView: View {
    @Binding var showSheet: Bool
    @AppStorage("transMode") private var transMode = 0
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    Group {
                        Text("语言")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack(spacing: 0) {
                            ForEach(0..<TransMode.count) { index in
                                Button {
                                    transMode = index
                                    showSheet.toggle()
                                    let generator = UIImpactFeedbackGenerator(style: .soft)
                                    generator.impactOccurred()
                                } label: {
                                    ListCell(title: TransMode[index]) {}
                                }
                                if (index < TransMode.count - 1) {
                                    Divider().padding(.leading, 12)
                                }
                            }
                        }.background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle(Text("翻译偏好"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("完成")
                    })
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TransPreferenceView_Previews: PreviewProvider {
    @State var showSheet = true
    static var previews: some View {
        TransPreferenceView(showSheet: .constant(true))
    }
}
