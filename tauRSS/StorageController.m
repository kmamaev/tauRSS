#import "StorageController.h"
#import "FMDB.h"


static NSString *const sourcesTableName = @"sources";
static NSString *const sourcesIdColumnName = @"sourceId";
static NSString *const sourcesTitleColumnName = @"title";
static NSString *const sourcesIconURLColumnName = @"iconURL";
static NSString *const sourcesURLColumnName = @"sourceURL";

static NSString *const articlesTableName = @"articles";
static NSString *const articlesTitleColumnName = @"title";
static NSString *const articlesLinkColumnName = @"link";
static NSString *const articlesDescriptionColumnName = @"articleDescription";
static NSString *const articlesCategoryColumnName = @"category";
static NSString *const articlesImageURLColumnName = @"imageURL";
static NSString *const articlesPublishDateColumnName = @"publishDate";
static NSString *const articlesReadColumnName = @"isRead";
static NSString *const articlesFavoriteColumnName = @"isFavorite";
static NSString *const articleIdColumnName = @"guid";

static NSString *const DefaultFileNameForDataBase = @"AwesomeDataBase.db";



@interface StorageController ()

@property (strong, nonatomic) FMDatabase *db;

@end


@implementation StorageController

- (instancetype)init
{
    if (self = [super init])
    {
        NSURL *const documentDirectoryURL =
        [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask] lastObject];
        NSURL *fileURLForDataBase =
        [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForDataBase];
        _db = [FMDatabase databaseWithPath:[fileURLForDataBase path]];
        [self createTables];
        //[self loadData];
        
    }
    return self;
}

- (void)storeSource:(Source *)source
{

    NSString *queryString = [NSString stringWithFormat:
                             @"INSERT OR REPLACE INTO %@ (%@, %@, %@, %@) VALUES (?, ?, ?, ?)",
                             sourcesTableName, sourcesIdColumnName, sourcesTitleColumnName, sourcesIconURLColumnName, sourcesURLColumnName];
    
    [self.db open];
    [self.db executeUpdate:queryString, @(source.sourceId), source.title, [source.iconURL absoluteString], [source.sourceURL absoluteString]];
    [self.db close];

}

- (void)storeArticles:(NSArray *)articles forSourceWithId:(NSInteger)sourceId
{
    NSString *queryString = [NSString stringWithFormat:
                             @"INSERT OR REPLACE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                             articlesTableName,
                             articleIdColumnName,
                             articlesTitleColumnName,
                             articlesLinkColumnName,
                             articlesDescriptionColumnName,
                             articlesCategoryColumnName,
                             articlesImageURLColumnName,
                             articlesPublishDateColumnName,
                             articlesReadColumnName,
                             articlesFavoriteColumnName,
                             sourcesIdColumnName];
    
    [self.db open];
    for (Article *article in articles)
    {
        [self.db executeUpdate:queryString,
         article.articleId,
         article.title,
         [article.link absoluteString],
         article.articleDescription,
         article.category,
         [article.imageURL absoluteString],
         article.publishDate,
         @(article.isRead),
         @(article.isFavorite),
         @(sourceId)];
    }
    [self.db close];
}

- (NSArray *)getAllSources
{
    NSMutableArray *sources = [NSMutableArray array];
    
    NSString *sourcesQueryString = [NSString stringWithFormat:
                             @"SELECT * FROM %@", sourcesTableName];
    
    NSString *articlesQueryString = [NSString stringWithFormat:
                                    @"SELECT * FROM %@ WHERE %@ = ?", articlesTableName, sourcesIdColumnName];
    [self.db open];
    FMResultSet *resultSourceSet = [self.db executeQuery:sourcesQueryString];
    while ([resultSourceSet next])
    {
        Source *source = [[Source alloc]init];
        source.sourceId = [resultSourceSet intForColumn:sourcesIdColumnName];
        source.title = [resultSourceSet stringForColumn:sourcesTitleColumnName];
        source.iconURL = [NSURL URLWithString:[resultSourceSet stringForColumn:sourcesIconURLColumnName]];
        source.sourceURL = [NSURL URLWithString:[resultSourceSet stringForColumn:sourcesURLColumnName]];
        NSMutableArray *articles = [NSMutableArray array];
        
        FMResultSet *resultArticleSet = [self.db executeQuery:articlesQueryString, @(source.sourceId)];
        while ([resultArticleSet next])
        {
            Article *article = [[Article alloc]init];
            article.articleId = [resultArticleSet stringForColumn:articleIdColumnName];
            article.title = [resultArticleSet stringForColumn:articlesTitleColumnName];
            article.link = [NSURL URLWithString:[resultArticleSet stringForColumn:articlesLinkColumnName]];
            article.articleDescription = [resultArticleSet stringForColumn:articlesDescriptionColumnName];
            article.category = [resultArticleSet stringForColumn:articlesCategoryColumnName];
            article.imageURL = [NSURL URLWithString:[resultArticleSet stringForColumn:articlesImageURLColumnName]];
            article.publishDate = [resultArticleSet dateForColumn:articlesPublishDateColumnName];
            article.isRead = @([resultArticleSet intForColumn:articlesReadColumnName]).boolValue;
            article.isFavorite = @([resultArticleSet intForColumn:articlesFavoriteColumnName]).boolValue;
            article.source = source;
            [articles addObject:article];
        }
        
        source.articles = articles;
        [sources addObject:source];
    }
    [self.db close];
    
    return sources;
}


