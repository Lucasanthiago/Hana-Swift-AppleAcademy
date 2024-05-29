//
//  HanaWidgetLiveActivity.swift
//  HanaWidget
//
//  Created by Gabriela Azulay Lewin on 29/05/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HanaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HanaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HanaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HanaWidgetAttributes {
    fileprivate static var preview: HanaWidgetAttributes {
        HanaWidgetAttributes(name: "World")
    }
}

extension HanaWidgetAttributes.ContentState {
    fileprivate static var smiley: HanaWidgetAttributes.ContentState {
        HanaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HanaWidgetAttributes.ContentState {
         HanaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HanaWidgetAttributes.preview) {
   HanaWidgetLiveActivity()
} contentStates: {
    HanaWidgetAttributes.ContentState.smiley
    HanaWidgetAttributes.ContentState.starEyes
}
