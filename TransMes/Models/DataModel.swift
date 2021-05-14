//
//  DataModel.swift
//  TransMes
//
//  Created by foyoodo on 2021/2/18.
//

import SwiftUI

class DataModel: ObservableObject {
    @AppStorage("CaiyunToken") private var CaiyunToken = ""
    @AppStorage("SogouPid") private var SogouPid = ""
    @AppStorage("SogouKey") private var SogouKey = ""
    @AppStorage("YoudaoAppID") private var YoudaoAppID = ""
    @AppStorage("YoudaoAppKey") private var YoudaoAppKey = ""

    @Published var messages = [Message]()
    @Published var collections = [Collection]()

    init() {
        loadMessages()
        loadCollections()
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func messagesFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Messages.json")
    }

    func collectionsFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Collections.json")
    }

    func loadMessages() {
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

    func saveMessages() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(messages)
            try String(data: data, encoding: .utf8)!.write(to: messagesFilePath(), atomically: true, encoding: .utf8)
        } catch {
            print("Error encoding messages array: \(error.localizedDescription)")
        }
    }

    func clearMessages() {
        messages.removeAll()
        let path = messagesFilePath()
        do {
            try "".write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing messages file: \(error.localizedDescription)")
        }
    }

    func loadCollections() {
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

    func saveCollections() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(collections)
            try String(data: data, encoding: .utf8)!.write(to: collectionsFilePath(), atomically: true, encoding: .utf8)
        } catch {
            print("Error encoding collections array: \(error.localizedDescription)")
        }
    }

    func addCollection() {
        let count = messages.count - 2
        if count >= 0 {
            collections.append(Collection(id: Date().timeIntervalSince1970, time: currentTime(), text: messages[count].text, target: messages.last!.text))
        }
    }

    func caiyunTrans(text: String, from: String, to: String) {
        if CaiyunToken == "" {
            messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "未填入 Token"))
            return
        }

        let caiyunURL = URL(string: "https://api.interpreter.caiyunai.com/v1/translator")!
        let trans_type = from + "2" + to
        var request = URLRequest(url: caiyunURL)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("token " + CaiyunToken, forHTTPHeaderField: "X-Authorization")

        let postData = ["source": text, "detect": "true", "trans_type": trans_type]

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(postData)
            request.httpBody = data
        } catch {
            print(error.localizedDescription)
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "网络错误"))
                }
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let target = json["target"] {
                            self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: target as! String))
                        } else {
                            self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "Token 无效"))
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func sogouTrans(text: String, from: String, to: String) {
        if SogouPid == "" || SogouKey == "" {
            messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "未填入 Pid 或 Key"))
            return
        }

        let q = text.trimmingCharacters(in: CharacterSet.whitespaces)
        let from = from + (from == "zh" ? "-CHS" : "")
        let to = to + (to == "zh" ? "-CHS" : "")
        let pid = SogouPid
        let key = SogouKey
        let salt = arc4random()
        let sign = "\(pid)\(q)\(salt)\(key)".MD5

        let url = URL(string: "https://fanyi.sogou.com/reventondc/api/sogouTranslate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let payload = "from=\(from)&to=\(to)&q=\(q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&pid=\(pid)&sign=\(sign)&salt=\(salt)"

        request.httpBody = payload.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "网络错误"))
                }
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let errorCode = json["errorCode"], errorCode as! String == "0" {
                        DispatchQueue.main.async {
                            if let translation = json["translation"] {
                                self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: translation as! String))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "未知错误"))
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func youdaoTrans(text: String, from: String, to: String) {
        if YoudaoAppID == "" || YoudaoAppKey == "" {
            messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "未填入 AppID 或 AppKey"))
            return
        }

        let q = text.trimmingCharacters(in: CharacterSet.whitespaces)
        let from = from + (from == "zh" ? "-CHS" : "")
        let to = to + (to == "zh" ? "-CHS" : "")
        let appID = YoudaoAppID
        let appKey = YoudaoAppKey
        let salt = arc4random()
        let curtime = Int(Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate)
        var input: String {
            q.count <= 20 ? q : "\(q.prefix(10))\(q.count)\(q.suffix(10))"
        }
        let signType = "v3"
        let sign = "\(appID)\(input)\(salt)\(curtime)\(appKey)".sha256
        let payload = "q=\(q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&from=\(from)&to=\(to)&appKey=\(appID)&salt=\(salt)&sign=\(sign)&signType=\(signType)&curtime=\(curtime)"

        let url = URL(string: "https://openapi.youdao.com/api")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = payload.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "网络错误"))
                }
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let errorCode = json["errorCode"], errorCode as! String == "0" {
                        if let translations = json["translation"] as? [String] {
                            let translation = translations[0]
                            DispatchQueue.main.async {
                                self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: translation))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: false, time: currentTime(), text: "未知错误"))
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
}
