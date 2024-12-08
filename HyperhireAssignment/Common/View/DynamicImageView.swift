//
//  DynamicImageView.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 09/12/24.
//

import UIKit
import Kingfisher

class DynamicImageView: UIView {

    // Array of image URLs to display
    var imageURLs: [URL] = [] {
        didSet {
            configureViews()
        }
    }
    
    private func configureViews() {
        // Remove all subviews to start fresh
        subviews.forEach { $0.removeFromSuperview() }
        
        switch imageURLs.count {
        case 1:
            // Single image: Fullscreen
            let imageView = createImageView(with: imageURLs[0])
            imageView.frame = bounds
            addSubview(imageView)
        case 2:
            // Two images: Left and right halves
            for i in 0..<2 {
                let imageView = createImageView(with: imageURLs[i])
                let width = bounds.width / 2
                let frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: bounds.height)
                imageView.frame = frame
                addSubview(imageView)
            }
        case 3:
            // Three images: Top-left, bottom-left, and right half
            let topLeft = createImageView(with: imageURLs[0])
            topLeft.frame = CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height / 2)
            addSubview(topLeft)
            
            let bottomLeft = createImageView(with: imageURLs[1])
            bottomLeft.frame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width / 2, height: bounds.height / 2)
            addSubview(bottomLeft)
            
            let right = createImageView(with: imageURLs[2])
            right.frame = CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height)
            addSubview(right)
        case 4:
            // Four images: Quadrants
            for i in 0..<4 {
                let imageView = createImageView(with: imageURLs[i])
                let width = bounds.width / 2
                let height = bounds.height / 2
                let x = CGFloat(i % 2) * width
                let y = CGFloat(i / 2) * height
                let frame = CGRect(x: x, y: y, width: width, height: height)
                imageView.frame = frame
                addSubview(imageView)
            }
        default:
            // Handle other cases (e.g., no images or more than 4)
            print("Unsupported number of images")
        }
    }
    
    private func createImageView(with url: URL) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // Load image using Kingfisher
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage])
        return imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
}
