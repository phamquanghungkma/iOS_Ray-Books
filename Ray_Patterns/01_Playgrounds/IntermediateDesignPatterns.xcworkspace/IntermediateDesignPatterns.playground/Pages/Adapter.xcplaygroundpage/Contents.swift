/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Adapter
 - - - - - - - - - -
 ![Adapter Diagram](Adapter_Diagram.png)
 
 The adapter pattern allows incompatible types to work together. It involves four components:
 
 1. An **object using an adapter** is the object that depends on the new protocol.
 
 2. The **new protocol** that is desired to be used.
 
 3. A **legacy object** that existed before the protocol was made and cannot be modified directly to conform to it.
 
 4. An **adapter** that's created to conform to the protocol and passes calls onto the legacy object.
 
 ## Code Example
 */
import UIKit
// MARK: - Legacy Object
public  class GoogleAuthenticator {
    public func login(
        email: String,
        password: String,
        completion: @escaping (GoogleUser?, Error?) -> Void) {
        // Make networking calls that return a token string
        let token = "special-token-value"
        let user = GoogleUser(email: email,
                              password: password,
                              token: token)
        completion(user, nil)
    }
}

public struct GoogleUser {
    public var email: String
    public var password: String
    public var token: String
}

// MARK: - New Protocol
public protocol AuthenticationService {
    func login(email: String,
               password: String,
               success: @escaping (User, Token) -> Void,
               failure: @escaping (Error?) -> Void)
}

public struct User {
    public let email: String
    public let password: String
}
public struct Token {
    public let value: String
}


// MARK: - Adapter
// 1 ou create GoogleAuthenticationAdapter as the adapter between GoogleAuthenticationAdapter and AuthenticationService.
public class GoogleAuthenticatorAdapter: AuthenticationService {
    // 2 You declare a private reference to GoogleAuthenticator, so it's hidden from end consumers.
    private var authenticator = GoogleAuthenticator()
    // 3 You add the AuthenticationService login method as required by the protocol. Inside this method, you call Google’s login method to get a GoogleUser.
    public func login(email: String,
                      password: String,
                      success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void) {
        authenticator.login(email: email, password: password) { (googleUser, error) in
            // 4 If there's an error, you call failure with it.
            guard let googleUser = googleUser else {
                failure(error)
                return
            }
            // 5 Otherwise, you create user and token from the googleUser and call success
            let user = User(email: googleUser.email, password: googleUser.password)
            let token = Token(value: googleUser.token)
            success(user, token)
        }
    }
}


// MARK: - Object Using an Adapter
// 1 You first declare a new class for LoginViewController. It has an authService property and text fields for the e-mail and password. In a real view controller, you'd create the views in loadView or declare each as an @IBOutlet. For simplicity's sake here, you set them to new UITextField instances.
public class LoginViewController: UIViewController {
    // MARK: - Properties
    public var authService: AuthenticationService!
    // MARK: - Views
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    // MARK: - Class Constructors
    // 2 You then create a class method that instantiates a LoginViewController and sets authService.
    public class func instance(
        with authService: AuthenticationService)
        -> LoginViewController {
            let viewController = LoginViewController()
            viewController.authService = authService
            return viewController
    }
    // 3 Lastly, you create a login method that calls authService.login with the e-mail and password from the text fields.
    public func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("Email and password are required inputs!")
                return
        }
        authService.login(
            email: email,
            password: password,
            success: { user, token in
                print("Auth succeeded: \(user.email), \(token.value)")
        },
            failure: { error in
                print("Auth failed with error: no error provided")
        })
    }
}


// MARK: - Example
let viewController = LoginViewController.instance( with: GoogleAuthenticatorAdapter())
viewController.emailTextField.text = "user@example.com"
viewController.passwordTextField.text = "password"
viewController.login()
