//
//  ViewController.swift
//  GestureLab
//
//  Created by Douglas on 3/10/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var downarrow: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGFloat!
    var trayCenterWhenClosed: CGFloat!
    var velocity: CGPoint?
    
    var trayStateTrueOpenFalseClose = true
    
    @IBOutlet var trayView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //trayCenterWhenOpen = trayView.center
        //trayCenterWhenClosed = trayView.center + trayView.center - downarrow.bounds
        trayCenterWhenOpen = trayView.center.y
        trayCenterWhenClosed = trayView.center.y + trayView.frame.size.height - downarrow.bounds.height - (downarrow.frame.minY)
        //16 is basically downarrow.frame.y x 2 . Hardcode for now
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(self.view)
        // Total translation (x,y) over time in parent view's coordinate system
        let translation = panGestureRecognizer.translationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //trayOriginalCenter = CGPoint(x: trayView.center.x, y: trayView.center.y)
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            //print("Gesture changed at: \(point)")
            //trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            velocity = panGestureRecognizer.velocityInView(trayView)
            print("Velocity: \(velocity)")
            let direction = Int(velocity!.y)
            if(direction > 0){ //if velocity.y is greater than 0 its pulling down
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: velocity!.y, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayView.center.x ,y: self.trayCenterWhenClosed)

                    }, completion: { (completed) -> Void in
                        print("Direction > 0 block completed \(completed)")
                        self.trayStateTrueOpenFalseClose = true
                })
                
                /*UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayView.center.x ,y: self.trayCenterWhenClosed)
                })*/
            }else{ //else direction < 0
                /*UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayView.center.x, y: self.trayCenterWhenOpen)
                })*/
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: velocity!.y, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayView.center.x ,y: self.trayCenterWhenOpen)
                    
                    }, completion: { (completed) -> Void in
                        print("Direction > 0 block completed \(completed)")
                        self.trayStateTrueOpenFalseClose = false
                })
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    
    @IBAction func onTapGesture(sender: UITapGestureRecognizer) {
        print("TAPPED")
        if(trayStateTrueOpenFalseClose){//if open we close
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.trayView.center = CGPoint(x: self.trayView.center.x, y: self.trayCenterWhenClosed)
            })
            trayStateTrueOpenFalseClose = false
        }else{//else closed we open
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.trayView.center = CGPoint(x: self.trayView.center.x ,y: self.trayCenterWhenOpen)
            })
            trayStateTrueOpenFalseClose = true
        }
    }
    
    
}

