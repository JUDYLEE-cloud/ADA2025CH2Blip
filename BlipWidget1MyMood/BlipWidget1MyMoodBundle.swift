//
//  BlipWidget1MyMoodBundle.swift
//  BlipWidget1MyMood
//
//  Created by 이주현 on 4/13/25.
//

import WidgetKit
import SwiftUI

@main
struct BlipWidget1MyMoodBundle: WidgetBundle {
    var body: some Widget {
        BlipWidget1MyMood()
        BlipWidget1MyMoodControl()
        BlipWidget1MyMoodLiveActivity()
    }
}
