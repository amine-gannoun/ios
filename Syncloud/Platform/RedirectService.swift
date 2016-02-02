import Foundation

class RedirectService: IUserService {
    var webService: WebService
    
    init(apiUrl: String) {
        self.webService = WebService(apiUrl: apiUrl)
    }
    
    func getUser(email: String, password: String) -> UserResult {
        let request = Request(RequestType.GET, "/user/get", ["email": email, "password": password])
        let (response, error) = webService.execute(request)
        
        if error != nil {
            return (user: nil, error: error)
        }
        
        let user = User(json: response!["data"] as! NSDictionary)

        return (user: user, error: nil)
    }

    func createUser(email: String, password: String) -> UserResult {
        let request = Request(RequestType.POST, "/user/create", ["email": email, "password": password])
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