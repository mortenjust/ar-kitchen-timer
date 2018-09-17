//
//  PullUp.swift
//  timer
//
//  Created by Morten Just Petersen on 7/12/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit
import Pulley

class PullUp: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let MENU_RESTING : CGFloat = 100.0
    let MENU_MIDDLE : CGFloat = 300.0
    var MENU_FULL : CGFloat!
    let MENU_TOP_MARGIN : CGFloat = 80.0
    var main : ViewController!
    var showDebug = false
    
    @IBOutlet weak var timerCollection: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MENU_FULL = UIScreen.main.bounds.height - MENU_TOP_MARGIN
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 10.0
        
        timerCollection.delegate = self
        timerCollection.dataSource = self
        
        let layout = TimerCollectionViewLayout()
        layout.itemSize = CGSize(width: 100, height: 50)

        timerCollection.collectionViewLayout = layout
        
        // update all timers once per second (or minute?)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timerObj) in
            self.timerCollection.reloadData()
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timerStore.allTimers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = timerCollection.dequeueReusableCell(withReuseIdentifier: "timerCell", for: indexPath) as! TimerCollectionViewCell
        
        let timer = timerStore.allTimers[indexPath.item]
        
        if let image = timer.timerImage {
            cell.timerImage.image = image
            cell.userTimer = timer
            cell.timerLabel.text = timer.formattedSeconds()
            cell.prepareCell()
        }
        
//        cell.timerLabel.text = "\(timer.secondsPassed)"
        return cell
    }
}

extension PullUp : PulleyDrawerViewControllerDelegate {
    
     func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 120.0
    }

     func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 500.0
    }

     func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    

    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        if drawer.currentDisplayMode == .leftSide
        {
            drawer.panelWidth = 110.0
            
        } else {
            
        }
    }
    
}

