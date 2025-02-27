import SwiftUI
import ComposableArchitecture
import UIKit

struct DetailsView: View {
    @Perception.Bindable var store: StoreOf<DetailsReducer>
    
    @State private var isButtonAnimating = false
    @State private var buttonColor: Color = .tWhite
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            WithPerceptionTracking {
                ZStack {
                    // Background
                    Color.tBlack.edgesIgnoringSafeArea(.all)
                    
                    // ScrollView
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            VStack {
                                // User Name
                                Text(store.userData?.name ?? "...")
                                    .font(.system(size: 13, weight: .bold))
                                    .lineLimit(2)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.leading)
                                    .padding([.top, .bottom], 10)
                                
                                // User Email
                                if let email = store.userData?.email, !email.isEmpty {
                                    Text(store.userData?.email ?? "...")
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
                                    Text(store.userData?.repoName ?? "...")
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
                                            store.send(.ui(.onFavoriteButtonTapped))
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
                                    .onChange(of: store.isInFavorites) { isFavorites in
                                        
                                        // Animation
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            buttonColor = isFavorites ? .tYellow : .tWhite
                                            isButtonAnimating = false
                                        }
                                    }
                                    .disabled(isButtonAnimating)
                                } /// HStack
                                
                                // Repo Description
                                if let description = store.userData?.repoDescription, !description.isEmpty {
                                    Text(store.userData?.repoDescription ?? "...")
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
                    
                    Group {
                        WithPerceptionTracking {
                            switch store.screenState {
                            case .loading:
                                Color.black.opacity(0.5)
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2)
                            case .success:
                                EmptyView()
                            }
                        }
                    }
                } /// ZStack
                .onAppear {
                    store.send(.ui(.onAppear))
                }
            } /// WithPerceptionTracking
        } /// GeometryReader
    }
}

#Preview {
    DetailsView(store: Store(initialState: DetailsReducer.State(repoModel: RepoModel(nextUrl: nil, lastUrl: nil, id: 21, name: "sdasd", fullName: "name", owner: Owner(id: 2323), description: "asdasd")), reducer: {
        DetailsReducer()
    }))
}
