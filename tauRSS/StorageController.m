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
        [self loadData];
        [self deleteReadArticles];
        
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
        source.unreadArticles = articles;
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

//default sourses
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
    
    [self storeSource:s1];
    [self storeSource:s2];
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
                                    @"DELETE FROM %@ WHERE %@ = ?", articlesTableName, articlesFavoriteColumnName];
    
    [self.db open];
    [self.db executeUpdate:queryString, @(NO)];
    [self.db close];
}

// Delete read articles from DB except favorite articles
- (void)deleteReadArticles
{
    NSString *queryString = [NSString stringWithFormat:
                             @"DELETE FROM %@ WHERE %@ = ? AND %@ = ?", articlesTableName, articlesReadColumnName, articlesFavoriteColumnName];
    
    [self.db open];
    [self.db executeUpdate:queryString, @(YES), @(NO)];
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
