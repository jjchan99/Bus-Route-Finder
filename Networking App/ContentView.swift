//
//  ContentView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//
import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    
    @StateObject var viewModel = MapViewModel()
    
    @State var showDirections: Bool = false
    @State var searchQuery: Bool = false
    @State var selected = 0
    
    @State var start: String = ""
    @State var end: [String] = []
    
    @State var completion: Bool = false
    @State var LockAndLoaded: Bool = false
   
    var body: some View {
        if !LockAndLoaded {
            ProgressView()
                .onAppear() {
                    API3.makeRequest { value0, value1, value2 in
                        viewModel.CoordinateDict = value0
                        viewModel.tree = KDTree<Node>(values: value2)
                        viewModel.DescriptionDict = value1
                        
                        
                        viewModel.makeRequest { value0, value1, value2 in
                            viewModel.cachedGraph = value0
                            viewModel.cachedGraph.name = "Initialized"
                            viewModel.BusRoutesCollection = value1
                            viewModel.routeDict = value2
                            //print(value2["70"]!.route1)
                            //print(value2["70"]!.route2)
                            //let x = AlgorithmBook().CheckAdjacencyList(BusStopCode: "66059'", VertexSet: value0.vertexCollection[0])
                            //print(x)
                           
                            LockAndLoaded.toggle()
                        }
                    }
                }
        } else {
        NavigationView {
            ZStack {
                if selected == 0 {
                MapView()
                    .environmentObject(viewModel)
                    .ignoresSafeArea(.all, edges: .all)
                    .colorScheme(.dark)
                } else if selected == 1 {
                    SearchView(start: $start, end: $end, completion: $completion)
                        .environmentObject(viewModel)
                } else {
                    DirectionsView()
                        .environmentObject(viewModel)
                }
                VStack {
                    //HeadersView(start: $start, end: $end)
                    HStack {
                        Spacer(minLength: 350)
                            VStack{
                                Spacer(minLength: 315)
                                if selected == 0 {
                                ButtonsView(showDirections: $showDirections, searchQuery: $searchQuery)
                                }
                            }
                    }
                Spacer()
                    //CalculateButtonView(calculate: $calculate)
                    FloatingTabBarView(selected: $selected)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "bus.fill").foregroundColor(.black)
                    Text("Find a Route")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
        }
        }
        .onChange(of: end) { value in
            //print("new value changed to \(value)!")
            if value.count >= 0 {
                DispatchQueue.global().async {
                    viewModel.addRoute(start: start, end: end) { value in
                        completion = value
                    }
                }
            }
        }
}
}
}
   

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        navigationBar.standardAppearance = appearance
    }
}


/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}*/
