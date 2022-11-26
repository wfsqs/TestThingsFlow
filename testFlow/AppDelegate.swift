import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = IssueListViewController.instances()

        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL,
           url.pathComponents.count == 2 {
            UserDefaults.standard.set(url.host, forKey: "keyOwner")
            UserDefaults.standard.set(url.pathComponents[1], forKey: "keyRepo")
        }
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if url.pathComponents.count == 2 {
            GlobalState.shared.refreshIssue.onNext((url.host ?? "", url.pathComponents[1]))
        }
        
        return true
    }
}

