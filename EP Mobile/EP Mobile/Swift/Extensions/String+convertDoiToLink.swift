//
//  String+convertDoiToLink.swift
//  EP Mobile
//
//  Created by David Mann on 10/8/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

extension String {
    // EP Mobile prefers DOI references to URIs, as most style guides recommend.
    // In a citation (AMA style guide) a DOI is presented as "doi:xxx.1234/xyz" .
    // A URI is preceded by "https://" (preferably) or "http://" .
    // Thus each reference in EP Mobile contains at the end a DOI or URI in the AMA style.
    // When it appears in EP Mobile, a URI appears unchanged as a clickable link.
    // A DOI appears in the AMA style, but it too is clickable, because behind the scenes
    // it is converted to a Markdown link, by substituting "doi:" with "https://doi.org/" .
    // Thus all reference links are stored in "doi:" or "http(s)://" format and manipulated
    // so that they perform correctly, using the functions in this extension.
    //
    // This would all be better using regexes, but that would require min version of iOS 16.
    // Maybe refactor after a few more iOS versions come out.


    ///  Checks to see if a string is a DOI citation.
    /// - Returns: true if the string has the DOI prefix.
    func isDoi() -> Bool {
        let s = lowercased()
        return s.hasPrefix("doi:") && s.count > 4
    }

    ///  Checks to see if a string is a URI citation.
    /// - Returns: true if the string has the URI prefix.
    func isHttp() -> Bool {
        let s = lowercased()
        return s.hasPrefix("http")
    }

    /// Converts a DOI citation to a UIR, returns URI citations unchanged.
    /// - Returns: URI style link, nil if string is not a URI or DOI citation.
    func convertDoiToUri() -> String? {
        if isHttp() {
            return self
        }
        if isDoi() {
            if let index = firstIndex(of: ":") {
                let nextIndex = self.index(after: index)
                let doiRoot = self[nextIndex...]
                return "https://doi.org/" + doiRoot
            }
        }
        return nil
    }

    /// Converts DOI citation to Markdown clickable link, returns URI unchanged.
    /// - Returns: Markdown style URI link, nil if not a URI or DOI citation
    func getMarkdownLink() -> String? {
        if isDoi(), let link = convertDoiToUri() {
            return "[" + self + "](" + link + ")"
        }
        if isHttp() {
            return self
        }
        return nil
    }
}