- (void)createTables
{
    NSString *createSourcesTableQuery = [NSString stringWithFormat:
                                  @"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT)",
                                  sourcesTableName, sourcesIdColumnName, sourcesTitleColumnName, sourcesIconURLColumnName, sourcesURLColumnName];
    
    NSString *createArticlesTableQuery = [NSString stringWithFormat:
                                  @"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ DATETIME, %@ INTEGER, %@ INTEGER, %@ INTEGER, FOREIGN KEY(%@) REFERENCES %@(%@))",
                                          articlesTableName,
                                          articleIdColumnName,
                                          articlesTitleColumnName,
                                          articlesLinkColumnName,
                                          articlesDescriptionColumnName,
                                          articlesCategoryColumnName,
                                          articlesImageURLColumnName,
                                          articlesPublishDateColumnName,
                                          articlesReadColumnName,
                                          articlesFavoriteColumnName,
                                          sourcesIdColumnName,
                                          sourcesIdColumnName,
                                          sourcesTableName,
                                          sourcesIdColumnName];
    
    [self.db open];
    BOOL sourcesTableCreationResult = [self.db executeUpdate:createSourcesTableQuery];
    BOOL articlesTableCreationResult = [self.db executeUpdate:createArticlesTableQuery];
    if (sourcesTableCreationResult && articlesTableCreationResult) {
        NSLog(@"Table 'sources' and 'articles' has been created.");
    }
    [self.db close];

    
}

