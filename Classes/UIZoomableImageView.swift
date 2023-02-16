//
//  UIZoomableImageView.swift
//  TelegraphWebServer
//
//  Created by Oz Shabbat on 12/02/2023.
//

import Foundation
import UIKit
import OsTools

/**
 Just a simple view which can be pinched or zoomed.
 
 This is the follower hierarchy of this view:
 UIZoomableImageView -> ScrollView -> ImageContainerView -> ImageView
 */
public class UIZoomableImageView: UIView {
    
    // views
    public let scrollView = UIScrollView()
    public let imageView = UIImageView()        // -> The actual image view
    public let imageContainerView = UIView()
    
    // indications
    
    /** Toggle to allow/disallow double tap */
    var isDoubleTapEnabled = true
    
    /** Will decide how much zoom will be when double tapped */
    var doubleTapZoomFactor: CGFloat = 2.5
    
    public var minimumZoomScale: CGFloat = 0.1 {
        didSet {
            self.scrollView.minimumZoomScale = minimumZoomScale
        }
    }
    
    public var maximumZoomScale: CGFloat = 10.0 {
        didSet {
            self.scrollView.maximumZoomScale = maximumZoomScale
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.scrollView.delegate = self
        self.addSubview(scrollView)
        
        self.scrollView.addSubview(imageContainerView)
        self.imageContainerView.addSubview(imageView)
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        minimumZoomScale = 1.0
        self.maximumZoomScale = 10.0
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.imageContainerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.imageContainerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.imageContainerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.imageContainerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.imageContainerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.imageContainerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.imageContainerView.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.imageContainerView.rightAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !isDoubleTapEnabled {
            return
        }
        if scrollView.zoomScale != 1 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let pointInView = gesture.location(in: imageView)
            let scrollViewSize = scrollView.bounds.size
            let width = scrollViewSize.width / doubleTapZoomFactor
            let height = scrollViewSize.height / doubleTapZoomFactor
            let x = pointInView.x - width / 2
            let y = pointInView.y - height / 2
            let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
            scrollView.zoom(to: rectToZoom, animated: true)
        }
    }
}

extension UIZoomableImageView: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageContainerView
    }
}

