//
//  AddPlaylistFloatingPanelLayout.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit
import FloatingPanel

class AddPlaylistFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 112, edge: .bottom, referenceGuide: .safeArea),
    ]
}
