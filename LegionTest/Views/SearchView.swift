import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @Binding var text: String
    @FocusState private var isTextFieldFocused: Bool
    var textFieldFocusing: ((Bool) -> Void)?
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
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
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused, perform: { isFocused in
                        textFieldFocusing?(isFocused)
                    })
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
    }
    
    // MARK: - Init
    init(text: Binding<String>, textFieldFocusing: ((Bool) -> Void)? = nil) {
        self.textFieldFocusing = textFieldFocusing
        self._text = text
    }
}

#Preview {
    @State var text = "Sample text"
    SearchView(text: $text)
}
