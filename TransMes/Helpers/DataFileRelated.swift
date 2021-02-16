//
//  DataFileRelated.swift
//  TransMes
//
//  Created by foyoodo on 2021/2/16.
//

import Foundation

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

func loadMessages(_ messages: inout [Message]) {
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

func saveMessages(_ messages: [Message]) {
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

func loadCollections(_ collections: inout [Collection]) {
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

func saveCollections(_ collections: [Collection]) {
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

func addCollection(messages: [Message], collections: inout [Collection]) {
    loadCollections(&collections)
    let count = messages.count - 2
    if count >= 0 {
        collections.append(Collection(id: Date().timeIntervalSince1970, time: currentTime(), text: messages[count].text, target: messages.last!.text))
        saveCollections(collections)
    }
}
