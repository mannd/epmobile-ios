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

    @objc init(text: String, link: String) {
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.link = link.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Create a Reference using an AMA style reference
    /// - Parameter citation: String in AMA style citation format.  If there is no valid link, link is empty and text contains original string.
    @objc init(_ citation: String) {
        let textPlusLink = Self.parseCitation(citation: citation)
        self.text = textPlusLink.text
        self.link = textPlusLink.link
    }

    /// Factory method to create references from full citation, as alternative to init
    /// - Parameter citation: citation in AMA format, with DOI or URI
    /// - Returns: Reference object
    @objc static func referenceFromCitation(_ citation: String) -> Reference {
        return Reference(citation)
    }

    /// Parse an AMA style reference into text and link components.
    /// - Parameter citation: AMA style reference string
    /// - Returns: tuple with text and link components, nil if string doesn't contain a link
    static func parseCitation(citation: String) -> (text: String, link: String) {
        let lowerCaseRef = citation.lowercased()
        var range: Range<String.Index>?
        if lowerCaseRef.contains("doi:") {
            range = lowerCaseRef.range(of: "doi:")
        } else if lowerCaseRef.contains("http") {
            range = lowerCaseRef.range(of: "http")
        }
        if let range {
            let text = String(citation[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let link = String(citation[range.lowerBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            return (text, link)
        } else { // No link attached.  That's ok, just leave the link empty.
            let text = citation
            let link = ""
            return (text, link)
        }
    }

    static func getReferenceList(from references: [Reference]) -> String {
        guard !references.isEmpty else { return "References: None" }
        var result = references.count == 1 ? "Reference" : "References" + ":\n"
        for reference in references {
            result += reference.getPlainTextReference() + "\n"
        }
        return result
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

    @objc
    func getPlainTextReference() -> String {
        return text + (link.isEmpty ? "" : "\n" + link)
    }
}
