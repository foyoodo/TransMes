//
//  ConfigView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ConfigView: View {
    @AppStorage("systemAppearance") private var systemAppearance = false
    @AppStorage("isDarkMode") private var isDarkMode = true
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    Group {
                        Spacer().frame(height: 12)
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
                                .toggleStyle(CheckmarkToggleStyle())
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
                            NavigationLink(destination: EmptyView()) {
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
                                ListCell(image: Image("bug"), title: "反馈问题") {
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

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .frame(width: 52, height: 32, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? .blue : .gray)
                        )
                        .frame(width: 28, height: 28)
                        .padding(.horizontal, 2)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(Animation.linear(duration: 0.1))
                )
                .cornerRadius(20)
                .onTapGesture {
                    configuration.isOn.toggle()
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
