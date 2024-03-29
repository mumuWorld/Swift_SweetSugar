//
//  WordWidget.swift
//  WordWidget
//
//  Created by 杨杰 on 2022/1/18.
//  Copyright © 2022 Mumu. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WordWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if #available(iOSApplicationExtension 16.0, *) {
    //            Text(entry.date, style: .time)
    //                .widgetAccentable()
                Text(entry.date, style: .time)
            } else {
                Text(entry.date, style: .time)
            }
        }.widgetBackground()
    }
}


@main
struct WordWidget: Widget {
    let kind: String = "WordWidget"

    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                WordWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
        } else {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                WordWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }
}

struct WordWidget_Previews: PreviewProvider {
    static var previews: some View {
        WordWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


extension View {
     func widgetBackground() -> some View {
         if #available(iOS 17.0, *) {
             return containerBackground(for: .widget) {
                 Color.clear
             }
         } else {
             return background {
                 Color.clear
             }
         }
    }
}
