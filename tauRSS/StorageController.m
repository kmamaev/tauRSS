#import "StorageController.h"


@implementation StorageController

- (void)storeSource:(Source *)source {
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)storeArticles:(NSArray *)articles forSourceWithId:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
}

- (NSArray *)getAllSources {
#warning resolve TODO mark
    // TODO: Implement get sources from database and remove hard code
    
    Source *s1 = [[Source alloc] init];
    s1.title = @"Лента RSS";
    Source *s2 = [[Source alloc] init];
    s2.title = @"НГС RSS";
    
    NSDateFormatter *dateFormetter = [[NSDateFormatter alloc] init];
    dateFormetter.dateFormat = @"ccc, dd MMM yyyy HH:mm:ss Z";
    
    Article *a1 = [[Article alloc] initWithTitle:@"Совет директоров «Башнефти» возглавил первый замглавы Минэнерго"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/bashneft/"]
                                     description:@"Совет директоров одной из крупнейших нефтекомпаний России «Башнефть» выбрал своим председателем первого заместителя министра энергетики РФ Алексея Текслера. Также акционеры «Башнефти» на состоявшемся ранее внеочередном собрании  утвердили новый состав совета директоров компании."
                                        category:@"Бизнес"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/20150311162956926/pic_eac0cee430fbcd74e6e4b12d5f3c3a9d.jpg"]
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:01:02 +0300"]];
    a1.isFavorite = YES;
    
    Article *a2 = [[Article alloc] initWithTitle:@"В России организуют прямую трансляцию полного солнечного затмения"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/sun/"]
                                     description:@"В России будет организована прямая трансляция солнечного затмения 20 марта 2015 года. Ее можно наблюдать на официальном канале AXE Russia на YouTube. Специально для этого организаторы отправили в поселок Баренцбург на архипелаг Шпицберген в Северном Ледовитом океане съемочную группу."
                                        category:@"Наука и техника"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/201503111"]
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:01:00 +0300"]];
    a2.isFavorite = YES;
    
    Article *a3 = [[Article alloc] initWithTitle:@"МИД назвал швейцарские санкции несуразными"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/mid/"]
                                     description:@"Решение Швейцарии принять дополнительные санкции против России выглядит несуразно на фоне содействия Москвы реализации Минских договоренностей. Об этом заявили в российском МИДе. Новые меры направлены на недопущение использования территории Швейцарии для обхода наложенных Евросоюзом санкций."
                                        category:@"Россия"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/20150311164913661/pic_bcc7b24ef4f90fe31e55a0fcb4ff6c2a.jpg"]
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:00:55 +0300"]];
    
    Article *a4 = [[Article alloc] initWithTitle:@"Минфин США пополнил санкционный список против россиян и украинцев"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/sanctions/"]
                                     description:@"Минфин США пополнил санкционный список новыми фамилиями россиян и украинцев. В список, в частности, попали бывший премьер Украины Николай Азаров и лидер Международного Евразийского движения Александр Дугин. Санкции также введены против Евразийского союза молодежи и Российского национального коммерческого банка."
                                        category:@"Финансы"
                                        imageURL:nil
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 16:59:00 +0300"]];
    
    Article *a5 = [[Article alloc] initWithTitle:@"«Почта России» подаст в суд на «Известия»"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/pochtarossii/"]
                                     description:@"«Почта России» намерена подать иск в суд к газете «Известия» с требованием опровергнуть информацию, изложенную в статье «Гендиректора \"Почты России\" обвинили в неправильных кадровых решениях», сообщили в госпредприятии. По мнению федерального почтового оператора, публикация порочит деловую репутацию менеджмента."
                                        category:@"Бизнес"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/20150311160344122/pic_9a9ada46365f59ac02a06f0bcfbbe95a.jpg"]
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 16:44:00 +0300"]];
    
    s1.articles = @[a1, a2, a3, a4, a5];
    
    Article *a6 = [[Article alloc] initWithTitle:@"Фигурант по делу «Интерры» провел на свободе 13 дней"
                                            link:[NSURL URLWithString:@"http://news.ngs.ru/more/2090792/"]
                                     description:@"Суд в Новосибирске вернул в СИЗО фигуранта дела «Интерры» Дмитрия Петрова, отпущенного под подписку о невыезде 27 февраля"
                                        category:@"новости"
                                        imageURL:nil
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:54:00 +0700"]];
    a6.isFavorite = YES;
    
    Article *a7 = [[Article alloc] initWithTitle:@"Курс доллара взлетел на 2 рубля"
                                            link:[NSURL URLWithString:@"http://news.ngs.ru/more/2090682/"]
                                     description:@"11 марта официальный курс доллара вырос больше чем на 2 руб. и превысил отметку в 62 рубля"
                                        category:@"новости"
                                        imageURL:nil
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:29:00 +0700"]];
    a7.isFavorite = YES;
    
    Article *a8 = [[Article alloc] initWithTitle:@"Дело о групповом изнасиловании студентки дошло до суда"
                                            link:[NSURL URLWithString:@"http://news.ngs.ru/more/2090642/"]
                                     description:@"10 марта в Ленинский районный суд Новосибирска поступило уголовное дело о групповом изнасиловании 16-летней студентки из Кемерово"
                                        category:@"новости"
                                        imageURL:nil
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:13:00 +0700"]];
    
    Article *a9 = [[Article alloc] initWithTitle:@"Правительство НСО упрекнули за заказ банкетов с семгой и сырами"
                                            link:[NSURL URLWithString:@"http://news.ngs.ru/more/2090622/"]
                                     description:@"Управделами правительства Новосибирской области разместило заказ на организацию банкетов на 3 млн рублей, движение «Народный фронт» выразило сомнение в целесообразности трат"
                                        category:@"новости"
                                        imageURL:nil
                                     publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 16:50:00 +0700"]];
    
    Article *a10 = [[Article alloc] initWithTitle:@"Опасный перекресток у ТЦ «Аура» подключат к видеокамерам"
                                             link:[NSURL URLWithString:@"http://news.ngs.ru/more/2090502/"]
                                      description:@"Власти Новосибирской области запланировали установить камеры для автоматической фиксации на трех аварийных перекрестках города в 2015 году"
                                         category:@"новости"
                                         imageURL:nil
                                      publishDate:[dateFormetter dateFromString:@"Wed, 11 Mar 2015 16:16:00 +0700"]];
    
    s2.articles = @[a6, a7, a8, a9, a10];
    
    return @[s1, s2];
}

@end
