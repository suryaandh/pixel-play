import CoreData

final class FavoriteService {
    private let context = CoreDataManager.shared.context
    
    func addToFavorite(game: GameDetail) async {
        await MainActor.run {
            let fav = FavoriteGame(context: context)
            fav.id = Int64(game.id)
            fav.title = game.name
            fav.released = game.released
            fav.rating = game.rating ?? 0.0
            fav.imageUrl = game.backgroundImage
            
            CoreDataManager.shared.save()
        }
    }
    
    func removeFromFavorite(id: Int) async {
        await MainActor.run {
            let req: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            req.predicate = NSPredicate(format: "id == %d", id)
            
            if let result = try? context.fetch(req).first {
                context.delete(result)
                CoreDataManager.shared.save()
            }
        }
    }
    
    func getFavorites() async -> [FavoriteGame] {
        return await MainActor.run {
            let req: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            return (try? context.fetch(req)) ?? []
        }
    }
    
    func isFavorite(id: Int) async -> Bool {
        return await MainActor.run {
            let req: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            req.predicate = NSPredicate(format: "id == %d", id)
            let count = (try? context.count(for: req)) ?? 0
            return count > 0
        }
    }
}
