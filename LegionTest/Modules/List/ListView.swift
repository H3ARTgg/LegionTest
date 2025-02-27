import SwiftUI
import ComposableArchitecture

struct ListView: View {
    @Perception.Bindable var store: StoreOf<ListReducer>
    @State var isTextFieldFocused: Bool = false
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background
                Color.tBlack.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        // Search
                        SearchView(
                            text: $store.searchedText,
                            textFieldFocusing: {
                                isTextFieldFocused = $0
                            }
                        )
                        .padding(.top, 20)
                        
                        if isTextFieldFocused {
                            Button {
                                store.send(.ui(.onSearchButtonTapped))
                                hideKeyboard()
                            } label: {
                                Text("Search")
                            }
                            .foregroundStyle(.white)
                            .padding([.top, .trailing], 20)
                        }
                    } /// HStack
                    
                    // Collection
                    CollectionView(
                        items: store.items,
                        didDisplayCell: { index in
                            store.send(.ui(.onScrollToBottomSearch(index)))
                        }, presentDetails: { model in
                            store.send(.ui(.onCellTapped(model)))
                        }
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .frame(maxHeight: .infinity)
                } /// VStack
                
                Text(store.notificationText)
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(2)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                
                Group {
                    switch store.screenState {
                    case .loading:
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    case _:
                        EmptyView()
                    }
                }
            } /// ZStack
        } /// WithPerceptionTracking
    }
    
    // MARK: - Methods
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ListView(store: Store(initialState: ListReducer.State(), reducer: {
        ListReducer()
    }))
}
