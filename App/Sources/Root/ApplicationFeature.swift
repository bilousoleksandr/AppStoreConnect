import ComposableArchitecture

@Reducer
struct ApplicationFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let application: Application
        var reviews: [Review] = []
        var appInfos: [AppInfo] = []
        var selectedView: ViewType = .reviews
        var isLoading: Bool = false
        var respondingToReviewId: String? = nil
        var responseText: String = ""
        var isSubmittingResponse: Bool = false
        var responseError: String? = nil
        
        var id: String { application.id }
        
        init(application: Application) {
            self.application = application
        }
    }
    
    enum Action {
        case selectView(ViewType)
        case refreshReviews
        case refreshAppInfo
        case saveReviews([Review])
        case saveAppInfo([AppInfo])
        case setLoading(Bool)
        case loadData
        case startRespondingToReview(String)
        case cancelResponse
        case updateResponseText(String)
        case submitResponse
        case setSubmittingResponse(Bool)
        case reviewResponseSubmitted(String, ReviewResponse)
        case setResponseError(String?)
        case clearResponseError
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectView(let viewType):
                state.selectedView = viewType
                return .send(.loadData)
            case .loadData:
                return .run { [state] send in
                    await send(.setLoading(true))
                    if state.selectedView == .reviews {
                        await send(.refreshReviews)
                    } else {
                        await send(.refreshAppInfo)
                    }
                    await send(.setLoading(false))
                }
            case .refreshReviews:
                return .run { [appId = state.application.id] send in
                    let reviews = try await appStoreManager.reviews(for: appId)
                    await send(.saveReviews(reviews))
                }
            case .refreshAppInfo:
                return .run { [appId = state.application.id] send in
                    let appInfos = try await appStoreManager.appInfo(for: appId)
                    await send(.saveAppInfo(appInfos))
                }
            case .saveReviews(let reviews):
                state.reviews = reviews
                return .none
            case .saveAppInfo(let appInfos):
                state.appInfos = appInfos
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
            case .submitResponse:
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
