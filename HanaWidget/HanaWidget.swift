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
        
        SimpleEntry(date: Date(), season: .spring, dayPeriod: .afternoon, text: "Have you checked your plants today?")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), season: .spring, dayPeriod: .afternoon, text: "Have you checked your plants today?")
        completion(entry)
    }
    
    let seasons = [
        (
            name: Season.summer,
            start: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 21))!,
            end:   Calendar.current.date(from: DateComponents(year: 2024, month: 3,  day: 20))!
        ),
        (
            name: Season.spring,
            start: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 22))!,
            end:   Calendar.current.date(from: DateComponents(year: 2024, month: 12,  day: 20))!
        ),
        (
            name: Season.autumn,
            start: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 21))!,
            end:   Calendar.current.date(from: DateComponents(year: 2024, month: 6,  day: 21))!
        ),
        (
            name: Season.winter,
            start: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 22))!,
            end:   Calendar.current.date(from: DateComponents(year: 2024, month: 9,  day: 21))!
        )
    ]
    let relevantHours: [(dayPeriod: DayPeriod, hour: Int)] = [
        (.morning, 5), 
        (.afternoon, 11),
        (.evening, 17),
        (.night, 19)
    ]

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let today = Calendar.current.startOfDay(for: .now)
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else { return }
        
        var currentSeason: Season = .spring
        for season in seasons {
            if season.start < .now && season.end > .now {
                currentSeason = season.name
            }
        }
        
        var entries: [SimpleEntry] = []
        for day in [today, tomorrow] {
            for relevantHour in relevantHours {
                guard let newRelevantDate = Calendar.current.date(bySettingHour: relevantHour.hour, minute: 0, second: 0, of: day) else {
                    continue
                }
                let newEntry = SimpleEntry(
                    date: newRelevantDate,
                    season: currentSeason,
                    dayPeriod: relevantHour.dayPeriod,
                    text: "Have you checked your plants today?"
                )
                entries.append(newEntry)
            }
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
    case afternoon = "Afternoon"
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
    
    var text: String {
        switch entry.dayPeriod {
        case .morning:
            "Time to water your plants!"
        case .afternoon:
            "Watered your plants already?"
        case .evening:
            "Have you checked your plants today?"
        case .night:
            "See you again tomorrow!"
        }
    }
    
    var sky: String {
        "\(entry.dayPeriod.rawValue)Background"
    }
    
    var backgroundGradient: LinearGradient {
        switch entry.dayPeriod {
        case .morning:
            morningGradient
        case .afternoon:
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
            
            Spacer(minLength: 4)
            
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
        .configurationDisplayName("Hana")
        .description("Hana will remind you to take care of your plants.")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

//#Preview(as: .systemMedium) {
//    HanaWidget()
//} timeline: {
//    SimpleEntry(date: .now, season: .spring, dayPeriod: .evening, text: "Have you checked your plants today?")
//    SimpleEntry(date: .now, season: .winter, dayPeriod: .night, text: "Have you checked your plants today?")
//    SimpleEntry(date: .now, season: .summer, dayPeriod: .morning, text: "Have you checked your plants today?")
//    SimpleEntry(date: .now, season: .autumn, dayPeriod: .afternoon, text: "Have you checked your plants today?")
//}
