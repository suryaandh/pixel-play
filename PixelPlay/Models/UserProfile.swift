import Foundation

struct UserProfile: Codable, Equatable {
    var name: String
    var email: String
    var phone: String
    var imageURL: String
    
    init(name: String = "", email: String = "", phone: String = "", imageURL: String = "") {
        self.name = name
        self.email = email
        self.phone = phone
        self.imageURL = imageURL
    }
    
    static var defaultProfile: UserProfile {
        UserProfile(
            name: "Gde Swiyasa",
            email: "gdeswiyasa123@gmail.com",
            phone: "+62 812 3456 7890",
            imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrBGI8qZsUYY_WpTFeIy37mOXKua5BN-WNbQ&s"
        )
    }
    
    var isValid: Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty &&
               !email.trimmingCharacters(in: .whitespaces).isEmpty &&
               !phone.trimmingCharacters(in: .whitespaces).isEmpty &&
               isValidEmail
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

enum ProfileUpdateResult {
    case success
    case failure(ProfileError)
}

enum ProfileError: LocalizedError {
    case invalidName
    case invalidEmail
    case invalidPhone
    case emptyName
    case emptyEmail
    case emptyPhone
    case networkError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Name cannot be empty"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPhone:
            return "Phone number cannot be empty"
        case .emptyName:
            return "Name cannot be empty"
        case .emptyEmail:
            return "Email cannot be empty"
        case .emptyPhone:
            return "Phone number cannot be empty"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
