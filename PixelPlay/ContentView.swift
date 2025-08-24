import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        NavigationStack {
            Group {
                if showSplash {
                    SplashView(onFinish: { showSplash = false })
                } else {
                    GameListView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

