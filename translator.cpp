#include "translator.h"
#include <QDebug>

Translator::Translator(QObject *parent)
    : QObject(parent)
{
    translator1.load(":/translate_us.qm");
    m_app->installTranslator(&translator1);
}

QString Translator::getEmptyString()
{
    return "";
}

QString Translator::currentLanguage()
{
    return m_currentLanguage;
}

void Translator::setCurrentLanguage(QString language)
{
    m_currentLanguage = language;
}

// cài đặt ngôn ngữ
void Translator::selectLanguage(QString language)
{
    setCurrentLanguage(language);
    qDebug() << language;
    // ngôn ngữ tiếng việt
    if(language == "vn"){        
        translator2.load(":/translate_vn.qm");
    }
    // ngôn ngữ tiếng anh
    else{        
        translator2.load(":/translate_us.qm");
    }
    m_app->installTranslator(&translator2);
    emit languageChanged();
}
