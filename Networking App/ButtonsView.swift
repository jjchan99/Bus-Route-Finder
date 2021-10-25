//
//  SwiftUIView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 2/7/21.
//

import SwiftUI
import MapKit

struct ButtonsView: View {
    @Binding var showDirections: Bool
    @Binding var searchQuery: Bool
 
    
    var body: some View {
        Button(action: {
            print(API2Manager().fetchBusRoute()?.count)
        }, label: {
        Image(systemName: "target")
        .padding()
        .frame(maxWidth: .infinity)
            .background(Color.black.opacity(1).cornerRadius(10))
        .foregroundColor(.white)
        .font(.headline)
        .clipShape(Circle())
        })
            Button(action: {
              
            }, label: {
            Image(systemName: "pin")
            .padding()
            .frame(maxWidth: .infinity)
                .background(Color.black.opacity(1).cornerRadius(10))
            .foregroundColor(.white)
            .font(.headline)
            .clipShape(Circle())
            })
            
            Button(action: {
                self.searchQuery.toggle()
            }, label: {
            Image(systemName: "info")
            .padding()
            .frame(maxWidth: .infinity)
                .background(Color.black.opacity(1).cornerRadius(10))
            .foregroundColor(.white)
            .font(.headline)
            .clipShape(Circle())
            })
            Spacer()
    }
}




        
        






