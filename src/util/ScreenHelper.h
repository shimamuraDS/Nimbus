#pragma once

#include <QObject>
#include <QRect>

class QScreen;
class QTimer;

namespace Util {

class ScreenHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x      READ x      NOTIFY geometryChanged)
    Q_PROPERTY(int y      READ y      NOTIFY geometryChanged)
    Q_PROPERTY(int width  READ width  NOTIFY geometryChanged)
    Q_PROPERTY(int height READ height NOTIFY geometryChanged)

public:
    explicit ScreenHelper(QObject* parent = nullptr);

    int x()      const { return m_rect.x(); }
    int y()      const { return m_rect.y(); }
    int width()  const { return m_rect.width(); }
    int height() const { return m_rect.height(); }

signals:
    void geometryChanged();

private slots:
    void recalculate();

private:
    QRect calcEffectiveGeometry() const;
    QRect m_rect;
    QTimer* m_timer;
};

} // namespace Util
