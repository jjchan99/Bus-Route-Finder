//

//  DirectionsView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 3/7/21.
//

import SwiftUI
import StepperView

struct DirectionsView: View {
    @EnvironmentObject var viewModel: MapViewModel
    let directions = Shared.instance.directions
    
    @State var idxSelected: Int = 0
    @State var collapsed: Bool = true
    
    var body: some View {
        
        if Shared.instance.directions.count != 0 {
            ZStack {
            VStack {
                ForEach(0..<viewModel.text.keys.count, id: \.self) { idx in
                
                Button(
                    action: { collapsed.toggle()
                        idxSelected = idx
                    },
                    label: {
                        DirectionsHeaderButton(collapsed: $collapsed, idxSelected: $idxSelected, childrenIndex: idx)
                    })
                    .environmentObject(viewModel)
                    .buttonStyle(PlainButtonStyle())
                    if idx == viewModel.text.keys.count - 1 {
                        Spacer()
                    }
        if !collapsed && idx == idxSelected {
        ScrollView {
            StepperView()
                .addSteps(viewModel.text[idx]!)
                //.addPitStops(viewModel.pitStops)
                .indicators(viewModel.indicationTypes)
                .stepIndicatorMode(StepperMode.vertical)
                .spacing(30)
                .lineOptions(StepperLineOptions.custom(1, Colors.blue(.teal).rawValue))
        }
        }
        }
        }
        }
        } else {
            Text("Search for a destination and your directions will appear here")
        }
    }
}

struct DirectionsHeaderButton: View {
        
        @Binding var collapsed: Bool
        @EnvironmentObject var viewModel: MapViewModel
        let directions = Shared.instance.directions
        @Binding var idxSelected: Int
        @State var childrenIndex: Int = 0
      
        var body: some View {
            
            
            let textToShow: String = "\(viewModel.titleWave[childrenIndex]?.1 ?? "nil") - \(viewModel.titleWave[childrenIndex]?.0 ?? "nil")"
            
                    HStack {
                        if viewModel.BusOptions[childrenIndex] != [""] {
                            Image(systemName: "bus.fill")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                        } else {
                            Image(systemName: "figure.walk")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                        }
                        Text(textToShow)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.black)
                        Spacer()
                            
                        HStack {
                            ForEach(viewModel.BusOptions[childrenIndex]!, id: \.self) { value in
                            Text("\(value)")
                        }
                        }
                        
                        Image(systemName: collapsed ? "chevron.down" : "chevron.up")
                            .padding()
                    }
                    .padding(.bottom, 1)
                    .background(Color.white)
                }
 
    }





