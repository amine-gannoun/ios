import Foundation

class RedirectService: IUserService {
    var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func getUser(_ email: String, password: String) -> UserResult {
        let request = Request(RequestType.get, "/user/get", ["email": email, "password": password])
        let (response, error) = webService.execute(request)
        
        if error != nil {
            return (user: nil, error: error)
        }
        
        let user = User(json: response!["data"] as! NSDictionary)

        return (user: user, error: nil)
    }

    func createUser(_ email: String, password: String) -> UserResult {
        let request = Request(RequestType.post, "/user/create", ["email": email, "password": password])
        let (response, error) = webService.execute(request)

        if error != nil {
            if error is ResultError {
                let resultError = error as! ResultError
                return (user: nil, error: resultError)
            } else {
                return (user: nil, error: error)
            }
        }

        let user = User(json: response!["data"] as! NSDictionary)

        return (user: user, error: nil)
    }
}
