//
//  TransView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct TransView: View {
    @State var input = ""
    @State var removeAll = false
    @State var showSheet = false
    @AppStorage("transMode") private var transMode = 0
    @State var messages: Array<Message> = [
        Message(id: Date().timeIntervalSince1970, time: "2021-01-19 21:01:19", message: "NavigationLink should be inside NavigationView hierarchy. The Menu is outside navigation view, so put buttons inside menu which activate navigation link placed inside navigation view, eg. hidden in background.", result: "NavigationLink 应该位于 NavigationView 层次结构中。菜单是外部导航视图，所以将按钮放在菜单内，激活导航链接放在导航视图内，比如隐藏在背景中。")
    ]
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("messages.json")
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(messages, id: \.id) { result in
                                BubbleMessage(myMessage: true, text: result.message)
                                BubbleMessage(myMessage: false, text: result.result)
                                    .onTapGesture {
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                        UIPasteboard.general.string = result.result
                                    }
                            }
                            .onChange(of: messages.count) { _ in
                                if messages.count > 0 {
                                    value.scrollTo(messages.last!.id, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear(perform: {
                            readMessages()
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
                                .foregroundColor(.blue)
                                .shadow(radius: 3)
                            Button(action: {
                                if input != "" {
                                    self.messages.append(Message(id: Date().timeIntervalSince1970, time: currentTime(), message: input, result: "这是一条测试使用的翻译结果，会在按下按钮的时候添加进来"))
                                    input = ""
                                    
                                    writeMessages()
                                    
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
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
            .navigationBarTitle(TransMode[transMode], displayMode: .inline)
            .navigationBarItems(
                leading:
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
                                messages.removeAll()
                                clearMessages()
                            })
                        )
                    }
                ,
                trailing:
                    HStack {
                        Button(action: {
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
        }.navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSheet, content: {
            TransPreferenceView(showSheet: $showSheet)
        })
    }
    
    func readMessages() {
        var filePath = ""
        let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0]
            filePath = dir.appendingFormat("/" + "messages.json")
        } else {
            return
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                if try String(contentsOf: fileURL) != "" {
                    let decoder = JSONDecoder()
                    let content = try Data(contentsOf: fileURL)
                    messages = try decoder.decode(Array<Message>.self, from: content)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func writeMessages() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(messages)
            try String(data: data, encoding: .utf8)!.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    func clearMessages() {
        do {
            try "".write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

struct TransView_Previews: PreviewProvider {
    static var previews: some View {
        TransView()
    }
}
