//
//  TransPreferenceView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/25.
//

import SwiftUI

let Language = [
    "自动检测",
    "英语",
    "日语",
]

let LanguageCode = [
    "auto",
    "en",
    "ja"
]

struct TransPreferenceView: View {
    @AppStorage("transMode") private var transMode = 0
    @AppStorage("targetValue") private var targetValue = 0
    
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    Group {
                        Picker(selection: $transMode, label: Text("Language Picker"), content: {
                            Text("翻译为中文").tag(0)
                            Text("由中文翻译").tag(1)
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: transMode, perform: { value in
                            if value == 1 && targetValue == 0 {
                                targetValue = 1
                            }
                        })
                    }
                    
                    Group {
                        Spacer().frame(height: 12)
                        Text((transMode == 0 ? "源语言：" : "目标语言：") + Language[targetValue])
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        let rule = [
                            GridItem(.adaptive(minimum: 120))
                        ]
                        LazyVGrid(columns: rule, spacing: 10) {
                            if transMode == 1 {
                                ForEach(1..<Language.count) { index in
                                    Button {
                                        targetValue = index
                                        let generator = UIImpactFeedbackGenerator(style: .soft)
                                        generator.impactOccurred()
                                    } label: {
                                        Text(Language[index])
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: targetValue == index ? "checkmark" : "xmark")
                                            .font(.callout)
                                            .foregroundColor(Color(.placeholderText))
                                    }
                                    .frame(width: 100)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                                }
                            } else {
                                ForEach(0..<Language.count) { index in
                                    Button {
                                        targetValue = index
                                        let generator = UIImpactFeedbackGenerator(style: .soft)
                                        generator.impactOccurred()
                                    } label: {
                                        Text(Language[index])
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: targetValue == index ? "checkmark" : "xmark")
                                            .font(.callout)
                                            .foregroundColor(Color(.placeholderText))
                                    }
                                    .frame(width: 100)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                                }
                            }
                        }
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
