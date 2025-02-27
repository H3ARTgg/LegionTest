import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {
    @Perception.Bindable var store: StoreOf<FavoritesReducer>
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background
                Color.tBlack.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Collection
                    CollectionView(
                        items: store.items,
                        presentDetails: { model in
                            store.send(.ui(.onCellTapped(model)))
                        }
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .frame(maxHeight: .infinity)
                } /// VStack
                
                Group {
                    switch store.screenState {
                    case .empty:
                        Text(store.notificationText)
                            .font(.system(size: 30, weight: .bold))
                            .lineLimit(2)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                    case .favorites:
                        EmptyView()
                    }
                }
            } /// ZStack
            .onAppear {
                store.send(.ui(.onAppear))
            }
        } /// WithPerceptionTracking
    }
}

#Preview {
    FavoritesView(store: Store(initialState: FavoritesReducer.State(), reducer: {
        FavoritesReducer()
    }))
}
