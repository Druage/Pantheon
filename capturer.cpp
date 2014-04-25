#include "capturer.h"

#include <QPainter>
#include <QQuickItem>

saveAbleImage::saveAbleImage(QQuickItem *parent) : QQuickPaintedItem(parent),
    height_(0),
    smooth_(false),
    width_(0)
{

}

void saveAbleImage::paint(QPainter *painter)
{
    qDebug() <<"paint : " <<width_ <<", "<<height_;
    if(height_ != 0 && width_ != 0){
        qDebug() <<"scale paint : " << width_<<", "<<height_;
        if(smooth_){
            imageBuffer_ = image_.scaled(QSize(width_, height_), Qt::KeepAspectRatio, Qt::SmoothTransformation);
            qDebug() <<"scale size : " <<image_.width() <<", "<<image_.height();
        }else{
            imageBuffer_ = image_.scaled(QSize(width_, height_), Qt::KeepAspectRatio, Qt::FastTransformation);
            qDebug() <<"scale size : " <<image_.width() <<", "<<image_.height();
        }
        painter->drawImage((width_ - imageBuffer_.width()) / 2, (height_ - imageBuffer_.height()) / 2, imageBuffer_);
    }else{
        painter->drawImage(0, 0, image_);
    }
}

int saveAbleImage::height() const
{
    return height_;
}

void saveAbleImage::save(QString const &path) const
{
    qDebug()<< "save image";
    if(!imageBuffer_.isNull()){
        qDebug()<<"save image : "<<imageBuffer_.save(path);
    }else{
        qDebug()<<"save image : "<<image_.save(path);
    }
}

bool saveAbleImage::smooth() const
{
    return smooth_;
}

QString saveAbleImage::source() const
{
    return source_;
}

int saveAbleImage::width() const
{
    return width_;
}

void saveAbleImage::setHeight(int height) {
    qDebug() << "height : "<< height;
    if(height_ != height){
        height_ = height;

        emit heightChanged();
    }
}

void saveAbleImage::setSource(QString const &source)
{
    qDebug() << "source = "<<source;
    if(source_ != source){
        source_ = source;

        image_.load(source_);
        update();

        emit sourceChanged();
    }
}

void saveAbleImage::setSmooth(bool smooth)
{
    if(smooth_ != smooth){
        smooth_ = smooth;

        emit smoothChanged();
    }
}

void saveAbleImage::setWidth(int width)
{
    qDebug() <<"width : "<< width;
    if(width_ != width){
        width_ = width;

        emit widthChanged();
    }
}
