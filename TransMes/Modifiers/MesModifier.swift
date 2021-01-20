//
//  MesModifier.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/20.
//

import SwiftUI

struct MesModifierView: View {
    @State var names = ["ZhangSan", "LiSi", "WangWu"]
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    Button("Scroll to bottom") {
                        value.scrollTo(99, anchor: .bottom)
                    }
                    LazyVStack {
                        ForEach(0..<100) { index in
                            Text(String(index)).mesStyle()
                        }
                    }
                }
            }
        }
    }
}

struct MesModifier_Previews: PreviewProvider {
    static var previews: some View {
        MesModifierView()
    }
}

struct MesModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color("BlankDetailColor"))
            .cornerRadius(12)
    }
}

extension View {
    func mesStyle() -> some View {
        self.modifier(MesModifier())
    }
}

struct GlassEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

extension View {
    func glassEffect() -> some View {
        self.background(GlassEffect())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
