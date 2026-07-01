import SwiftUI
import WidgetKit

private let prayerSymbols = [
    "sunrise",       // fajr
    "sunrise.fill",  // sunrise
    "sun.max.fill",  // dhuhr
    "sun.min.fill",  // asr
    "sunset.fill",   // maghrib
    "moon.stars.fill" // isha
]

extension Color {
    /// Deep green in light mode, softer green in dark mode — mirrors the
    /// app's Noor primary token.
    static let prayerAccent = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.29, green: 0.61, blue: 0.43, alpha: 1)
            : UIColor(red: 0.06, green: 0.32, blue: 0.20, alpha: 1)
    })
}

private func hm(_ date: Date) -> String {
    let f = DateFormatter()
    f.dateFormat = "HH:mm"
    return f.string(from: date)
}

struct PrayerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PrayerEntry

    var body: some View {
        Group {
            if !entry.hasData {
                EmptyStateView(message: entry.noLocationText)
            } else if family == .systemSmall {
                SmallView(entry: entry)
            } else {
                MediumView(entry: entry)
            }
        }
        .widgetBackground(Color(.systemBackground))
    }
}

private struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            Spacer()
        }
    }
}

private struct SmallView: View {
    let entry: PrayerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.prayerAccent)
                if let location = entry.location {
                    Text(location)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
            }
            Spacer()
            Text((entry.nextName ?? "").uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.prayerAccent)
            if let nextDate = entry.nextDate {
                Text(hm(nextDate))
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.primary)
                Text(nextDate, style: .relative)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
    }
}

private struct MediumView: View {
    let entry: PrayerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(entry.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            if let location = entry.location {
                Text(location)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 10)
            HStack(spacing: 0) {
                ForEach(0..<entry.names.count, id: \.self) { i in
                    PrayerCell(
                        symbol: prayerSymbols[i],
                        name: entry.names[i],
                        time: hm(entry.times[i]),
                        active: i == entry.activeIndex
                    )
                }
            }
        }
        .padding(16)
    }
}

private struct PrayerCell: View {
    let symbol: String
    let name: String
    let time: String
    let active: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .font(.system(size: 17))
                .foregroundColor(active ? .white : .prayerAccent)
            Text(name)
                .font(.system(size: 11))
                .foregroundColor(active ? .white : .secondary)
                .lineLimit(1)
            Text(time)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(active ? .white : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(active ? Color.prayerAccent : Color.clear)
        )
    }
}

extension View {
    /// iOS 17 requires an explicit widget container background; earlier
    /// versions just fill the content area.
    @ViewBuilder
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(color, for: .widget)
        } else {
            background(color)
        }
    }
}
