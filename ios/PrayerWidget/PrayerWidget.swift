import SwiftUI
import WidgetKit

struct PrayerEntry: TimelineEntry {
    let date: Date
    let hasData: Bool
    let title: String
    let location: String?
    let noLocationText: String
    let names: [String]
    let times: [Date]
    let activeIndex: Int
    let nextName: String?
    let nextDate: Date?

    static func build(at date: Date, payload: PrayerPayload?) -> PrayerEntry {
        guard let payload = payload, let day = payload.day(for: date) else {
            return PrayerEntry(
                date: date,
                hasData: false,
                title: payload?.labels["title"] ?? "",
                location: nil,
                noLocationText: payload?.labels["noLocation"] ?? "",
                names: [],
                times: [],
                activeIndex: -1,
                nextName: nil,
                nextDate: nil
            )
        }
        let next = payload.nextPrayer(after: date)
        return PrayerEntry(
            date: date,
            hasData: true,
            title: payload.labels["title"] ?? "",
            location: payload.locationLabel,
            noLocationText: payload.labels["noLocation"] ?? "",
            names: prayerKeys.map { payload.labels[$0] ?? $0 },
            times: prayerKeys.map { day.time($0) },
            activeIndex: day.activeIndex(at: date),
            nextName: next?.name,
            nextDate: next?.date
        )
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry.build(at: Date(), payload: PrayerPayload.load())
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> Void) {
        completion(PrayerEntry.build(at: Date(), payload: PrayerPayload.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        let payload = PrayerPayload.load()
        let now = Date()

        var dates: [Date] = [now]
        if let payload = payload {
            dates += payload.boundaries().filter { $0 > now }
        }
        // De-dupe + cap, keep chronological order.
        let uniqueDates = Array(Set(dates)).sorted().prefix(24)
        let entries = uniqueDates.map { PrayerEntry.build(at: $0, payload: payload) }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

@main
struct PrayerWidget: Widget {
    let kind = "PrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerWidgetView(entry: entry)
        }
        .configurationDisplayName("Namoz vaqtlari")
        .description("Kunlik namoz vaqtlari")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
