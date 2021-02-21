//
//  SettingsView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("systemAppearance") private var systemAppearance = true
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    Group {
                        Text("基础设置")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            NavigationLink(destination: APIConfigView()) {
                                ListCell(image: Image("api"), title: "API Key") {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }.background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }

                    Group {
                        Spacer().frame(height: 12)

                        Text("主题")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            Toggle("跟随系统", isOn: $systemAppearance)
                                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                .frame(height: 32)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)

                            Divider().padding(.leading, 12)

                            Button {
                                systemAppearance = false
                                isDarkMode = false
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            } label: {
                                ListCell(title: "浅色模式") {
                                    if !isDarkMode {
                                        Image(systemName: "checkmark")
                                    } else {
                                        Image(systemName: "xmark")
                                    }
                                }
                            }

                            Divider().padding(.leading, 12)

                            Button {
                                systemAppearance = false
                                isDarkMode = true
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            } label: {
                                ListCell(title: "深色模式") {
                                    if isDarkMode {
                                        Image(systemName: "checkmark")
                                    } else {
                                        Image(systemName: "xmark")
                                    }
                                }
                            }

                            Divider().padding(.leading, 12)

                            NavigationLink(destination: AppIconPreferenceView()) {
                                ListCell(title: "更换应用图标") {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }.background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }

                    Group {
                        Spacer().frame(height: 12)

                        Text("帮助与反馈")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            NavigationLink(destination: EmptyView()) {
                                ListCell(image: Image("help"), title: "如何使用") {
                                    Image(systemName: "chevron.forward")
                                }
                            }

                            Divider().padding(.leading, 12)

                            Button {
                                
                            } label: {
                                ListCell(image: Image("mail"), title: "反馈问题") {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }

                    Group {
                        Spacer().frame(height: 12)

                        Text("支持我们")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            Button {

                            } label: {
                                ListCell(image: Image("star"), title: "评价应用") {
                                    Image(systemName: "chevron.forward")
                                }
                            }

                            Divider().padding(.leading, 12)

                            Button {

                            } label: {
                                ListCell(image: Image("share-one"), title: "分享给朋友") {
                                    Image(systemName: "chevron.forward")
                                }
                            }

                            Divider().padding(.leading, 12)

                            NavigationLink(destination: EmptyView()) {
                                ListCell(image: Image("info"), title: "关于小译") {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }

                    Group {
                        Spacer().frame(height: 12)

                        Text("其他")
                            .font(.footnote)
                            .offset(x: 12)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            Button {

                            } label: {
                                ListCell(title: "隐私条款") {
                                    Image(systemName: "chevron.forward")
                                }
                            }

                            Divider().padding(.leading, 12)

                            Button {

                            } label: {
                                ListCell(title: "常见问题") {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    }

                    Group {
                        Spacer().frame(height: 12)

                        Text("TransMes")
                            .font(.callout)
                            .foregroundColor(.secondary)

                        Spacer().frame(height: 12)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("设置", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
