//
//  HanaWidget.swift
//  HanaWidget
//
//  Created by Gabriela Azulay Lewin on 29/05/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct HanaWidgetEntryView: View {
//    var entry: Provider.Entry
    
    let imageHana: String
    let text: String
    let sky: String
//    @State var gradientList = [morningGradient,afternoonGradient,eveningGradient,nightGradient]
//
    
    let morningGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .morningCloudsGradient1, location: 0),
                Gradient.Stop(color: .morningCloudsGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    let   afternoonGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .afternoonSkyGradient1, location: 0),
                Gradient.Stop(color: .afternoonSkyGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    
    let   eveningGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .eveningCloudsGradient1, location: 0),
                Gradient.Stop(color: .eveningCloudsGradient2, location: 0.5),
                Gradient.Stop(color: .eveningCloudsGradient3, location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    let   nightGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .nightSkyGradient1, location: 0),
                Gradient.Stop(color: .nightSkyGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    
    var body: some View {
        HStack {
            Text(text)
            
                .font(
                    .custom("Quicksand", size: 20, relativeTo: .title3).weight(.bold)
                )
                .foregroundStyle(.white)
            
            Spacer(minLength: 12)
            
            Image(imageHana)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Image(imageHana)
                        .rotationEffect(.degrees(180))
                        .alignmentGuide(.bottom, computeValue: { _ in 0 })
                        .mask {
                            LinearGradient(
                                colors: [.black.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .init(x: 0.5, y: 0.15)
                            )
                            
                        }
                        .accessibilityHidden(true)
                }
                .accessibilityLabel("Hana smiling with her spring colors")
        }
        .padding(16)
        .background {
            Image(sky)
                .resizable()
                .scaledToFill()
        }
        .background {
            eveningGradient
                }
       }
    }


struct HanaWidget: Widget {
    let kind: String = "HanaWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HanaWidgetEntryView(imageHana: "HanaSpring", text: "Have you checked your plants today?", sky: "EveningClouds")
                .containerBackground(.black, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    HanaWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
