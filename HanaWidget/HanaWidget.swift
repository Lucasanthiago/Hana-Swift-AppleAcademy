//
//  HanaWidget.swift
//  HanaWidget
//
//  Created by Gabriela Azulay Lewin on 03/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), season: .spring, dayPeriod: .evening, text: "Testando")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), season: .spring, dayPeriod: .evening, text: "Testando")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, season: .spring, dayPeriod: .evening, text: "Testando")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

enum Season: String {
    case winter = "Winter"
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
}

enum DayPeriod: String {
    case morning = "Morning"
    case afteroon = "Afteroon"
    case evening = "Evening"
    case night = "Night"
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let season: Season
    let dayPeriod: DayPeriod
    let text: String
}

struct HanaWidgetEntryView: View {
    
    let entry: SimpleEntry
    
    var imageHana: String {
        "Hana\(entry.season.rawValue)\(entry.dayPeriod == .night ? "Sleeping" : "")"
    }
    
    var text: String { entry.text }
    
    var sky: String {
        "\(entry.dayPeriod.rawValue)Background"
    }
    
    var backgroundGradient: LinearGradient {
        switch entry.dayPeriod {
        case .morning:
            morningGradient
        case .afteroon:
            afternoonGradient
        case .evening:
            eveningGradient
        case .night:
            nightGradient
        }
    }
    
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
            backgroundGradient
        }
    }
    
    let morningGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .morningCloudsGradient1, location: 0),
            Gradient.Stop(color: .morningCloudsGradient2, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    let afternoonGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .afternoonSkyGradient1, location: 0),
            Gradient.Stop(color: .afternoonSkyGradient2, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    
    let eveningGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .eveningCloudsGradient1, location: 0),
            Gradient.Stop(color: .eveningCloudsGradient2, location: 0.5),
            Gradient.Stop(color: .eveningCloudsGradient3, location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    let nightGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .nightSkyGradient1, location: 0),
            Gradient.Stop(color: .nightSkyGradient2, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct HanaWidget: Widget {
    let kind: String = "HanaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HanaWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HanaWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    HanaWidget()
} timeline: {
    SimpleEntry(date: .now, season: .spring, dayPeriod: .evening, text: "Testando")
    SimpleEntry(date: .now, season: .winter, dayPeriod: .night, text: "Testando")
}
