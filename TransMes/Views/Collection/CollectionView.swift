//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var collections: Array<Collection> = []
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("collections.json")
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(collections, id: \.id) { result in
                        NavigationLink(
                            destination:
                                ScrollView {
                                    VStack {
                                        Text(result.text)
                                        Spacer().frame(height: 32)
                                        Text(result.target)
                                    }
                                    .padding()
                                }
                        ) {
                            VStack {
                                Spacer().frame(height: 8)
                                
                                Text(result.text)
                                    .lineLimit(4)
                                
                                Spacer().frame(height: 8)
                                
                                Text("\(result.time)")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .foregroundColor(Color("AccentColor"))
                                    .shadow(radius: 3)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    .onDelete(perform: self.deleteItem)
                }
            }
            .navigationBarTitle("收藏", displayMode: .inline)
            .onAppear {
                readCollections()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func readCollections() {
        var filePath = ""
        let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0]
            filePath = dir.appendingFormat("/" + "collections.json")
        } else {
            return
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                if try String(contentsOf: fileURL) != "" {
                    let decoder = JSONDecoder()
                    let content = try Data(contentsOf: fileURL)
                    collections = try decoder.decode(Array<Collection>.self, from: content)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func writeCollections() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(collections)
            try String(data: data, encoding: .utf8)!.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.collections.remove(atOffsets: indexSet)
        writeCollections()
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
