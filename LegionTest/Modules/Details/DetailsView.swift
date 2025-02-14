import SwiftUI

struct DetailsView<ViewModel>: View where ViewModel: DetailsViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    @State private var isButtonAnimating = false
    @State private var buttonColor: Color = .tWhite
    @State var animationTimer: Timer?
    
    // MARK: - View
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.tBlack.edgesIgnoringSafeArea(.all)
                
                // ScrollView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack {
                            // User Name
                            Text(viewModel.userData?.name ?? "...")
                                .font(.system(size: 13, weight: .bold))
                                .lineLimit(2)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.leading)
                                .padding([.top, .bottom], 10)
                            
                            // User Email
                            if let email = viewModel.userData?.email, !email.isEmpty {
                                Text(viewModel.userData?.email ?? "...")
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                            }
                        } /// VStack
                        .background(Color.tBlackLight)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                        
                        VStack {
                            HStack {
                                // Repo Name
                                Text(viewModel.userData?.repoName ?? "...")
                                    .font(.system(size: 13, weight: .bold))
                                    .lineLimit(2)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 18)
                                
                                Spacer()
                                
                                // Favorite Button
                                Button {
                                    if !isButtonAnimating {
                                        isButtonAnimating = true
                                        viewModel.favorite(isChanging: true)
                                    }
                                } label: {
                                    Image(.favoriteIcon)
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundStyle(buttonColor)
                                        .scaledToFit()
                                        .padding(.all, 8)
                                        .background(Color.tBlack)
                                        .cornerRadius(10)
                                }
                                .frame(width: 40, height: 40)
                                .padding([.trailing, .top, .bottom], 20)
                                .onChange(of: viewModel.isInFavorites) { isFavorites in
                                    
                                    // Animation
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        buttonColor = isFavorites ? .tYellow : .tWhite
                                    }
                                    
                                    animationTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
                                        isButtonAnimating = false
                                    })
                                }
                                .disabled(isButtonAnimating)
                            } /// HStack
                            
                            // Repo Description
                            if let description = viewModel.userData?.repoDescription, !description.isEmpty {
                                Text(viewModel.userData?.repoDescription ?? "...")
                                    .font(.footnote)
                                    .lineLimit(nil)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, -10)
                                    .padding(.bottom, 20)
                                    .padding([.leading, .trailing], 18)
                                    .multilineTextAlignment(.leading)
                            }
                        } /// VStack
                        .background(Color.tBlackLight)
                        .cornerRadius(10)
                    } /// Main VStack
                    .padding(.horizontal, 20)
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                    .frame(alignment: .top)
                } /// ScrollView
//                .disabled(true)
                
                // ProgressView
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                }
            } /// ZStack
            .onAppear {
                viewModel.favorite(isChanging: false)
                viewModel.requestUserData()
            }
        } /// GeometryReader
    }
}

#Preview {
    @State var viewModel = DetailsViewModel(model: RepoModel(nextUrl: nil, lastUrl: nil, id: 1, name: "", fullName: "", owner: Owner(id: 223123), description: ""), networkManager: NetworkManager(), dataManager: RealmManager(), navigation: NavigationManager())
    DetailsView(viewModel: viewModel)
}
