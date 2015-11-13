
import Foundation
import GoogleMobileAds

/// Ads Displayed once every 3 minutes (max)
class AdManager {
    
    init() {
        self.IsNewAdNeeded = true
        
        self.TestDevices.append("(device id 1)")
        self.TestDevices.append("(device id 2)")
        self.TestDevices.append(kGADSimulatorID.description)
        
        print("Ad Manager -> Init")
    }
    
    var Interstitial : GADInterstitial?
    
    var TestDevices = [String]()
    
    var IsNewAdNeeded : Bool?

    private let USER_IS_PURCHASED = "IsPurchased"
    private let USER_LAST_AD_RUN = "LastAdRun"
    
    var IsNoAdsPurchased : Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(USER_IS_PURCHASED)
        }
    }
    
    var LastRun : CFTimeInterval {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(USER_LAST_AD_RUN) as! CFTimeInterval
        }
        set {
            return NSUserDefaults.standardUserDefaults().boolForKey(USER_LAST_AD_RUN) = newValue
            // may want to add save code here
        }
    }
    
    let AdUnitId = "ca-app-pub-(id numbers)/(id numbers)"
    
    
    // show ads once every 3 minutes
    func IsDoneSkipping() -> Bool {
        if self.LastRun == 0.0 {
            return true
        } else {
            return CACurrentMediaTime() - self.LastRun > 180
        }
    }
 
    
    var IsLoaded : Bool {
        get {
            if self.IsNoAdsPurchased {
                return false
            }
            
            return self.Interstitial?.isReady ?? false
        }
    }
    
    func LoadInterstitial() {
        if self.IsNoAdsPurchased {
            return
        }
        
        if self.IsNewAdNeeded! {
            self.Interstitial = GADInterstitial(adUnitID: self.AdUnitId)
            
            let request = GADRequest()
            request.testDevices = self.TestDevices
            
            self.Interstitial!.loadRequest(request)
            
            print("Ad Manager -> Ad Requested")
        }
        else {
            print("Ad Manager -> Ad Request Not Needed")
        }
    }
    func DisplayInterstitial() {
        
        if self.IsNoAdsPurchased {
            return
        }
        
        if self.Interstitial?.isReady ?? false {

            if !self.IsDoneSkipping() {
                print("Ad Manager -> Display -> Ad is currently skipped")
                return
            }
            
            self.IsNewAdNeeded = true
            self.LastRun = CACurrentMediaTime()
            print("Ad Manager -> Display -> Interstitial Loaded")
            self.Interstitial!.presentFromRootViewController(UIApplication.sharedApplication().keyWindow?.rootViewController!)
            print("Ad Manager -> Display -> Interstitial Showing")
            
        } else {
            print("Ad Manager -> Display -> Interstitial NOT Loaded Yet")
        }

    }
   
}
