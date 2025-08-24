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
                        ReviewView(
                            reviews: selectedAppFeature.reviews,
                            respondingToReviewId: selectedAppFeature.respondingToReviewId,
                            responseText: selectedAppFeature.responseText,
                            isSubmittingResponse: selectedAppFeature.isSubmittingResponse,
                            responseError: selectedAppFeature.responseError,
                            onStartResponding: { reviewId in
                                store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .startRespondingToReview(reviewId)))))
                            },
                            onCancelResponse: {
                                store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .cancelResponse))))
                            },
                            onUpdateResponseText: { text in
                                store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .updateResponseText(text)))))
                            },
                            onSubmitResponse: {
                                store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .submitResponse))))
                            },
                            onClearError: {
                                store.send(.appFeature(.applicationFeature(.element(id: selectedAppId, action: .clearResponseError))))
                            }
                        )
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
    let respondingToReviewId: String?
    let responseText: String
    let isSubmittingResponse: Bool
    let responseError: String?
    let onStartResponding: (String) -> Void
    let onCancelResponse: () -> Void
    let onUpdateResponseText: (String) -> Void
    let onSubmitResponse: () -> Void
    let onClearError: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if reviews.isEmpty {
                    Text("No reviews available for this app.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(reviews) { review in
                        ReviewCardView(
                            review: review,
                            isRespondingToThis: respondingToReviewId == review.id,
                            responseText: responseText,
                            isSubmittingResponse: isSubmittingResponse,
                            responseError: responseError,
                            onStartResponding: { onStartResponding(review.id) },
                            onCancelResponse: onCancelResponse,
                            onUpdateResponseText: onUpdateResponseText,
                            onSubmitResponse: onSubmitResponse,
                            onClearError: onClearError
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct ReviewCardView: View {
    let review: Review
    let isRespondingToThis: Bool
    let responseText: String
    let isSubmittingResponse: Bool
    let responseError: String?
    let onStartResponding: () -> Void
    let onCancelResponse: () -> Void
    let onUpdateResponseText: (String) -> Void
    let onSubmitResponse: () -> Void
    let onClearError: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Review content
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
            
            // Existing response or response input
            if let response = review.response {
                // Show existing response
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Your Response")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text(response.state.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(response.state == .published ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                            .cornerRadius(4)
                    }
                    Text(response.responseBody)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text("Last modified: \(response.lastModifiedDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            } else if isRespondingToThis {
                // Response input interface
                VStack(alignment: .leading, spacing: 12) {
                    Text("Respond to this review")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextEditor(text: Binding(
                        get: { responseText },
                        set: onUpdateResponseText
                    ))
                    .frame(minHeight: 80)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Error display
                    if let error = responseError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                            Spacer()
                            Button("Dismiss") {
                                onClearError()
                            }
                            .font(.caption)
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(4)
                    }
                    
                    HStack {
                        Button("Cancel", action: onCancelResponse)
                            .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Submit Response") {
                            onSubmitResponse()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmittingResponse)
                        
                        if isSubmittingResponse {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            } else {
                // Show respond button
                Button("Respond to Review") {
                    onStartResponding()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
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
