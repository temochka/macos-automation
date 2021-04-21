import Cocoa

func toJSON(dict: NSDictionary) -> String {
    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
    if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
        return jsonResult
    }
    return ""
}

extension String {
    var markdownTableSafe: String {
        self.replacingOccurrences(of: "|", with: "&#124;")
    }
}

let pasteboard = NSPasteboard.general

let json: NSDictionary = [
    "html": pasteboard.string(forType: NSPasteboard.PasteboardType.html) as Any,
    "rtfAsHtml": {
        if let richTextData = pasteboard.data(forType: NSPasteboard.PasteboardType.rtf)
        {
            let rtfString = try! NSAttributedString(data: richTextData, documentAttributes: nil)
            let documentAttributes: [NSAttributedString.DocumentAttributeKey : Any] = [
                NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentAttributeKey.characterEncoding: String.Encoding.utf8.rawValue,
            ]
            let htmlData = try! rtfString.data(from: NSMakeRange(0, rtfString.length), documentAttributes:documentAttributes)
            let htmlString = String(data:htmlData, encoding: String.Encoding.utf8)
            return htmlString
        }
        return nil
    }() as String? as Any,
    "text": pasteboard.string(forType: NSPasteboard.PasteboardType.string) as Any,
    "url": pasteboard.string(forType: NSPasteboard.PasteboardType.URL) as Any,
    "asMarkdownTable": {
        if let lines = pasteboard.string(forType: NSPasteboard.PasteboardType.string)?.components(separatedBy: "\n"),
           lines.count > 0 {
            let inputTable = lines.map { $0.components(separatedBy: "\t") }
            let headerColumns = inputTable.first!
            let maxWidths = headerColumns.enumerated().map { (index, _) in
                inputTable.map { index < $0.count ? $0[index].unicodeScalars.count : 0 }.max()
            }

            let renderedRows = inputTable.map { row in
                row
                    .prefix(headerColumns.count)
                    .enumerated()
                    .map { (index, col) in col.markdownTableSafe.padding(toLength: maxWidths[index]!, withPad: " ", startingAt: 0) }
                    .joined(separator: " | ")
            }

            let divider = headerColumns
                .enumerated()
                .map { (index, _) in String(repeating: "-", count: maxWidths[index]!) }
                .joined(separator: " | ")

            return "| \(renderedRows.first!) |\n| \(divider) |\n| \(renderedRows.dropFirst(1).joined(separator: " |\n| ")) |"
        }
        return nil
    }() as String? as Any
]

print(toJSON(dict: json))
