import SwiftUI
import ComposableArchitecture

// MARK: - CollectionView
struct CollectionView: View {
    var items: [RepoModel]
    var didDisplayCell: ((Int) -> Void)?
    var presentDetails: ((RepoModel) -> Void)?
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    let fixedCellHeight: CGFloat = 60
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            Text("\(item.name)")
                                .font(.system(size: 13, weight: .bold))
                                .lineLimit(2)
                                .foregroundStyle(.white)
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                            Text("\(item.fullName)")
                                .font(.footnote)
                                .lineLimit(1)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.top, -10)
                                .padding(.bottom, 10)
                        }
                        .background(Color.tBlackLight)
                        .cornerRadius(10)
                        .frame(height: fixedCellHeight)
                        .onAppear {
                            guard let index = items.firstIndex(where: { $0 == item }) else { return }
                            didDisplayCell?(index)
                        }
                        .onTapGesture {
                            presentDetails?(item)
                        }
                    }
                } /// LazyVGrid
                .foregroundStyle(.clear)
                .padding(.top, 2)
            } /// ScrollView
        }
    }
}

#Preview {
    @State var items = [RepoModel(nextUrl: nil, lastUrl: nil, id: 12, name: "Some123213213213213123123", fullName: "Some", owner: .init(id: 312321), description: nil), RepoModel(nextUrl: nil, lastUrl: nil, id: 123, name: "Some", fullName: "Some", owner: .init(id: 23123123), description: nil)]
    CollectionView(items: items)
}
