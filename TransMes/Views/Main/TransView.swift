//
//  TransView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct TransView: View {
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var keyboardHandler : KeyboardFollower

    @AppStorage("systemAppearance") private var systemAppearance = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("sourceLanguageCode") private var sourceLanguageCode = "auto"
    @AppStorage("targetLanguageCode") private var targetLanguageCode = "zh"

    @State var input = ""
    @State var removeAll = false
    @State var showSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
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
                                value.scrollTo("Scroll-Bottom-Spacer", anchor: .bottom)
                            }
                        }
                        .onAppear {
                            self.keyboardHandler.subscribe()
                            value.scrollTo("Scroll-Bottom-Spacer", anchor: .bottom)
                        }
                        .onDisappear {
                            self.keyboardHandler.unsubscribe()
                        }
                        .onChange(of: keyboardHandler.isVisible) { isVisible in
                            if isVisible {
                                withAnimation(.easeInOut(duration: 1)) {
                                    value.scrollTo("Scroll-Bottom-Spacer", anchor: .bottom)
                                }
                            }
                        }

                        Spacer().frame(height: 67).id("Scroll-Bottom-Spacer")
                    }
                }
                .padding(.horizontal, 10)

                VStack {
                    Spacer()
                    TextInputView(input: $input)
                }
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
                .preferredColorScheme(systemAppearance ? nil : (isDarkMode ? .dark : .light))
        })
    }
}

struct TransView_Preview: PreviewProvider {
    static var previews: some View {
        TransView()
            .environmentObject(DataModel())
            .environmentObject(KeyboardFollower())
    }
}
