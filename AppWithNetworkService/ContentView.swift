import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("App with")
            
            Image(systemName: "network")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("service")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
