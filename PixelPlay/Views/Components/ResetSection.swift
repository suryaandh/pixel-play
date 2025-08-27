import SwiftUI

struct ResetSection: View {
    let isUpdating: Bool
    let onReset: () -> Void
    
    var body: some View {
        Section {
            Button(action: onReset) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset to Default")
                }
                .foregroundColor(.orange)
            }
            .disabled(isUpdating)
        }
    }
}


