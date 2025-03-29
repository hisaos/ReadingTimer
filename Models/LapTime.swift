import Foundation

struct LapTime: Identifiable {
    let id: UUID
    let number: Int
    let duration: TimeInterval
    let timestamp: Date
    var isMarked: Bool
    var markedAsDeleted: Bool
    
    init(
        id: UUID = UUID(),
        number: Int,
        duration: TimeInterval,
        timestamp: Date = Date(),
        isMarked: Bool = false,
        markedAsDeleted: Bool = false
    ) {
        self.id = id
        self.number = number
        self.duration = duration
        self.timestamp = timestamp
        self.isMarked = isMarked
        self.markedAsDeleted = markedAsDeleted
    }
} 