import CoreData
import SwiftUI

class LapTimeStore: ObservableObject {
    @Published var laps: [LapTime] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchLaps()
    }
    
    // ラップタイムの取得
    func fetchLaps() {
        let request = NSFetchRequest<LapTimeEntity>(entityName: "LapTimeEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LapTimeEntity.number, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            self.laps = entities.map { entity in
                LapTime(
                    id: entity.id ?? UUID(),
                    number: Int(entity.number),
                    duration: entity.duration,
                    timestamp: entity.timestamp ?? Date(),
                    isMarked: entity.isMarked,
                    markedAsDeleted: entity.markedAsDeleted
                )
            }
        } catch {
            print("取得エラー: \(error.localizedDescription)")
        }
    }
    
    // 新規ラップの追加
    func addLap(_ lap: LapTime) {
        let entity = LapTimeEntity(context: context)
        entity.id = lap.id
        entity.number = Int64(lap.number)
        entity.duration = lap.duration
        entity.timestamp = lap.timestamp
        entity.isMarked = lap.isMarked
        entity.markedAsDeleted = lap.markedAsDeleted
        
        PersistenceController.shared.save()
        fetchLaps()
    }
    
    // ラップの更新
    func updateLap(_ lap: LapTime) {
        let request = NSFetchRequest<LapTimeEntity>(entityName: "LapTimeEntity")
        request.predicate = NSPredicate(format: "id == %@", lap.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                entity.isMarked = lap.isMarked
                entity.markedAsDeleted = lap.markedAsDeleted
                PersistenceController.shared.save()
                fetchLaps()
            }
        } catch {
            print("更新エラー: \(error.localizedDescription)")
        }
    }
    
    // 全ラップの削除
    func deleteAllLaps() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LapTimeEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            PersistenceController.shared.save()
            fetchLaps()
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }
} 