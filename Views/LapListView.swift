struct LapListView: View {
    @Binding var laps: [LapTime]
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    
    var body: some View {
        List {
            ForEach($laps) { $lap in
                HStack {
                    Text("Lap \(lap.number)")
                    Spacer()
                    Text(timeString(from: lap.duration))
                    
                    Button(action: { lap.isMarked.toggle() }) {
                        Image(systemName: lap.isMarked ? "xmark.circle.fill" : "circle")
                    }
                    
                    Button(action: { lap.isDeleted.toggle() }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .opacity(lap.isDeleted ? 0.5 : 1)
                .font(lap.isDeleted ? .callout : .body)
            }
        }
        .navigationTitle("ラップタイム")
        .toolbar {
            Button("CSVエクスポート") {
                exportCSV()
            }
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
        return String(format: "%02d:%02d", minutes, seconds)
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