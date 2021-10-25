//
//  ButtonsView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 2/7/21.
//

import SwiftUI
import MapKit

struct HeadersView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var start: String
    @Binding var end: [String]
    @Binding var completion: Bool
    
    var body: some View {
        ZStack{
        VStack{
            HStack {
        Image(systemName: "circle")
            .foregroundColor(.red)
                TextField("Start", text: $viewModel.searchTextStart)
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.white)
                    .onChange(of: viewModel.searchTextStart, perform: { value in
                        guard value != viewModel.selectedPlaceStart else { return }
                        
                        viewModel.placeSelectedStart = false
                        
                             let delay = 0.3
                             print("new value changed to \(value)!")
                             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                 
                                if value == viewModel.searchTextStart {
                                    viewModel.searchQuery(type: 0)
                                 }
                             }
                    })
            
               
            
            SearchButtonView(end: $end, completion: $completion)
            
            if !viewModel.placesStart.isEmpty && viewModel.searchTextStart != "" && !viewModel.placeSelectedStart {
                ScrollView {
                     VStack(spacing: 15) {
                        ForEach(viewModel.placesStart) { place in
                            HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                                    //.padding(.vertical,10)
                            .padding(.horizontal)
                            Text(place.place.name ?? "")
                                 .foregroundColor(.white)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                                 .font(.headline)
                                .padding(.leading)
                                .onTapGesture {
                                    viewModel.selectPlace(place: place, type: 0)
                                    self.start = viewModel.nearestBusStopsStart()[0]
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
           
        Spacer()
        }
          
        }
}
}




