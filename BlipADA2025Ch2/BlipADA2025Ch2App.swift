import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore
import WidgetKit

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct BlipADA2025Ch2App: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        print("🔥 앱이 시작됨 - App init")
        fetchUsersForWidget {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
