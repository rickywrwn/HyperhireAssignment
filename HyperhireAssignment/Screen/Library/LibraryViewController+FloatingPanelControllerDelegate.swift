//
//  LibraryViewController+FloatingPanelControllerDelegate.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit
import FloatingPanel

extension LibraryViewController: FloatingPanelControllerDelegate{
    
    func setupFloatingPanel(){
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = AddPlaylistFloatingPanelLayout()
        
        let contentVC = AddPlaylistPanel()
        contentVC.delegate = self
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 12
        appearance.backgroundColor = .backgroundColor
        fpc.surfaceView.appearance = appearance
        fpc.surfaceView.grabberHandle.isHidden = true
        
        fpc.isRemovalInteractionEnabled = true
        fpc.set(contentViewController: contentVC)
    }
    
}
