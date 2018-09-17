//
//  TimerCollectionViewLayout.swift
//  timer
//
//  Created by Morten Just Petersen on 7/13/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit

class TimerCollectionViewLayout: UICollectionViewFlowLayout {

    
    
    //appear and disappear at 0
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("initial layout called")
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
        attributes.alpha = 0
        attributes.transform.scaledBy(x: 0.1, y: 0.1)
        return attributes
    }
    

}
