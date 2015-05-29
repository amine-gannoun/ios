import Foundation
import UIKit

enum AuthMode {
    case SignIn
    case SignUp
}


class AuthCredentialsController: UIViewController {
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var mode: AuthMode
    
    init(mode: AuthMode) {
        self.mode = mode
        super.init(nibName: "AuthCredentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.mode {
        case .SignIn:
            self.title = "Sign In"
            self.btnSignIn.setTitle("Sign In", forState: UIControlState.Normal)
        case .SignUp:
            self.title = "Sign Up"
            self.btnSignIn.setTitle("Sign Up", forState: UIControlState.Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationController!.setToolbarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSignInClick(sender: UIButton) {
        switch self.mode {
        case .SignIn:
            self.signIn()
        case .SignUp:
            self.signUp()
        }
    }
    
    func signIn() {
        self.activityIndicator.startAnimating()
        
        var email = self.emailTextEdit.text
        var password = self.passwordTextEdit.text
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            var service = RedirectService(apiUrl: "http://api.syncloud.it")
            var result = service.getUser(email, password: password)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    
                } else {
                    Storage.saveCredentials(email: email, password: password)
                    var viewDevices = DomainsViewController(user: result.user!)
                    self.navigationController!.replaceAll(viewDevices, animated: true)
                }
            }
        }
    }
    
    func signUp() {
        
    }
}