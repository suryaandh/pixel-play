import SwiftUI

struct FavoriteListView: View {
    @StateObject private var vm = FavoriteViewModel()
    @State private var selectedGameId: Int? = nil
    
    var body: some View {
        Group {
            if vm.favorites.isEmpty && !vm.isLoading {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No Favorites Yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Games you favorite will appear here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)            } else {
                    List {
                        ForEach(vm.favorites, id: \.objectID) { fav in
                            FavoriteRowView(
                                fav: fav,
                                vm: vm,
                                selectGameId: $selectedGameId
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadFavorites()
        }
        .refreshable {
            await vm.loadFavorites()
        }
    }
}
