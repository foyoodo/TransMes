//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var collections = [Collection]()
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
//        encoder.outputFormatting = .prettyPrinted
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
