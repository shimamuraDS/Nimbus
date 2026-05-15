import QtQuick

QtObject {
    // ── Color palette (dark glassmorphism) ──
    property color windowGradientTop: "#1e1e2e"
    property color windowGradientBottom: "#11111b"
    property color cardBg: "#12ffffff"
    property color cardBgHover: "#20ffffff"
    property color cardBorder: "#18ffffff"
    property color accent: "#89b4fa"
    property color accentWarm: "#fab387"
    property color primaryText: "#cdd6f4"
    property color secondaryText: "#a6adc8"
    property color mutedText: "#6c7086"
    property color dangerBg: "#38f38ba8"
    property color dangerText: "#f38ba8"
    property color divider: "#20ffffff"

    // ── Spacing ──
    property int spacingTiny: 4
    property int spacingSmall: 8
    property int spacingMedium: 14
    property int spacingLarge: 22

    // ── Radii ──
    property int radiusSmall: 6
    property int radiusMedium: 10
    property int radiusLarge: 16

    // ── Fonts ──
    property font titleFont: Qt.font({ family: "Microsoft YaHei", pointSize: 18, weight: Font.Bold })
    property font subtitleFont: Qt.font({ family: "Microsoft YaHei", pointSize: 14, weight: Font.DemiBold })
    property font bodyFont: Qt.font({ family: "Microsoft YaHei", pointSize: 12, weight: Font.Normal })
    property font captionFont: Qt.font({ family: "Microsoft YaHei", pointSize: 11, weight: Font.Normal })
}
