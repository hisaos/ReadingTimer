import SwiftUI

struct LapRow: View {
    let lap: LapTime
    let onMark: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text("Lap \(lap.number)")
            Spacer()
            Text(timeString(from: lap.duration))
            
            Button(action: onMark) {
                Image(systemName: lap.isMarked ? "xmark.circle.fill" : "circle")
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .opacity(lap.markedAsDeleted ? 0.5 : 1)
        .font(lap.markedAsDeleted ? .callout : .body)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 