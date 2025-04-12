import SwiftUI

struct HomeView: View {
    @State private var isMoodModalPresented: Bool = false
    @State private var selectedMoodIcon: String = "Mascarade"
    
    var body: some View {
        ZStack {
            Map()
            HomeViewGradation()
            
            VStack {
                HStack {
                    Spacer()
                    Image("Setting")
                        .padding(.trailing, 15)
                }
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 14) {
                    Image("Search")
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                    ZStack {
                        Image("MainButton")
                           .resizable()
                           .frame(width: 100, height: 100)
                           
                        Image(selectedMoodIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: selectedMoodIcon == "Mascarde" ? 58 : 53)
                            .padding(.leading, selectedMoodIcon == "Mascarde" ? 20 : 3)
                            .padding(.top, selectedMoodIcon == "Mascarde" ? 0 : 5)
                    }
                    .onTapGesture {
                        isMoodModalPresented = true
                    }
                     
                    
                    Image("LocationButton")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom)
                .sheet(isPresented: $isMoodModalPresented) {
                    MoodModalView(selectedMoodIcon: $selectedMoodIcon)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
