//
//  ContentView.swift
//  API Calling Project
//
//  Created by Student on 3/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var elements =  [Element]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
           List(elements) { element in
                NavigationLink(
                    destination: VStack {
                        Text(element.name)
                           .padding()
                        Text(element.symbol)
                            .padding()
                        Text(element.facts)
                            .padding()
                        Text(element.history)
                            .padding()
                    },
                    label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)

                        }
                    })
            }
            .navigationTitle("Periodic Elements")
       }
       .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),  dismissButton: .default(Text("Ok"))) //pop up message if there is an issue with the API Key or data
        })
    }
    //queryAPI function, gathers JSON data
    func queryAPI() {
        let apiKey = "?rapidapi-key=0ff18549camsh01a37f90950c439p183210jsnf23412a0511c"
        let query = "https://periodictable.p.rapidapi.com/\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url){
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let sybmol = item["symbol"].stringValue
                    let facts = item["facts"].stringValue
                    let history = item["history"].stringValue
                    let element = Element(symbol: sybmol, name: name, facts: facts, history: history)
                    elements.append(element)
                }
                return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Element: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let facts: String
    let history: String
}


