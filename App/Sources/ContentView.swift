import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<AppRoot>

    var body: some View {
        HStack {
            VStack {
                ForEach(store.appFeature.applications) { app in
                    Button {
                        print(app)
                    } label: {
                        VStack {
                            Text(app.id)
                            Text(app.name)
                        }.border(.blue)
                    }
                }
            }
            .frame(width: 250)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .border(.red)
            ReviewView(store: store.scope(state: \.reviewsFeature, action: \.reviewsFeature))
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .border(.green)
        }
        .task {
            store.send(.appFeature(.loadApplications))
        }
    }
}


struct ReviewView: View {
    let store: StoreOf<ReviewsFeature>
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(store.reviews) { review in
                    Text(review.title)
                }
            }
        }
    }
}
