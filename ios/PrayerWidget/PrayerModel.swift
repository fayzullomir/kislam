import Foundation

let appGroupId = "group.org.koreaislam.mobile"
let payloadKey = "prayer_widget_payload"

// Column order shared with the Flutter payload.
let prayerKeys = ["fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"]

struct PrayerPayload: Decodable {
    let language: String?
    let locationLabel: String?
    let generatedAt: Double?
    let labels: [String: String]
    let days: [PrayerDay]

    static func load() -> PrayerPayload? {
        guard
            let defaults = UserDefaults(suiteName: appGroupId),
            let raw = defaults.string(forKey: payloadKey),
            let data = raw.data(using: .utf8)
        else { return nil }
        return try? JSONDecoder().decode(PrayerPayload.self, from: data)
    }

    /// The day whose date matches `date` (device-local), else the first day.
    func day(for date: Date) -> PrayerDay? {
        guard !days.isEmpty else { return nil }
        let key = PrayerPayload.dateString(date)
        return days.first { $0.date == key } ?? days.first
    }

    /// All six times of every day as sorted `Date`s — used to build the
    /// WidgetKit timeline boundaries.
    func boundaries() -> [Date] {
        days.flatMap { $0.times() }.sorted()
    }

    /// First obligatory prayer strictly after `date`, crossing into the next
    /// day when today's Isha has passed. Sunrise is skipped — it is shown as a
    /// column but is not a prayer you perform.
    func nextPrayer(after date: Date) -> (name: String, date: Date)? {
        for day in days {
            for key in prayerKeys where key != "sunrise" {
                let t = day.time(key)
                if t > date {
                    return (labels[key] ?? key, t)
                }
            }
        }
        return nil
    }

    static func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}

struct PrayerDay: Decodable {
    let date: String
    let fajr: Double
    let sunrise: Double
    let dhuhr: Double
    let asr: Double
    let maghrib: Double
    let isha: Double

    func time(_ key: String) -> Date {
        let ms: Double
        switch key {
        case "fajr": ms = fajr
        case "sunrise": ms = sunrise
        case "dhuhr": ms = dhuhr
        case "asr": ms = asr
        case "maghrib": ms = maghrib
        default: ms = isha
        }
        return Date(timeIntervalSince1970: ms / 1000.0)
    }

    func times() -> [Date] {
        prayerKeys.map { time($0) }
    }

    /// Index (0..5) of the current prayer period at `date`, or -1 before Fajr.
    func activeIndex(at date: Date) -> Int {
        var active = -1
        for (i, key) in prayerKeys.enumerated() {
            if time(key) <= date { active = i } else { break }
        }
        return active
    }
}
