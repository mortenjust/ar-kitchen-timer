//
//  TimerCollectionViewCell.swift
//  timer
//
//  Created by Morten Just Petersen on 7/12/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit

class TimerCollectionViewCell: UICollectionViewCell {


    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerImage: UIImageView!
    var userTimer : UserTimer!
//    var timer : Timer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareCell(){
        timerImage.layer.cornerRadius = 10
        timerImage.clipsToBounds = true
        timerLabel.alpha = 1.0

//        timer =
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timerObj) in
//                self.timerLabel.text = self.userTimer.formattedSeconds()
//                if self.timerLabel.alpha == 0.0 {
//                    UIView.animate(withDuration: 0.4) {
//                        self.timerLabel.alpha = 1
//                    }
//                }
//        }
    }
    
    override func prepareForReuse() {
        timerLabel.text = ""        
//        timer.invalidate()
    }
    
}
