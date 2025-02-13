import Cocoa
import QuickLookUI

class PreviewItem: NSObject, QLPreviewItem {
    private var url: URL
    private var title: String

    convenience init(path: String) {
        let url = URL(fileURLWithPath: path)
        let title = url.lastPathComponent
        self.init(url: url, title: title)
    }

    convenience init(path: String, title: String) {
        let url = URL(fileURLWithPath: path)
        self.init(url: url, title: title)
    }

    init(url: URL, title: String) {
        self.url = url
        self.title = title
    }

    var previewItemURL: URL! {
        return url
    }

    var previewItemTitle: String! {
        return title
    }
}

class Preview: NSObject, QLPreviewPanelDelegate, QLPreviewPanelDataSource {
    private let panel: QLPreviewPanel = QLPreviewPanel.shared()

    private var item: PreviewItem

    init(item: PreviewItem) {
        self.item = item
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return item
    }

    func show() {
        panel.currentPreviewItemIndex = 0
        panel.dataSource = self
        panel.delegate = self

        panel.updateController()
        panel.makeKeyAndOrderFront(nil)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var args: Args

    init(_ args: Args) {
        self.args = args
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        view(args)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func view(_ args: Args) {
        let item = PreviewItem.from(args: args)
        let preview = Preview(item: item)
        preview.show()
    }
}

extension PreviewItem {
    static func from(args: Args) -> PreviewItem {
        guard let title = args.title else {
            return PreviewItem(path: args.path)
        }

        return PreviewItem(path: args.path, title: title)
    }
}

enum ArgumentsError: Error {
    case invalid
    case empty
}

class Args {
    static let usage: String = "Usage: ql [--title <title>] <path>"

    var path: String
    var title: String?

    init(path: String, title: String?) {
        self.path = path
        self.title = title
    }

    static func from(_ arguments: [String]) throws -> Args {
        if arguments.count <= 1 {
            throw ArgumentsError.empty
        }

        var path: String?
        var title: String?

        var args = arguments[1..<arguments.endIndex]

        while args.count > 0 {
            let arg = args.removeFirst()

            if (arg == "--title") {
                guard args.count > 0 else {
                    throw ArgumentsError.invalid
                }

                title = args.removeFirst()
                continue
            }

            path = arg;
        }

        guard path != nil else {
            throw ArgumentsError.invalid
        }

        return Args(path: path!, title: title)
    }
}

// main

guard let args = try? Args.from(CommandLine.arguments) else {
    print(Args.usage)
    exit(1)
}

let app = NSApplication.shared

let delegate = AppDelegate(args)
app.delegate = delegate

app.run()
