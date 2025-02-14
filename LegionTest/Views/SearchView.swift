import SwiftUI

struct SearchView: View {
    @Binding var text: String
    
    // MARK: - View
    var body: some View {
        ZStack {
            Color.tBlackLight.ignoresSafeArea(.all)
            HStack {
                // Icon
                Image(.searchIcon)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.gray)
                    .scaledToFit()
                    .padding([.vertical, .leading], 10)
                
                // TextField
                TextField("",
                          text: $text,
                          prompt:
                            Text("Type for search...")
                    .foregroundColor(.gray)
                )
                .tint(.white)
                .padding(.trailing, 10)
                .foregroundStyle(.white)
                .frame(height: 40)
            } /// HStack
        } /// ZStack
        .cornerRadius(20)
        .frame(height: 40)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Init
    init(text: Binding<String>) {
        self._text = text
    }
}

#Preview {
    @State var text = "Sample text"
    SearchView(text: $text)
}
