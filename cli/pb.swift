import Cocoa

func toJSON(dict: NSDictionary) -> String {
    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
    if let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8) {
        return jsonResult
    }
    return ""
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
]

print(toJSON(dict: json))
