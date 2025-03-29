import SwiftUI
import CoreData

struct TimerView: View {
    @StateObject private var timerManager: TimerManager
    
    init(context: NSManagedObjectContext) {
        _timerManager = StateObject(wrappedValue: TimerManager(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // タイマー表示
                Text(timeString(from: timerManager.elapsedTime))
                    .font(.system(size: 60, weight: .medium, design: .monospaced))
                
                // 最新のラップタイム表示
                if let lastLap = timerManager.laps.last {
                    Text("Lap \(lastLap.number): \(timeString(from: lastLap.duration))")
                        .font(.system(size: 20, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                // コントロールボタン
                HStack(spacing: 50) {
                    Button(action: { timerManager.lap() }) {
                        Circle()
                            .fill(.white)
                            .frame(width: 80, height: 80)
                            .overlay {
                                Text("ラップ")
                                    .foregroundColor(.black)
                            }
                    }
                    .disabled(!timerManager.isRunning)
                    
                    Button(action: { timerManager.startStop() }) {
                        Circle()
                            .fill(timerManager.isRunning ? .red : .green)
                            .frame(width: 80, height: 80)
                            .overlay {
                                Text(timerManager.isRunning ? "停止" : "開始")
                                    .foregroundColor(.white)
                            }
                    }
                }
                
                // ラップ一覧へのナビゲーション
                NavigationLink(destination: LapListView(laps: $timerManager.laps, timerManager: timerManager)) {
                    Text("ラップタイム一覧")
                }
            }
            .padding()
            .navigationTitle("タイマー")
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
} 