//
//  TransView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct TransView: View {
    @ObservedObject var dataModel: DataModel

    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("transService") private var transService = 0
    @AppStorage("sourceLanguageCode") private var sourceLanguageCode = "auto"
    @AppStorage("targetLanguageCode") private var targetLanguageCode = "zh"

    @State var input = ""
    @State var removeAll = false
    @State var showSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(dataModel.messages, id: \.id) { result in
                                BubbleMessage(myMessage: result.myMessage ? true : false, text: result.text)
                                    .onTapGesture {
                                        if !result.myMessage {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            UIPasteboard.general.string = result.text
                                        }
                                    }
                            }
                            .onChange(of: dataModel.messages.count) { _ in
                                if dataModel.messages.count > 0 {
                                    value.scrollTo(dataModel.messages.last!.id, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear(perform: {
                            if dataModel.messages.count > 0 {
                                value.scrollTo(dataModel.messages.last!.id, anchor: .bottom)
                            }
                        })
                    }
                }
                .padding(.horizontal, 10)

                ZStack(alignment: .bottom) {
                    Capsule().fill(Color("BlankDetailColor"))

                    HStack {
                        TextField("在这里输入文本", text: $input)
                            .autocapitalization(.sentences)
                            .background(Color("BlankDetailColor"))

                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("AccentColor"))
                                .shadow(radius: 3)

                            Button(action: {
                                if input != "" {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    dataModel.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: true, time: currentTime(), text: input))

                                    if transService == 0 {
                                        dataModel.caiyunTrans(text: input, from: sourceLanguageCode, to: targetLanguageCode)
                                    } else if transService == 1 {
                                        dataModel.sogouTrans(text: input, from: sourceLanguageCode, to: targetLanguageCode)
                                    }

                                    input = ""
                                } else {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.warning)
                                }
                            }, label: {
                                Image(systemName: "arrow.up")
                            })
                            .foregroundColor(Color.white)
                        }
                    }
                    .padding(.bottom, 5)
                    .padding(.trailing, 5)
                    .padding(.leading, 20)
                }
                .padding(10)
                .frame(height: 60)
            }
            .navigationBarTitle(Language[sourceLanguageCode]! + " → " + Language[targetLanguageCode]!, displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            removeAll.toggle()
                        }, label: {
                            Image(systemName: "trash")
                        })
                        .alert(isPresented: $removeAll) {
                            Alert(
                                title: Text("确认删除所有记录？"),
                                message: Text("删除数据后无法恢复"),
                                primaryButton: .cancel(),
                                secondaryButton: .destructive(Text("删除"), action: {
                                    dataModel.clearMessages()
                                })
                            )
                        }

                        Spacer().frame(width: 32)

                        Button(action: {
                            if sourceLanguageCode != "auto" {
                                let tmp = sourceLanguageCode
                                sourceLanguageCode = targetLanguageCode
                                targetLanguageCode = tmp
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            }
                        }, label: {
                            Image(systemName: "arrow.left.arrow.right")
                        })
                    }
                ,
                trailing:
                    HStack {
                        Button(action: {
                            dataModel.addCollection()
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }, label: {
                            Image(systemName: "wand.and.stars")
                        })

                        Spacer().frame(width: 32)

                        Button(action: {
                            showSheet.toggle()
                        }, label: {
                            Image(systemName: "arrow.triangle.swap")
                        })
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSheet, content: {
            TransPreferenceView(showSheet: $showSheet)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        })
    }
}
