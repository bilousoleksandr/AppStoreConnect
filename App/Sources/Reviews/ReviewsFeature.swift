import ComposableArchitecture

@Reducer
struct ReviewsFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable {
        var reviews: [Review] = []
        var isLoading: Bool = false
        var respondingToReviewId: String? = nil
        var responseText: String = ""
        var isSubmittingResponse: Bool = false
        var responseError: String? = nil
    }
    
    enum Action {
        case refreshReviews(String) // appId parameter
        case saveReviews([Review])
        case setLoading(Bool)
        case startRespondingToReview(String)
        case cancelResponse
        case updateResponseText(String)
        case submitResponse(String) // appId parameter
        case setSubmittingResponse(Bool)
        case reviewResponseSubmitted(String, ReviewResponse)
        case setResponseError(String?)
        case clearResponseError
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .refreshReviews(let appId):
                return .run { send in
                    await send(.setLoading(true))
                    do {
                        let reviews = try await appStoreManager.reviews(for: appId)
                        await send(.saveReviews(reviews))
                    } catch {
                        // Handle error - could add error state if needed
                        print("Failed to refresh reviews: \(error)")
                    }
                    await send(.setLoading(false))
                }
            case .saveReviews(let reviews):
                state.reviews = reviews
                return .none
            case .setLoading(let isLoading):
                state.isLoading = isLoading
                return .none
            case .startRespondingToReview(let reviewId):
                state.respondingToReviewId = reviewId
                state.responseText = ""
                state.responseError = nil
                return .none
            case .cancelResponse:
                state.respondingToReviewId = nil
                state.responseText = ""
                state.responseError = nil
                return .none
            case .updateResponseText(let text):
                state.responseText = text
                return .none
            case .submitResponse(let appId):
                guard let reviewId = state.respondingToReviewId,
                      !state.responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return .none
                }
                return .run { [responseText = state.responseText] send in
                    await send(.setSubmittingResponse(true))
                    await send(.clearResponseError)
                    do {
                        let response = try await appStoreManager.createReviewResponse(for: reviewId, responseBody: responseText)
                        await send(.reviewResponseSubmitted(reviewId, response))
                        await send(.setSubmittingResponse(false))
                    } catch {
                        await send(.setSubmittingResponse(false))
                        await send(.setResponseError("Failed to submit response: \(error.localizedDescription)"))
                    }
                }
            case .setSubmittingResponse(let isSubmitting):
                state.isSubmittingResponse = isSubmitting
                return .none
            case .reviewResponseSubmitted(let reviewId, let response):
                // Update the review with the new response
                if let reviewIndex = state.reviews.firstIndex(where: { $0.id == reviewId }) {
                    state.reviews[reviewIndex].response = response
                }
                state.respondingToReviewId = nil
                state.responseText = ""
                state.responseError = nil
                return .none
            case .setResponseError(let error):
                state.responseError = error
                return .none
            case .clearResponseError:
                state.responseError = nil
                return .none
            }
        }
    }
}
