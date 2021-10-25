//
//  SearchView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 3/7/21.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var start: String
    @Binding var end: [String]
    @Binding var completion: Bool

    var body: some View {
        ZStack {
            VStack {
                HeadersView(start: $start, end: $end, completion: $completion)
                    .environmentObject(viewModel)
                //SearchButtonView(start: $start, end: $end)
                    .background(
                        Image("shrek")
                            .resizable()
                            .opacity(0.5)
                        //LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .top, endPoint: .bottom)
                    )
            .environmentObject(viewModel)
        Spacer()
        }
    }
    }
}

struct SearchButtonView: View {
    
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var end: [String]
    @Binding var completion: Bool
    
    var body: some View {
        ZStack{
            VStack {
        HStack{
        Image(systemName: "circle")
            .foregroundColor(.blue)
            TextField("Search for destination", text: $viewModel.searchText)
        }
        .padding(.vertical,10)
        .padding(.horizontal)
        .background(Color.white)
        .onChange(of: viewModel.searchText, perform: { value in
            guard value != viewModel.selectedPlace else { return }
            
            viewModel.placeSelected = false
            
                 let delay = 0.3
                 print("new value changed to \(value)!")
                 DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                     
                    if value == viewModel.searchText {
                        viewModel.searchQuery(type: 1)
                     }
                 }
        })
                if !viewModel.places.isEmpty && viewModel.searchText != "" && !viewModel.placeSelected {
                    ScrollView {
                         VStack(spacing: 15) {
                            ForEach(viewModel.places) { place in
                                HStack {
                                if place.place.name!.contains("Station") {
                                Image(systemName: "tram.fill")
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                } else {
                                Image(systemName: "location.fill")
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                }
                                    //.padding(.vertical,10)
                                Text(place.place.name ?? "")
                                     .foregroundColor(.white)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                    .padding(.leading)
                                    .onTapGesture {
                                        viewModel.selectPlace(place: place, type: 1)
                                
                                        if let end = viewModel.nearestBusStops() {
                                            self.end = end
                                    }
                                    }
                                }
                                 Divider()
                             }
                         }
                         .padding(.top)
                     }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .top, endPoint: .bottom)
                            .opacity(0.5)
                    )
                 }
    }
}
}
}

