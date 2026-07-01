package org.koreaislam.mobile

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.widget.RemoteViews
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/**
 * Renders the prayer-times home-screen widget. All data (localized labels,
 * location, two days of times) is produced by the Flutter side and stored in
 * the `home_widget` SharedPreferences; this provider only reads + draws.
 *
 * The widget self-schedules an exact alarm at the next prayer boundary (and at
 * local midnight) so the active-prayer highlight flips on time without the app
 * running.
 */
class PrayerWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val PREFS = "HomeWidgetPreferences"
        private const val PAYLOAD_KEY = "prayer_widget_payload"
        private const val ACTION_TICK = "org.koreaislam.mobile.PRAYER_WIDGET_TICK"
        private const val MEDIUM_MIN_HEIGHT_DP = 128

        // Column order shared with the Flutter payload.
        private val KEYS = arrayOf("fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha")
        private val ICONS = intArrayOf(
            R.drawable.prayer_ic_fajr,
            R.drawable.prayer_ic_sunrise,
            R.drawable.prayer_ic_dhuhr,
            R.drawable.prayer_ic_asr,
            R.drawable.prayer_ic_maghrib,
            R.drawable.prayer_ic_isha,
        )
        private val CELL_IDS = intArrayOf(
            R.id.cell_0, R.id.cell_1, R.id.cell_2, R.id.cell_3, R.id.cell_4, R.id.cell_5,
        )
        private val NAME_IDS = intArrayOf(
            R.id.name_0, R.id.name_1, R.id.name_2, R.id.name_3, R.id.name_4, R.id.name_5,
        )
        private val TIME_IDS = intArrayOf(
            R.id.time_0, R.id.time_1, R.id.time_2, R.id.time_3, R.id.time_4, R.id.time_5,
        )
        private val ICON_IDS = intArrayOf(
            R.id.icon_0, R.id.icon_1, R.id.icon_2, R.id.icon_3, R.id.icon_4, R.id.icon_5,
        )
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            renderWidget(context, appWidgetManager, id)
        }
        scheduleNextUpdate(context)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        renderWidget(context, appWidgetManager, appWidgetId)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_TICK) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                android.content.ComponentName(context, PrayerWidgetProvider::class.java),
            )
            for (id in ids) {
                renderWidget(context, manager, id)
            }
            scheduleNextUpdate(context)
        }
    }

    private fun renderWidget(context: Context, manager: AppWidgetManager, widgetId: Int) {
        val options = manager.getAppWidgetOptions(widgetId)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
        val isMedium = minHeight >= MEDIUM_MIN_HEIGHT_DP

        val payload = readPayload(context)
        val day = payload?.let { selectToday(it) }

        val views: RemoteViews = if (payload == null || day == null) {
            RemoteViews(context.packageName, R.layout.prayer_widget_empty).apply {
                setTextViewText(
                    R.id.empty_message,
                    payload?.optJSONObject("labels")?.optString("noLocation").orEmptyText(),
                )
            }
        } else {
            buildContentViews(context, payload, day, isMedium)
        }

        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context))
        manager.updateAppWidget(widgetId, views)
    }

    private fun buildContentViews(
        context: Context,
        payload: JSONObject,
        day: JSONObject,
        isMedium: Boolean,
    ): RemoteViews {
        val layout = if (isMedium) R.layout.prayer_widget_medium else R.layout.prayer_widget_compact
        val views = RemoteViews(context.packageName, layout)

        val labels = payload.optJSONObject("labels") ?: JSONObject()
        val location = payload.optString("locationLabel", "").takeIf { it.isNotEmpty() && it != "null" }

        if (isMedium) {
            views.setTextViewText(R.id.widget_title, labels.optString("title"))
        }
        views.setTextViewText(R.id.widget_location, location ?: "")

        val now = System.currentTimeMillis()
        val times = LongArray(6) { day.optLong(KEYS[it]) }
        val activeIndex = activePrayerIndex(times, now)

        val inkColor = context.getColor(R.color.widget_ink)
        val mutedColor = context.getColor(R.color.widget_muted)
        val iconColor = context.getColor(R.color.widget_icon)
        val activeTextColor = context.getColor(R.color.widget_active_text)
        val formatter = SimpleDateFormat("HH:mm", Locale.getDefault())

        for (i in 0 until 6) {
            val active = i == activeIndex
            views.setTextViewText(NAME_IDS[i], labels.optString(KEYS[i]))
            views.setTextViewText(TIME_IDS[i], formatter.format(Date(times[i])))

            views.setInt(
                CELL_IDS[i],
                "setBackgroundResource",
                if (active) R.drawable.prayer_widget_pill else 0,
            )
            views.setTextColor(NAME_IDS[i], if (active) activeTextColor else mutedColor)
            views.setTextColor(TIME_IDS[i], if (active) activeTextColor else inkColor)

            if (isMedium) {
                views.setImageViewResource(ICON_IDS[i], ICONS[i])
                views.setInt(
                    ICON_IDS[i],
                    "setColorFilter",
                    if (active) activeTextColor else iconColor,
                )
            }
        }

        return views
    }

    private fun readPayload(context: Context): JSONObject? {
        val raw = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(PAYLOAD_KEY, null) ?: return null
        return try {
            JSONObject(raw)
        } catch (e: Exception) {
            null
        }
    }

    /** Pick the payload day whose date matches today, else the first day. */
    private fun selectToday(payload: JSONObject): JSONObject? {
        val days = payload.optJSONArray("days") ?: return null
        if (days.length() == 0) return null
        val todayStr = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        for (i in 0 until days.length()) {
            val day = days.optJSONObject(i) ?: continue
            if (day.optString("date") == todayStr) return day
        }
        return days.optJSONObject(0)
    }

    /** Index (0..5) of the current prayer period, or -1 before today's Fajr. */
    private fun activePrayerIndex(times: LongArray, now: Long): Int {
        var active = -1
        for (i in times.indices) {
            if (times[i] <= now) active = i else break
        }
        return active
    }

    private fun launchIntent(context: Context): PendingIntent {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: Intent()
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    /** Schedule an exact alarm at the next prayer boundary or local midnight. */
    private fun scheduleNextUpdate(context: Context) {
        val now = System.currentTimeMillis()
        val next = computeNextBoundary(context, now)

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pending = PendingIntent.getBroadcast(
            context,
            1,
            Intent(context, PrayerWidgetProvider::class.java).setAction(ACTION_TICK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, next, pending)
            } else {
                alarmManager.setExact(AlarmManager.RTC, next, pending)
            }
        } catch (e: SecurityException) {
            alarmManager.set(AlarmManager.RTC, next, pending)
        }
    }

    private fun computeNextBoundary(context: Context, now: Long): Long {
        val midnight = Calendar.getInstance().apply {
            timeInMillis = now
            add(Calendar.DAY_OF_YEAR, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 2)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis

        var next = midnight
        val payload = readPayload(context)
        val day = payload?.let { selectToday(it) }
        if (day != null) {
            for (key in KEYS) {
                val t = day.optLong(key)
                if (t in (now + 1) until next) next = t
            }
        }
        return next
    }

    private fun String?.orEmptyText(): String =
        if (this == null || this == "null") "" else this
}
