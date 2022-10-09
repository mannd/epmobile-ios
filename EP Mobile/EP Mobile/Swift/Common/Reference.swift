//
//  Reference.swift
//  EP Mobile
//
//  Created by David Mann on 10/8/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

// Ideally this should be a struct, but ObjC can't interact with Swift structs.
// The Reference class stores a reference (AMA format) including its URI or DOI link.
// Note form references with a URI, do not included the "cited on date" part.
@objc
final class Reference: NSObject {
    var text: String // The reference not including the link.
    var link: String // The link in URI or DOI format.

    @objc
    init(text: String, link: String) {
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.link = link.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    @objc
    /// Create a Reference using an AMA style reference
    /// - Parameter fullReference: String in AMA style format.
    init?(_ fullReference: String) {
        let textPlusLink = Self.parseFullReference(fullReference: fullReference)
        if let textPlusLink {
            self.text = textPlusLink.text
            self.link = textPlusLink.link
        } else {
            return nil
        }
    }

    /// Parse an AMA style reference into text and link components.
    /// - Parameter fullReference: AMA style reference string
    /// - Returns: tuple with text and link components, nil if string doesn't contain a link
    static func parseFullReference(fullReference: String) -> (text: String, link: String)? {
        let lowerCaseRef = fullReference.lowercased()
        var range: Range<String.Index>?
        if lowerCaseRef.contains("doi:") {
            range = lowerCaseRef.range(of: "doi:")
        } else if lowerCaseRef.contains("http") {
            range = lowerCaseRef.range(of: "http")
        } else {
            return nil
        }
        if let range {
            let text = String(fullReference[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let link = String(fullReference[range.lowerBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            return (text, link)
        }
        return nil
    }

    func getUri() -> String? {
        return link.convertDoiToUri()
    }

    func getMarkdownLink() -> String? {
        return link.getMarkdownLink()
    }

    func getReferenceWithMarkdownLink() -> String? {
        return text + "\n" + (getMarkdownLink() ?? "") 
    }
}
