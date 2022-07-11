#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString updateText READ getEmptyString NOTIFY languageChanged)

public:
    Translator(QObject *parent = nullptr);
    QString getEmptyString();
    QString currentLanguage();
    void setCurrentLanguage(QString language);
    Q_INVOKABLE void selectLanguage(QString language);

signals:
    void languageChanged();
    void currentLanguageChanged();

private:
    QTranslator translator1;
    QTranslator translator2;
    QGuiApplication *m_app;
    QString m_currentLanguage;
};

#endif // TRANSLATOR_H
