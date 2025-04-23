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
                            .padding(.trailing, 20)
                            .onTapGesture {
                                isShowingSetting = true
                            }
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        Button {
                            print("search 클릭됨")
                        } label: {
                            Image("Search")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .padding(.bottom, -30)
                        }
                        
                        ZStack {
                            Image("MainButton")
                                .resizable()
                                .frame(width: 180, height: 180)
                            
                            Image(MoodTypeModel(rawValue: storedMoodType)?.iconName ?? "Mascarade")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: MoodTypeModel(rawValue: storedMoodType)?.iconName == "Mascarade" ? 58 : 53)
                                .padding(.leading, MoodTypeModel(rawValue: storedMoodType)?.iconName == "Mascarade" ? 10 : 3)
                                .padding(.top, MoodTypeModel(rawValue: storedMoodType)?.iconName == "Mascarade" ? -2 : -9)
                        }
                        .padding(.bottom, -40)
                        .padding(.horizontal, -50)
                        .onTapGesture {
                            isMoodModalPresented = true
                        }
                        
                        Image("LocationButton")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .padding(.bottom, -30)
                            .onTapGesture {
                                NotificationCenter.default.post(name: NSNotification.Name("ScrollToTargetPoint"), object: nil)
                            }
                    }
                }
                .sheet(isPresented: $isMoodModalPresented) {
                    MoodModalView()
                }
                .fullScreenCover(isPresented: $isShowingSetting) {
                    SettingView(viewModel: AuthViewModel())
                }
                .onAppear{
                    fetchUsersForWidget()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
