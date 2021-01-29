//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var showSheet = false
    @State var collections: Array<Message> = []
    var body: some View {
        NavigationView {
            List(0..<collections.count) { index in
                NavigationLink(
                    destination:
                        VStack {
                            ScrollView {
                                Text(collections[index].text)
                            }
                        }
                        .padding()
                ) {
                    VStack {
                        Text(collections[index].text)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .lineLimit(4)
                        
                        Text("\(collections[index].time)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(Color.blue)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .navigationBarTitle("收藏", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSheet, content: {
            NewCollectionView(showSheet: $showSheet)
        })
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
