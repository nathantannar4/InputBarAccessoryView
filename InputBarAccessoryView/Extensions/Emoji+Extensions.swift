//
//  Emoji+Extensions.swift
//  InputBarAccessoryView
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 10/7/17.
//  This file is based on Ranks/emoji-alpha-codes (https://github.com/Ranks/emoji-alpha-codes/blob/master/eac.json
//

import Foundation

extension String {
    
    public static var EmojiDictionary = Emojis {
        didSet {
            emojiUnescapeRegExp = createEmojiUnescapeRegExp()
            emojiEscapeRegExp = createEmojiEscapeRegExp()
        }
    }
    
    public static var EmojiKeys: [String] {
        return Array(EmojiDictionary.keys)
    }
    
    fileprivate static var emojiUnescapeRegExp = createEmojiUnescapeRegExp()
    fileprivate static var emojiEscapeRegExp = createEmojiEscapeRegExp()
    
    fileprivate static func createEmojiUnescapeRegExp() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: EmojiDictionary.keys.map { ":\($0):" } .joined(separator: "|"), options: [])
    }
    
    fileprivate static func createEmojiEscapeRegExp() -> NSRegularExpression {
        let v = EmojiDictionary.values.sorted().reversed()
        return try! NSRegularExpression(pattern: v.joined(separator: "|"), options: [])
    }
    
    public var EmojiRenderedString: String {
        var s = self as NSString
        let ms = String.emojiUnescapeRegExp.matches(in: self, options: [], range: NSMakeRange(0, s.length))
        ms.reversed().forEach { m in
            let r = m.range
            let p = s.substring(with: r)
            let px = String(p[p.characters.index(after: p.startIndex) ..< p.characters.index(before: p.endIndex)])
            if let t = String.EmojiDictionary[px] {
                s = s.replacingCharacters(in: r, with: t) as NSString
            }
        }
        return s as String
    }
    
    public var EmojiHashString: String {
        var s = self as NSString
        let ms = String.emojiEscapeRegExp.matches(in: self, options: [], range: NSMakeRange(0, s.length))
        ms.reversed().forEach { m in
            let r = m.range
            let p = s.substring(with: r)
            let fs = String.EmojiDictionary.lazy.filter { $0.1 == p }
            if let kv = fs.first {
                s = s.replacingCharacters(in: r, with: ":\(kv.0):") as NSString
            }
        }
        return s as String
    }
}
