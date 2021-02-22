//
//  KeyboardFollower.swift
//  TransMes
//
//  Created by foyoodo on 2021/2/22.
//

import SwiftUI

final class KeyboardFollower: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible: Bool = false

    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardVisibilityChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardBeginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        isVisible = keyboardBeginFrame.minY > keyboardEndFrame.minY
        keyboardHeight = isVisible ? keyboardEndFrame.height : 0
    }
}
