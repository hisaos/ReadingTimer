import SwiftUI

struct TimerDisplay: View {
    let timeInterval: TimeInterval
    
    var body: some View {
        Text(timeString(from: timeInterval))
            .font(.system(size: 60, weight: .medium, design: .monospaced))
            .frame(maxWidth: .infinity)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
} 