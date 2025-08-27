import SwiftUI

struct ValidationErrorSection: View {
    let error: String
    
    var body: some View {
        if !error.isEmpty {
            Section {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
