//
//  ContentView.swift
//  TBIconTransitionKitExample
//
//  Created by Aleksei Belezeko on 18.04.2023.
//

import SwiftUI
import TBIconTransitionKit

extension UIColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        let a = CGFloat(1.0)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("TBIconTransitionKit Version 2.0.0 By Alexey Belezenko and Oleg Turbaba")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    AnimatedButton(state: .menu, configure: { button in
                        button.backgroundColor = UIColor(hex: 0xFC2125)
                        button.lineColor = .white
                    }, action: { button in
                        if button.currentState == .menu {
                            button.animationTransform(to: .arrow)
                        } else {
                            button.animationTransform(to: .menu)
                        }
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    AnimatedButton(state: .cross, configure: { button in
                        button.backgroundColor = UIColor(hex: 0x68C4C9)
                        button.lineColor = .white
                    },  action: { button in
                        if button.currentState == .menu {
                            button.animationTransform(to: .cross)
                        } else {
                            button.animationTransform(to: .menu)
                        }
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                
                HStack {
                    AnimatedButton(state: .plus, configure: { button in
                        button.backgroundColor = UIColor(hex: 0x1E1E22)
                        button.lineColor = .white
                    },  action: { button in
                        if button.currentState == .plus {
                            button.animationTransform(to: .minus)
                        } else {
                            button.animationTransform(to: .plus)
                        }
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    AnimatedButton(state: .plus, configure: { button in
                        button.backgroundColor = UIColor(hex: 0x0F4359)
                        button.lineColor = .white
                    },  action: { button in
                        if button.currentState == .plus {
                            button.animationTransform(to: .cross)
                        } else {
                            button.animationTransform(to: .plus)
                        }
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
