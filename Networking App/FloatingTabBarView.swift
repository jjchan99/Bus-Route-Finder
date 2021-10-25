//
//  FloatingTabBarView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 3/7/21.
//

import SwiftUI

struct FloatingTabBarView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        HStack {
            
            Button(action: {
                self.selected = 0
                
            }) {
                Image(systemName: "house").foregroundColor(self.selected == 0 ? .black : .gray).padding(.horizontal)
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                self.selected = 1
                
            }) {
                Image(systemName: "magnifyingglass").foregroundColor(self.selected == 1 ? .black : .gray).padding(.horizontal)
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                self.selected = 2
            }) {
                Image(systemName: "arrowtriangle.up").foregroundColor(self.selected == 2 ? .black : .gray).padding(.horizontal)
            }
            
        
        }.padding(.vertical,20)
        .padding(.horizontal,45)
        .background(Color.white)
        .clipShape(Capsule())
        .padding()
    }
}


