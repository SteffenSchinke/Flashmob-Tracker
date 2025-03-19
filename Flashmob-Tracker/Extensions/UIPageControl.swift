//
//  UIPageControl.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 25.02.25.
//


import SwiftUI


extension UIPageControl {
    
    static func updateAppearance( _ colorScheme: ColorScheme) {
        
        DispatchQueue.main.async {
            
            let currentPageIndicatorColor: UIColor =
                    colorScheme == .dark ? .black : .white
            let pageIndicatorColor: UIColor =
                    colorScheme == .dark ? .gray : .lightGray
            
            // Hole die aktive Szene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                
                for window in windowScene.windows {
                    
                    for subview in window.subviews {
                        
                        if let pageControl = findPageControl(subview) {
                            
                            pageControl.currentPageIndicatorTintColor = currentPageIndicatorColor
                            pageControl.pageIndicatorTintColor = pageIndicatorColor
                            pageControl.setNeedsDisplay()
                        }
                    }
                }
            }
        }
    }
    
    private static func findPageControl( _ view: UIView) -> UIPageControl? {
        
        if let pageControl = view as? UIPageControl {
            
            return pageControl
        }
        for subview in view.subviews {
            
            if let found = findPageControl(subview) {
                
                return found
            }
        }
        return nil
    }
}

