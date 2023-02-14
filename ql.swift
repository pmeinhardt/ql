#!/usr/bin/env swift

import Cocoa
import QuickLookUI

class PreviewItem : NSObject, QLPreviewItem {
    private var path: String!

    init(path: String) {
        self.path = path
    }

    var previewItemURL: URL! {
        return URL(fileURLWithPath: path)
    }

    var previewItemTitle: String! {
        return "Preview"
    }
}

class Preview : NSObject, QLPreviewPanelDelegate, QLPreviewPanelDataSource {
    private let panel: QLPreviewPanel! = QLPreviewPanel.shared()

    private var item: PreviewItem!

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

class AppDelegate : NSObject, NSApplicationDelegate {
    private var path: String!

    init(_ path: String) {
        self.path = path
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        view(path)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func view(_ path: String) {
        let item = PreviewItem(path: path)
        let preview = Preview(item: item)
        preview.show()
    }
}

// main

let arguments = CommandLine.arguments

if arguments.count <= 1 {
    print("usage: ql <path>")
    exit(1)
}

let path = arguments[1]

let app = NSApplication.shared

let delegate = AppDelegate(path)
app.delegate = delegate

app.run()
