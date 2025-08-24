import Foundation

extension String {
    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return self
    }
}
