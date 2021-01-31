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
    @AppStorage("targetValue") private var targetValue = 0
    @AppStorage("CaiyunToken") private var CaiyunToken = ""
    @State var messages: Array<Message> = []
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("messages.json")
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(messages, id: \.id) { result in
                                BubbleMessage(myMessage: result.myMessage ? true : false, text: result.text)
                                    .onTapGesture {
                                        if !result.myMessage {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            UIPasteboard.general.string = result.text
                                        }
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
                            if messages.count > 0 {
                                value.scrollTo(messages.last!.id, anchor: .bottom)
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
                                    messages.append(Message(id: Date().timeIntervalSince1970, myMessage: true, time: currentTime(), text: input))
                                    if transMode == 0 {
                                        caiyunTrans(text: input, from: LanguageCode[targetValue], to: "zh")
                                    } else {
                                        caiyunTrans(text: input, from: "zh", to: LanguageCode[targetValue])
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
            .navigationBarTitle((transMode == 0 ? Language[targetValue] + " → 中文" : "中文 → " + Language[targetValue]), displayMode: .inline)
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
                                    messages.removeAll()
                                    clearMessages()
                                })
                            )
                        }
                        
                        Spacer().frame(width: 32)
                        
                        Button(action: {
                            if targetValue != 0 {
                                transMode = transMode == 0 ? 1 : 0
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
    
    func caiyunTrans(text: String, from: String, to: String) -> Void {
        let caiyunURL = URL(string: "https://api.interpreter.caiyunai.com/v1/translator")
        let session = URLSession(configuration: .default)
        let trans_type = from + "2" + to
        var request = URLRequest(url: caiyunURL!)
        
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("token " + CaiyunToken, forHTTPHeaderField: "X-Authorization")
        request.httpMethod = "POST"
        let postData = ["source": text, "detect": "true", "trans_type": trans_type]
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(postData)
            request.httpBody = data
        } catch {
            print(error)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    self.messages.append(Message(id: Date().timeIntervalSince1970, myMessage: false, time: currentTime(), text: json["target"] as! String))
                    writeMessages()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

struct TransView_Previews: PreviewProvider {
    static var previews: some View {
        TransView()
    }
}
