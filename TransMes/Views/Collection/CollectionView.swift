//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dataModel.collections, id: \.id) { result in
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
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationBarTitle("收藏", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.dataModel.collections.remove(atOffsets: indexSet)
    }
}
