import UIKit
import Firebase
import FirebaseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
