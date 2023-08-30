//
//  AnalyticsService.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/30.
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    static let instance = AnalyticsService()
    
    
    func likePostDoubleTapped() {
        Analytics.logEvent("like_double_tap", parameters: nil)
    }
    
    func likePostHeartPressed() {
        Analytics.logEvent("like_heart_clicked", parameters: nil)
    }
    
}
