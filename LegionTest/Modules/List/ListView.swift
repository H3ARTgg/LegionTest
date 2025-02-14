import SwiftUI

struct ListView<ViewModel>: View where ViewModel: ListViewModelProtocol & CollectionDelegate {
    @StateObject var viewModel: ViewModel
    
    @State private var searchText: String = ""
    @State private var nothingFoundText: String = "Type something to search in repositories"
    @State private var isNotingFoundTextVisible: Bool = true
    
    // MARK: - View
    var body: some View {
        ZStack {
            // Background
            Color.tBlack.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Search
                SearchView(text: $searchText)
                    .padding(.top, 20)
                    .onChange(of: searchText) { newSearchText in
                        if newSearchText.isEmpty {
                            nothingFoundText = "Type something to search in repositories"
                        }
                        
                        Task(priority: .userInitiated) {
                            await viewModel.search(with: newSearchText)
                        }
                    }
                
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
                            if searchText.isEmpty {
                                nothingFoundText = "Type something to search in repositories"
                            } else {
                                nothingFoundText = "Nothing found :("
                            }
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
            
            // ProgressView
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        } /// ZStack
    }
    
    // MARK: - Methods
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    let viewModel = ListViewModel(networkManager: NetworkManager(), navigation: NavigationManager())
    ListView(viewModel: viewModel)
}
