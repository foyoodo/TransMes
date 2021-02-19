//
//  AppIconView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/30.
//

import SwiftUI

struct AppIconPreferenceView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    Button {
                        if UIApplication.shared.supportsAlternateIcons {
                            UIApplication.shared.setAlternateIconName("AppIcon-Light") { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image("AppIcon-Light")
                                .resizable()
                                .frame(width: 72, height: 72)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.placeholderText), lineWidth: 0.5)
                                )
                            Spacer().frame(width: 24)
                            Text("浅色图标")
                                .foregroundColor(.primary)
                                .font(.body)
                            Spacer().frame(height: 48)
                            Image(systemName: "chevron.forward")
                                .font(.title3)
                                .foregroundColor(Color(.placeholderText))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider().padding(.leading, 120)
                    
                    Button {
                        UIApplication.shared.setAlternateIconName(nil)
                    } label: {
                        HStack {
                            Image("AppIcon-Dark")
                                .resizable()
                                .frame(width: 72, height: 72)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.placeholderText), lineWidth: 0.5)
                                )
                            Spacer().frame(width: 24)
                            Text("深色图标")
                                .foregroundColor(.primary)
                                .font(.body)
                            Spacer().frame(height: 48)
                            Image(systemName: "chevron.forward")
                                .font(.title3)
                                .foregroundColor(Color(.placeholderText))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                    }
                }
                .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPreferenceView()
    }
}
