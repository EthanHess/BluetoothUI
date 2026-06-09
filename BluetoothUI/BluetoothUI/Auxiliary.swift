//
//  Auxiliary.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 4/7/26.
//


import SwiftUI

//MARK: Extensions + modifiers

//MARK: Clean codebase = happy codebase

extension View {
    func customStyleShadow() -> some View {
        modifier(MainShadow())
    }
    
    func customBackground() -> some View {
        modifier(GreenBackground())
    }
}

struct MainShadow: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: .white, radius: 1, y: 0)
    }
}

//Can also pass properties to ViewModifiers
struct GreenBackground : ViewModifier {
    func body(content: Content) -> some View {
        content.padding().customStyleShadow().background(
            LinearGradient(colors: [.green.opacity(0.2), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        ).overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        ).cornerRadius(5)
    }
}
