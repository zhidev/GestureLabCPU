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
    
    var newlyCreatedFace: UIImageView!

    
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
        
        /*let translation = panGestureRecognizer.translationInView(self.view)*/ //This was used in base version for the translation.y
        
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
    
    @IBAction func onSmilyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
    
        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(self.view)
        
        // Total translation (x,y) over time in parent view's coordinate system
        //let translation = panGestureRecognizer.translationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("BEGAN")
            // Gesture recognizers know the view they are attached to
            let imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            // Create gesture recognizer for the smily
            let tapGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomSmilyPanGesture:")
            
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            newlyCreatedFace.userInteractionEnabled = true
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("CHANGED")
            self.newlyCreatedFace.center = point
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("ENDED")
            
        }
    }
    
    func onCustomSmilyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(self.view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        //var translation = panGestureRecognizer.translationInView(view)
        //var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("CUSTOM PAN BEGAN")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("CUSTOM PAN CHANGED")
            self.newlyCreatedFace.center = point

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
        }
    }

    
}

