import QtQuick

QtObject {
    // ── Color palette (dark glassmorphism) ──
    property color windowGradientTop: "#111124"
    property color windowGradientBottom: "#06060c"
    
    // Glass card backgrounds (frosted glass)
    property color cardBg: "#0affffff"
    property color cardBgHover: "#18ffffff"
    property color cardBorder: "#12ffffff"
    property color cardBorderHover: "#28ffffff"
    
    // Accents
    property color accent: "#00f0ff"        // Electric Cyan
    property color accentWarm: "#ff7b90"    // Sunset Coral
    property color accentSecondary: "#a78bfa" // Pastel Purple
    
    // Glowing borders
    property color glowCyan: "#3000f0ff"
    property color glowCoral: "#30ff7b90"
    
    // Typography colors
    property color primaryText: "#f8fafc"
    property color secondaryText: "#cbd5e1"
    property color mutedText: "#64748b"
    
    // System statuses
    property color dangerBg: "#25f87171"
    property color dangerText: "#f87171"
    property color successBg: "#254ade80"
    property color successText: "#4ade80"
    
    property color divider: "#10ffffff"

    // ── Spacing ──
    property int spacingTiny: 5
    property int spacingSmall: 10
    property int spacingMedium: 16
    property int spacingLarge: 24

    // ── Radii (Modern, softer corners) ──
    property int radiusSmall: 8
    property int radiusMedium: 14
    property int radiusLarge: 20

    // ── Fonts (Microsoft YaHei optimized for readability) ──
    property string defaultFamily: "Microsoft YaHei"
    property font titleFont: Qt.font({ family: defaultFamily, pointSize: 18, weight: Font.Bold })
    property font subtitleFont: Qt.font({ family: defaultFamily, pointSize: 13, weight: Font.DemiBold })
    property font bodyFont: Qt.font({ family: defaultFamily, pointSize: 11, weight: Font.Normal })
    property font captionFont: Qt.font({ family: defaultFamily, pointSize: 10, weight: Font.Normal })
}

