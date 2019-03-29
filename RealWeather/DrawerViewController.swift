//
//  DrawerViewController.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    fileprivate var previousTouchLocation: CGFloat?
}

extension DrawerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        previousTouchLocation = firstTouch.location(in: view).x
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        let touchLocation: CGPoint = firstTouch.location(in: view)
        
        if let previousTouchLocation = previousTouchLocation {
            let moveOffset: CGFloat = touchLocation.x - previousTouchLocation
            (parent as? RootViewController)?.moveDrawer(offset: moveOffset)
        } else {
            previousTouchLocation = touchLocation.x
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
        (parent as? RootViewController)?.finishDraggingDrawer()
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
        (parent as? RootViewController)?.finishDraggingDrawer()
        super.touchesCancelled(touches, with: event)
    }
}
