//
//  ContentView.swift
//  SwiftUIMarathonTask9
//
//  Created by Sergei Semko on 3/23/24.
//

import SwiftUI

struct ContentView: View {
    
    private let diameter: CGFloat = 150
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: .init(colors: [Color.yellow, Color.red]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    ))
                .mask {
                    Canvas { context, size in
                        guard let circle1 = context.resolveSymbol(id: "first"),
                              let circle2 = context.resolveSymbol(id: "second") else {
                            return
                        }
                        
                        context.addFilter (.alphaThreshold (min: 0.7, color: .yellow))
                        context.addFilter (.blur (radius: 25))
                        
                        context.drawLayer { ctx in
                            ctx.draw(circle1, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            ctx.draw(circle2, at: CGPoint(x: size.width / 2, y: size.height / 2))
                        }
                    } symbols: {
                        Circle()
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .tag("first")
                        Circle()
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .tag("second")
                            .offset(offset)
                    }
                }
                .overlay {
                    Image(systemName: "cloud.sun.rain.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(maxWidth: 75, maxHeight: 75)
                        .offset(offset)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }.onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 180, damping: 15)) {
                                offset = .zero
                            }
                        }
                )
        }
        .ignoresSafeArea()
        .background(.black)
    }
}

#Preview {
    ContentView()
}
