import CoreData

class TimerManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    private let lapStore: LapTimeStore
    
    init(context: NSManagedObjectContext) {
        self.lapStore = LapTimeStore(context: context)
    }
    
    private var timer: Timer?
    private var startTime: Date?
    
    var laps: [LapTime] { lapStore.laps }
    
    func lap() {
        guard isRunning else { return }
        let lapNumber = laps.count + 1
        let lapTime = LapTime(
            number: lapNumber,
            duration: elapsedTime,
            timestamp: Date()
        )
        lapStore.addLap(lapTime)
    }
    
    func updateLap(_ lap: LapTime) {
        lapStore.updateLap(lap)
    }
    
    func startStop() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        isRunning.toggle()
    }
    
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
} 