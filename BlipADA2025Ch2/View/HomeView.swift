import SwiftUI

struct HomeView: View {
    @State private var isMoodModalPresented: Bool = false
    @State private var currentMoodIcon: String = "Mascarade"
    @AppStorage("selectedMoodType", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) private var storedMoodType: String = ""
    private let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
    
    private func updateCurrentMoodIcon() {
        let savedTime = defaults?.object(forKey: "selectedMoodSavedTime") as? Date ?? Date.distantPast
        let now = Date()
        
        if now.timeIntervalSince(savedTime) > 3 * 60 * 60 {
            defaults?.removeObject(forKey: "selectedMoodType")
            defaults?.removeObject(forKey: "selectedMoodSavedTime")
            currentMoodIcon = "Mascarade"
        } else {
            if storedMoodType.isEmpty {
                currentMoodIcon = "Mascarade"
            } else if let mood = MoodType(rawValue: storedMoodType) {
                currentMoodIcon = mood.iconName
            } else {
                currentMoodIcon = "Mascarade"
            }
        }
    }
    
    var body: some View {
        ZStack {
            MapView()
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
                           
                        Image(currentMoodIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: currentMoodIcon == "Mascarade" ? 58 : 53)
                            .padding(.leading, currentMoodIcon == "Mascarade" ? 10 : 3)
                            .padding(.top, currentMoodIcon == "Mascarade" ? 0 : 5)
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
                    MoodModalView()
                }
            }
        }
        .onAppear {
            updateCurrentMoodIcon()
        }
        .onChange(of: storedMoodType) { oldValue, newValue in
            updateCurrentMoodIcon()
        }
    }
}

#Preview {
    HomeView()
}
