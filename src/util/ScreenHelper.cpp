#include "ScreenHelper.h"
#include <QGuiApplication>
#include <QScreen>
#include <QTimer>

#ifdef Q_OS_WIN
#include <Windows.h>
#include <shellapi.h>
#endif

namespace Util {

ScreenHelper::ScreenHelper(QObject* parent)
    : QObject(parent)
    , m_timer(new QTimer(this))
{
    // Connect to screen geometry changes
    QScreen* screen = QGuiApplication::primaryScreen();
    if (screen) {
        connect(screen, &QScreen::availableGeometryChanged,
                this, &ScreenHelper::recalculate);
        connect(screen, &QScreen::geometryChanged,
                this, &ScreenHelper::recalculate);
    }
    connect(qApp, &QGuiApplication::primaryScreenChanged,
            this, [this](QScreen* newScreen) {
        if (newScreen) {
            connect(newScreen, &QScreen::availableGeometryChanged,
                    this, &ScreenHelper::recalculate);
            connect(newScreen, &QScreen::geometryChanged,
                    this, &ScreenHelper::recalculate);
        }
        recalculate();
    });

    // Periodically re-check for auto-hide taskbar state changes
    m_timer->setInterval(2000);
    connect(m_timer, &QTimer::timeout, this, &ScreenHelper::recalculate);
    m_timer->start();

    // Initial calculation
    recalculate();
}

void ScreenHelper::recalculate()
{
    QRect newRect = calcEffectiveGeometry();
    if (newRect != m_rect) {
        m_rect = newRect;
        emit geometryChanged();
    }
}

QRect ScreenHelper::calcEffectiveGeometry() const
{
    QScreen* screen = QGuiApplication::primaryScreen();
    if (!screen) return QRect(0, 0, 1920, 1080);

    QRect avail = screen->availableGeometry();

#ifdef Q_OS_WIN
    // Check if the taskbar is set to auto-hide
    APPBARDATA abd = {};
    abd.cbSize = sizeof(APPBARDATA);
    UINT state = (UINT)SHAppBarMessage(ABM_GETSTATE, &abd);

    if (state & ABS_AUTOHIDE) {
        // Get taskbar position and dimensions
        SHAppBarMessage(ABM_GETTASKBARPOS, &abd);
        int tbHeight = abd.rc.bottom - abd.rc.top;
        int tbWidth  = abd.rc.right  - abd.rc.left;

        switch (abd.uEdge) {
        case ABE_BOTTOM:
            avail.setHeight(avail.height() - tbHeight);
            break;
        case ABE_TOP:
            avail.setY(avail.y() + tbHeight);
            avail.setHeight(avail.height() - tbHeight);
            break;
        case ABE_LEFT:
            avail.setX(avail.x() + tbWidth);
            avail.setWidth(avail.width() - tbWidth);
            break;
        case ABE_RIGHT:
            avail.setWidth(avail.width() - tbWidth);
            break;
        }
    }
#endif

    return avail;
}

} // namespace Util
