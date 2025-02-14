import SwiftUI

struct FavoritesView<ViewModel>: View where ViewModel: FavoritesViewModelProtocol & CollectionDelegate {
    @StateObject var viewModel: ViewModel
    
    @State private var nothingFoundText: String = "Nothing found :("
    @State private var isNotingFoundTextVisible: Bool = true
    
    // MARK: - View
    var body: some View {
        ZStack {
            // Background
            Color.tBlack.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Collection
                CollectionView(items: viewModel.items, delegate: viewModel)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .frame(maxHeight: .infinity)
                    .onChange(of: viewModel.items) { items in
                        
                        switch items.isEmpty {
                        case true:
                            isNotingFoundTextVisible = true
                        case false:
                            isNotingFoundTextVisible = false
                        }
                    }
            } /// VStack
            
            // NothingFound Text
            if isNotingFoundTextVisible {
                Text(nothingFoundText)
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(2)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
            }
        } /// ZStack
        .onAppear {
            viewModel.getSavedRepos()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(dataManager: RealmManager(), navigation: NavigationManager()))
}
