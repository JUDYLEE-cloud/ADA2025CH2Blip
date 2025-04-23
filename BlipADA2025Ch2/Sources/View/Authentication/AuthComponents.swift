import SwiftUI

struct GreenButton: View {
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("MainColor"))
                .frame(height: 44)
                .padding(.horizontal, 30)
            
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 30)
    }
}

struct TextFieldCustom: View {
    @State var title: String
    @Binding var text: String
    @FocusState var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color("CustomWhite"))
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding(.bottom, 2)
            
            ZStack {
                if title == "Password" {
                    if isPasswordVisible {
                        TextField("입력해주세요", text: $text)
                            .padding(12)
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .focused($isFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(isFocused ? Color("MainColor") : Color("CustomGray"), lineWidth: 2)
                            )
                    } else {
                        SecureField("입력해주세요", text: $text)
                            .padding(12)
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .focused($isFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(isFocused ? Color("MainColor") : Color("CustomGray"), lineWidth: 2)
                            )
                    }
                } else {
                    TextField("입력해주세요", text: $text)
                        .padding(12)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .focused($isFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(isFocused ? Color("MainColor") : Color("CustomGray"), lineWidth: 2)
                        )
                }
                
                if title == "Password" {
                    HStack {
                        Spacer()
                        
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(Color("CustomGray"))
                                .padding(.trailing, 10)
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        TextFieldCustom(title: "ID", text: .constant(""))
            .padding(.horizontal, 40)
            .background{
                Color.black
            }
        
        TextFieldCustom(title: "Password", text: .constant(""))
            .padding(.horizontal, 40)
            .background{
                Color.black
            }
    }
}
