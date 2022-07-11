#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "player.h"
#include <QQmlContext>
#include "playlistmodel.h"
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QMetaType>
#include "translator.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");
    qRegisterMetaType<QMediaPlaylist::PlaybackMode>("QMediaPlaylist::PlaybackMode");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Translator translator;
    translator.setCurrentLanguage("us");
    if(translator.currentLanguage() != NULL)
        engine.rootContext()->setContextProperty("Translator", &translator);



    Player player;
    engine.rootContext()->setContextProperty("APP_CTRL", &player);

    if(player.getPlayer() != NULL)
        engine.rootContext()->setContextProperty("player", player.getPlayer());
    else
        qDebug() << "Qmediaplayer is NULL";

    if( player.getPlaylistModel() != NULL)
        engine.rootContext()->setContextProperty("playlistModel", player.getPlaylistModel());
    else
        qDebug() << "playlistmodel is NULL";

    if(player.getPlaylist() != NULL)
        engine.rootContext()->setContextProperty("PlayList", player.getPlaylist());
    else
         qDebug() << "QmediaPlaylist is NULL";

    engine.rootContext()->setContextProperty("utility", &player);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
