import SwiftUI
import UniformTypeIdentifiers

struct LapListView: View {
    @Binding var laps: [LapTime]
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    @State private var showingResetAlert = false
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        List {
            ForEach(laps.indices, id: \.self) { index in
                HStack {
                    Text("Lap \(laps[index].number)")
                    Spacer()
                    Text(timeString(from: laps[index].duration))
                        .font(.system(.body, design: .monospaced))
                    
                    Button(action: { laps[index].isMarked.toggle() }) {
                        Image(systemName: laps[index].isMarked ? "xmark.circle.fill" : "circle")
                    }
                    
                    Button(action: { laps[index].markedAsDeleted.toggle() }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .opacity(laps[index].markedAsDeleted ? 0.5 : 1)
                .font(laps[index].markedAsDeleted ? .callout : .body)
            }
        }
        .navigationTitle("ラップタイム")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button("CSVエクスポート") {
                        exportCSV()
                    }
                    
                    Button("リセット") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert("ラップタイムのリセット", isPresented: $showingResetAlert) {
            Button("キャンセル", role: .cancel) { }
            Button("リセット", role: .destructive) {
                timerManager.reset()
            }
        } message: {
            Text("すべてのラップタイムが削除されます。この操作は取り消せません。")
        }
        .fileExporter(
            isPresented: $showingExportSheet,
            document: CSVFile(initialText: CSVExporter.export(laps: laps)),
            contentType: .commaSeparatedText,
            defaultFilename: "reading_timer_\(Date().ISO8601Format()).csv"
        ) { result in
            switch result {
            case .success(let url):
                print("CSVファイルを保存しました: \(url)")
            case .failure(let error):
                print("エクスポートエラー: \(error.localizedDescription)")
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    private func exportCSV() {
        showingExportSheet = true
    }
}

// CSVファイルを表すための構造体
struct CSVFile: FileDocument {
    static var readableContentTypes = [UTType.commaSeparatedText]
    
    var text: String
    
    init(initialText: String = "") {
        text = initialText
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            text = ""
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
} 