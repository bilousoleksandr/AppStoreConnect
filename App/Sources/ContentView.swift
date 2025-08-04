import SwiftUI

public struct ContentView: View {
    @State var manager = ReviewsManager()
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
            .frame(minWidth: 400, minHeight: 400)
            .onAppear {
                Task { [manager] in
                    try await manager.reviews()
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
