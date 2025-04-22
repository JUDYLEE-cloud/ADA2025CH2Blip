import SwiftUI

struct HomeView: View {
    @State private var isMoodModalPresented: Bool = false
    @AppStorage("selectedMoodType", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) private var storedMoodType: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    @State private var mapViewId = UUID()
    @State private var isShowingSetting = false
    
    private let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView()
                    .id(mapViewId)
                HomeViewGradation()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Image("Setting")
                            .padding(.trailing, 15)
                            .onTapGesture {
                                isShowingSetting = true
                            }
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 14) {
                        Button {
                            print("search 클릭됨")
                        } label: {
                            Image("Search")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        
                        ZStack {
                            Image("MainButton")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Image(MoodType(rawValue: storedMoodType)?.iconName ?? "Mascarade")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: MoodType(rawValue: storedMoodType)?.iconName == "Mascarade" ? 58 : 53)
                                .padding(.leading, MoodType(rawValue: storedMoodType)?.iconName == "Mascarade" ? 10 : 3)
                                .padding(.top, MoodType(rawValue: storedMoodType)?.iconName == "Mascarade" ? 0 : 5)
                        }
                        .onTapGesture {
                            isMoodModalPresented = true
                        }
                        
                        Image("LocationButton")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                NotificationCenter.default.post(name: NSNotification.Name("ScrollToTargetPoint"), object: nil)
                            }
                    }
                }
                .sheet(isPresented: $isMoodModalPresented) {
                    MoodModalView()
                }
                .fullScreenCover(isPresented: $isShowingSetting) {
                    SettingView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
