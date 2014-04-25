#ifndef CAPTURER_H
#define CAPTURER_H

#include <QImage>
#include <QQuickPaintedItem>
#include <QString>

class QPainter;
class QQuickItem;

class saveAbleImage : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool smooth READ smooth WRITE setSmooth NOTIFY smoothChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)

public:
    saveAbleImage(QQuickItem *parent = 0);
    saveAbleImage(saveAbleImage const&);
    saveAbleImage& operator=(saveAbleImage const&);

    virtual void paint(QPainter *painter);

    //properties of READ
    int height() const;

    bool smooth() const;
    QString source() const;

    int width() const;
    //properties of READ

    //properties of WRITE
    void setHeight(int height);
    void setSource(QString const &source);
    void setSmooth(bool smooth);
    void setWidth(int width);
    //properties of WRITE

public slots:
    void save(QString const &path) const;

signals:
    void heightChanged();

    void smoothChanged();
    void sourceChanged();

    void widthChanged();

private:
    int height_;

    QImage image_;
    QImage imageBuffer_;

    bool smooth_;
    QString source_;

    int width_;
};

#endif // CAPTURER_H