//to test implemented methods 
- (void)loadData
{
    Source *s1 = [[Source alloc] init];
    s1.title = @"Лента RSS";
    s1.sourceId = 1;
    s1.sourceURL = [NSURL URLWithString:@"http://lenta.ru/rss/news"];
    Source *s2 = [[Source alloc] init];
    s2.title = @"НГС RSS";
    s2.sourceId = 2;
    s2.sourceURL = [NSURL URLWithString:@"http://news.ngs.ru/rss/"];
    
    NSDateFormatter *dateFormetter = [[NSDateFormatter alloc] init];
    dateFormetter.dateFormat = @"ccc, dd MMM yyyy HH:mm:ss Z";
    
    Article *a1 = [[Article alloc] initWithTitle:@"Совет директоров «Башнефти» возглавил первый замглавы Минэнерго"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/bashneft/"]
                                     description:@"Совет директоров одной из крупнейших нефтекомпаний России «Башнефть» выбрал своим председателем первого заместителя министра энергетики РФ Алексея Текслера. Также акционеры «Башнефти» на состоявшемся ранее внеочередном собрании  утвердили новый состав совета директоров компании."
                                        category:@"Бизнес"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/20150311162956926/pic_eac0cee430fbcd74e6e4b12d5f3c3a9d.jpg"]
                                     publishDate:[NSDate date]];//[dateFormetter dateFromString:@"Wed, 11 Mar 2015 17:01:02 +0300"]];
    a1.isFavorite = YES;
    
    Article *a2 = [[Article alloc] initWithTitle:@"В России организуют прямую трансляцию полного солнечного затмения"
                                            link:[NSURL URLWithString:@"http://lenta.ru/news/2015/03/11/sun/"]
                                     description:@"В России будет организована прямая трансляция солнечного затмения 20 марта 2015 года. Ее можно наблюдать на официальном канале AXE Russia на YouTube. Специально для этого организаторы отправили в поселок Баренцбург на архипелаг Шпицберген в Северном Ледовитом океане съемочную группу."
                                        category:@"Наука и техника"
                                        imageURL:[NSURL URLWithString:@"http://icdn.lenta.ru/images/2015/03/11/16/20150311163021002/pic_fe068f829cb6bdd86f73e5b3b6ca84b2.jpg"]
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
    
    a1.source = a2.source = a3.source = a4.source = a5.source = s1;
    
    a1.articleId = [a1.link absoluteString];
    a2.articleId = [a2.link absoluteString];
    a3.articleId = [a3.link absoluteString];
    a4.articleId = [a4.link absoluteString];
    a5.articleId = [a5.link absoluteString];
    
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
    
    a6.source = a7.source = a8.source = a9.source = a10.source = s2;
    
    a6.articleId = [a6.link absoluteString];
    a7.articleId = [a7.link absoluteString];
    a8.articleId = [a8.link absoluteString];
    a9.articleId = [a9.link absoluteString];
    a10.articleId = [a10.link absoluteString];
    
    s2.articles = @[a6, a7, a8, a9, a10];
    
    [self storeSource:s1];
    [self storeSource:s2];
    [self storeArticles:s1.articles forSourceWithId:s1.sourceId];
    [self storeArticles:s2.articles forSourceWithId:s2.sourceId];
    
    
    
}

- (void)deleteSource:(Source *)source
{
    NSString *sourceQueryString = [NSString stringWithFormat:
                             @"DELETE FROM %@ WHERE %@ = ?", sourcesTableName, sourcesIdColumnName];
    
    NSString *articleQueryString = [NSString stringWithFormat:
                                   @"DELETE FROM %@ WHERE %@ = ?", articlesTableName, sourcesIdColumnName];
    
    [self.db open];
    [self.db executeUpdate:sourceQueryString, @(source.sourceId)];
    [self.db executeUpdate:articleQueryString, @(source.sourceId)];
    [self.db close];
}

- (void)setRead:(BOOL)isRead forArticle:(Article *)article
{
    NSString *queryString = [NSString stringWithFormat:
                             @"UPDATE %@ SET %@ = ? WHERE %@ = ?", articlesTableName, articlesReadColumnName, articleIdColumnName];
    [self.db open];
    [self.db executeUpdate:queryString, @(isRead), article.articleId];
    [self.db close];
}

- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article
{
    NSString *queryString = [NSString stringWithFormat:
                             @"UPDATE %@ SET %@ = ? WHERE %@ = ?", articlesTableName, articlesFavoriteColumnName, articleIdColumnName];
    [self.db open];
    [self.db executeUpdate:queryString, @(isFavorite), article.articleId];
    [self.db close];
}

- (void)deleteAllArticles
{
    NSString *queryString = [NSString stringWithFormat:
                                    @"DELETE FROM %@", articlesTableName];
    
    [self.db open];
    [self.db executeUpdate:queryString];
    [self.db close];
}

- (NSArray *)getFavoriteArticles
{
    NSMutableArray *articles = [NSMutableArray array];
    
    NSString *queryString = [NSString stringWithFormat:
                                     @"SELECT * FROM %@ WHERE %@ = ?", articlesTableName, articlesFavoriteColumnName];
    [self.db open];
    FMResultSet *resultSet = [self.db executeQuery:queryString, @(YES)];
    while ([resultSet next])
    {
        Article *article = [[Article alloc]init];
        article.articleId = [resultSet stringForColumn:articleIdColumnName];
        article.title = [resultSet stringForColumn:articlesTitleColumnName];
        article.link = [NSURL URLWithString:[resultSet stringForColumn:articlesLinkColumnName]];
        article.articleDescription = [resultSet stringForColumn:articlesDescriptionColumnName];
        article.category = [resultSet stringForColumn:articlesCategoryColumnName];
        article.imageURL = [NSURL URLWithString:[resultSet stringForColumn:articlesImageURLColumnName]];
        article.publishDate = [resultSet dateForColumn:articlesPublishDateColumnName];
        article.isRead = @([resultSet intForColumn:articlesReadColumnName]).boolValue;
        article.isFavorite = @([resultSet intForColumn:articlesFavoriteColumnName]).boolValue;
        [articles addObject:article];
    }
    
    [self.db close];
    return articles;
}

@end
