import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<AppRoot>

    var body: some View {
        HStack {
            VStack {
                if store.appFeature.isLoadingApplications {
                    ProgressView("Loading applications...")
                        .padding()
                } else {
                    ForEach(store.appFeature.applicationFeatures) { appFeatureState in
                        Button {
                            store.send(.appFeature(.selectApplication(appFeatureState.application.id)))
                        } label: {
                            VStack {
                                Text(appFeatureState.application.id)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(appFeatureState.application.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(store.appFeature.selectedApplicationId == appFeatureState.application.id ? Color.blue.opacity(0.3) : Color.clear)
                            .animation(.easeInOut, value: store.appFeature.selectedApplicationId)
                            .cornerRadius(8)
                            .border(.blue)
                        }
                    }
                }
            }
            .frame(width: 250)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .border(.red)
            
            VStack {
                if let selectedAppId = store.appFeature.selectedApplicationId,
                   let selectedAppFeature = store.appFeature.applicationFeatures[id: selectedAppId] {
                    // App header
                    HStack {
                        Text(selectedAppFeature.application.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    
                    // Toggle between Reviews and App Info
                    Picker("View Type", selection: Binding(
                        get: { selectedAppFeature.selectedView },
                        set: { store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .selectView($0)))))  }
                    )) {
                        ForEach(ViewType.allCases, id: \.self) { viewType in
                            Text(viewType.rawValue).tag(viewType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Content based on selected view
                    if selectedAppFeature.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if selectedAppFeature.selectedView == .reviews {
                        ReviewView(reviews: selectedAppFeature.reviews)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .border(.green)
                    } else {
                        AppInfoView(appInfos: selectedAppFeature.appInfos)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .border(.orange)
                    }
                } else {
                    // No app selected
                    VStack {
                        Text("Select an app to view details")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .task {
            store.send(.appFeature(.loadApplications))
        }
    }
}


struct ReviewView: View {
    let reviews: [Review]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if reviews.isEmpty {
                    Text("No reviews available for this app.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(reviews) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(review.title)
                                    .font(.headline)
                                Spacer()
                                Text("★ \(review.rating)")
                                    .foregroundColor(.orange)
                            }
                            Text(review.body)
                                .font(.body)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("By: \(review.reviewerNickname)")
                                    .font(.caption)
                                Spacer()
                                Text(review.createdDate, style: .date)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

struct AppInfoView: View {
    let appInfos: [AppInfo]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if appInfos.isEmpty {
                    Text("No app info available for this app.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(appInfos) { appInfo in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("App Store Age Rating: \(appInfo.appStoreAgeRating.rawValue)")
                                .font(.headline)
                            Text("App Store State: \(appInfo.appStoreState.rawValue)")
                            Text("Brazil Age Rating: \(appInfo.brazilAgeRating.rawValue)")
                            Text("Kids Age Band: \(appInfo.kidsAgeBand.rawValue)")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}
