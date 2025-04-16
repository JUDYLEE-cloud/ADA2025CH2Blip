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
            
            TextField("입력해주세요", text: $text)
                .padding(12)
                .background(Color.clear)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color("CustomGray"), lineWidth: 2)
                )
        }
    }
}

#Preview {
    TextFieldCustom(title: "ID", text: .constant(""))
        .padding(.horizontal, 40)
        .background{
            Color.black
        }
}
