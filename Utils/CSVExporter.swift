import Foundation
import UniformTypeIdentifiers

class CSVExporter {
    static func export(laps: [LapTime]) -> String {
        // ヘッダー行
        let header = "ラップ番号,経過時間,タイムスタンプ,マーク,削除済み\n"
        
        // データ行の作成
        let rows = laps.map { lap in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            return [
                String(lap.number),
                formatTime(lap.duration),
                formatter.string(from: lap.timestamp),
                lap.isMarked ? "✓" : "",
                lap.markedAsDeleted ? "削除済" : ""
            ].joined(separator: ",")
        }.joined(separator: "\n")
        
        return header + rows
    }
    
    private static func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
} 