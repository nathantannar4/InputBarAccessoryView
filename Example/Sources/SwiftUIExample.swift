//
//  SwiftUIExample.swift
//  Example
//
//  Created by Andrew Breckenridge on 10/3/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit
import SwiftUI
import InputBarAccessoryView

var built: CommonTableViewController?

struct CommonTableViewControllerUI: UIViewControllerRepresentable {
    let style: InputBarStyle
    let conversation: SampleData.Conversation

    var inputBar: InputBarAccessoryView {
        if built == nil {
            built = CommonTableViewController(style: style, conversation: conversation)
        }
        return built!.inputBar
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        if built == nil {
            built = CommonTableViewController(style: style, conversation: conversation)
        }
        return built!
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct InputBarUI: UIViewRepresentable {
    let view: InputBarAccessoryView

    func makeUIView(context: Context) -> some UIView {
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


public struct SwiftUIExample: View {
    let style: InputBarStyle
    let conversation: SampleData.Conversation

    var table: CommonTableViewControllerUI {
        CommonTableViewControllerUI(style: style, conversation: conversation)
    }


    public var body: some View {
        VStack {
            self.table
            InputBarUI(view: table.inputBar)
        }
    }

}

extension SwiftUIExample {
    static func make(style: InputBarStyle, conversation: SampleData.Conversation) -> Self {
        return Self.init(style: style, conversation: conversation)
    }
}
