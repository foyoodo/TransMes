//
//  TransView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct TransView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("transMode") private var transMode = 0
    @AppStorage("targetValue") private var targetValue = 0
    @AppStorage("CaiyunToken") private var CaiyunToken = ""
    @State var messages = [Message]()
    @State var collections = [Collection]()
    @State var input = ""
    @State var removeAll = false
    @State var showSheet = false
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
                            addCollection()
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
                .preferredColorScheme(isDarkMode ? .dark : .light)
        })
    }
    
    func readMessages() {
        let path = messagesFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = JSONDecoder()
            do {
                messages = try decoder.decode([Message].self, from: data)
            } catch {
                print("Error decoding messages array: \(error.localizedDescription)")
            }
        }
    }
    
    func writeMessages() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(messages)
            try String(data: data, encoding: .utf8)!.write(
                to: messagesFilePath(),
                atomically: true,
                encoding: .utf8)
        } catch {
            print("Error encoding messages array: \(error.localizedDescription)")
        }
    }
    
    func clearMessages() {
        let path = messagesFilePath()
        do {
            try "".write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing messages file: \(error.localizedDescription)")
        }
    }
    
    func readCollections() {
        let path = collectionsFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = JSONDecoder()
            do {
                collections = try decoder.decode([Collection].self, from: data)
            } catch {
                print("Error decoding collections array: \(error.localizedDescription)")
            }
        }
    }
    
    func writeCollections() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(collections)
            try String(data: data, encoding: .utf8)!.write(
                to: collectionsFilePath(),
                atomically: true,
                encoding: .utf8)
        } catch {
            print("Error encoding collections array: \(error.localizedDescription)")
        }
    }
    
    func addCollection() {
        readCollections()
        let count = messages.count - 2
        if count >= 0 {
            collections.append(Collection(id: Date().timeIntervalSince1970, time: currentTime(), text: messages[count].text, target: messages.last!.text))
            writeCollections()
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func messagesFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Messages.json")
    }
    
    func collectionsFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Collections.json")
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
            let data = try encoder.encode(postData)
            request.httpBody = data
        } catch {
            print(error.localizedDescription)
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
