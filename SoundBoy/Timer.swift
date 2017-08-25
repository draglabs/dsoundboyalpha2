

import Foundation
import UIKit

//  SoundBoy
//
//  Created by Marlon Monroy on 6/29/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//
public enum countDirection {
    case up;
    case down;
}


public class TimeCounter: NSObject {
    
    private var countTimer = Timer();
    private var totalSeconds = 0;
    private var startStop = true;
    private var cDirection: countDirection!;
    private var labelString = String();
    private var lastTime: (Int, Int)?;
    
    public var minutes = 0;
    public var seconds = 0;
    public var timeLabel = UILabel();
    var counting:((_ currenTime:String)->())?
    

    public init(direction: countDirection) {
        self.cDirection = direction;
    }
    
    
    
    /**
     Starts the timer in the direction it was initialized with.
     */
    public func startTimeCounter() {
        // If it is ok to start the timer...
        if startStop == true {
            
            // If the timer is supposed to count up. Otherwise count down.
            if cDirection == .up {
                countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actuallyCountUp), userInfo: nil, repeats: true);
            } else {
                countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actuallyCountDown), userInfo: nil, repeats: true)
                lastTime = (minutes, seconds);
            }
            
            startStop = false;
        }
    }
    
    
    /**
     Pauses the time counter.
     */
    public func stopTimeCounter() {
        if startStop == false {
            countTimer.invalidate();
            startStop = true;
        }
    }
    
    
    /**
     Resets the time counter. If it was counting up, it will be reset to 0. If it was counting down, it will be reset to the last value of minutes and seconds that were set.
     */
    public func reset() {
        if cDirection == .up {
            startStop = true;
            countTimer.invalidate();
            minutes = 0;
            seconds = 0;
            totalSeconds = 0;
            
            timeLabel.text = "\(minutes):\(seconds)";
        } else {
            startStop = true;
            countTimer.invalidate();
            
            if let min = lastTime?.0 {
                if let sec = lastTime?.1 {
                    timeLabel.text = "\(min):\(sec)";
                }
            }
        }
    }
    
    
    /**
        - Return the total number of seconds that have passed since the timer started.
     */
    public func getTotalSeconds() -> Int {
        return totalSeconds;
    }
    
    
    @objc private func actuallyCountUp() {
        if countTimer.isValid == true {
            seconds += 1;
            totalSeconds += 1;
            
            if seconds == 60 {
                minutes += 1;
                seconds = 0;
            }
            
            if minutes == 0 && seconds == 0 {
                labelString = "00:00";
            }
            if seconds > 9 && minutes >= 9  {
                labelString = "\(minutes):\(seconds)";
            }
            if seconds <= 9 && minutes <= 9 {
                labelString = "0\(minutes):0\(seconds)";
            }
            if seconds <= 9 && minutes >= 9 {
                labelString = "\(minutes):0\(seconds)";
            }
            if seconds > 9 && minutes <= 9 {
                labelString = "0\(minutes):\(seconds)";
            }
            
            timeLabel.text = labelString;
            counting?(labelString)
        }
    }
    
    
    @objc private func actuallyCountDown() {
        if countTimer.isValid == true {
            seconds -= 1;
            totalSeconds += 1;
            
            if seconds < 0 {
                minutes -= 1;
                seconds = 59;
            }
            
            if minutes == 0 && seconds <= 0 {
                minutes = 0;
                seconds = 0;
                totalSeconds = 0;
                self.stopTimeCounter();
            }
            
            if minutes > 9 && seconds > 9  {
                labelString = "\(minutes):\(seconds)";
            }
            if minutes <= 9 && seconds <= 9 {
                labelString = "0\(minutes):0\(seconds)";
            }
            if minutes <= 9 && seconds > 9 {
                labelString = "0\(minutes):\(seconds)";
            }
            if minutes > 9 && seconds <= 9 {
                labelString = "\(minutes):0\(seconds)";
            }
            
            timeLabel.text = labelString;
            counting?(labelString)

        }
    }
    
    
}
