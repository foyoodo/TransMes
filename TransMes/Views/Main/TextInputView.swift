//
//  TextInputView.swift
//  TransMes
//
//  Created by foyoodo on 2021/2/23.
//

import SwiftUI

struct TextInputView: View {
    @AppStorage("transService") private var transService = 0
    @AppStorage("sourceLanguageCode") private var sourceLanguageCode = "auto"
    @AppStorage("targetLanguageCode") private var targetLanguageCode = "zh"

    @EnvironmentObject var dataModel: DataModel
    @Binding var input: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule().fill(Color("BlankDetailColor"))
                .overlay(
                    Capsule()
                        .stroke(lineWidth: 1.5)
                        .foregroundColor(Color("AccentColor"))
                )
                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)

            HStack {
                TextField("在这里输入文本", text: $input)
                    .autocapitalization(.sentences)
                    .background(Color("BlankDetailColor"))

                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("AccentColor"))
                        .shadow(radius: 2)

                    Button(action: {
                        transAction()
                    }, label: {
                        Image(systemName: "arrow.up")
                    })
                    .foregroundColor(Color.white)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 5))
        }
        .padding(10)
        .frame(height: 60)
    }

    func transAction() {
        if input != "" {
            dataModel.messages.append(Message(id: Date.timeIntervalSinceReferenceDate, myMessage: true, time: currentTime(), text: input))

            if transService == 0 {
                dataModel.caiyunTrans(text: input, from: sourceLanguageCode, to: targetLanguageCode)
            } else if transService == 1 {
                dataModel.sogouTrans(text: input, from: sourceLanguageCode, to: targetLanguageCode)
            }

            input = ""

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(input: .constant(""))
            .environmentObject(DataModel())
            .environmentObject(KeyboardFollower())
    }
}
