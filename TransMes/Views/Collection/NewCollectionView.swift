//
//  NewCollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/26.
//

import SwiftUI

struct NewCollectionView: View {
    @Binding var showSheet: Bool
    @State var text = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    TextEditor(text: $text)
                        .frame(height: 300)
                        .border(Color.blue)
                        .cornerRadius(8)
                }
                .padding(2)
                .background(Color.blue)
                .cornerRadius(8)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("取消")
                    })
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    
                    Spacer().frame(width: 16)
                    
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("保存")
                    })
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                Spacer()
            }
        }.padding()
    }
}

struct NewCollectionView_Previews: PreviewProvider {
    @State var showSheet = true
    static var previews: some View {
        NewCollectionView(showSheet: .constant(true))
    }
}
