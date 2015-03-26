#import "RSSParser.h"
#import "Article.h"


static NSString *const nodeNameItem = @"item";
static NSString *const nodeNameTitle = @"title";
static NSString *const nodeNameDescription = @"description";
static NSString *const nodeNameLink = @"link";
static NSString *const nodeNameCategory = @"category";
static NSString *const nodeNamePublishDate = @"pubDate";
static NSString *const nodeNameArticleId = @"guid";


@interface RSSParser () <NSXMLParserDelegate> {
    Article *article;
    NSMutableSet *articles;
    NSMutableString *tmpString;
    NSDateFormatter *formatter;
}
@end


@implementation RSSParser

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        articles = [NSMutableSet set];
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
        formatter.locale = local;
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    }
    return self;
}

- (NSMutableSet *)parseResponse:(NSXMLParser *)xmlParser
{
    xmlParser.delegate = self;
    [xmlParser parse];
    return articles;
}

#pragma mark - UIWebView delegate methods

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    tmpString = [NSMutableString string];
#warning Some RSS sources contain 'entry' node instead of 'item' (e.g. github RSS). Need to additional investigation.
    if ([elementName isEqualToString:@"item"]) {
        article = [[Article alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:nodeNameItem]) {
        if (!article.articleId && article.link) {
            // Assume that value of 'link' node is primary key for items which have no 'guid' node
            article.articleId = article.link.absoluteString;
        }
        [articles addObject:article];
    }
    if (article != nil && tmpString != nil) {
        if ([elementName isEqualToString:nodeNameTitle]) {
            article.title = tmpString;
        }
        else if ([elementName isEqualToString:nodeNameDescription]) {
            article.articleDescription = tmpString;
        }
        else if ([elementName isEqualToString:nodeNameLink]) {
            article.link = [NSURL URLWithString:tmpString];
        }
        else if ([elementName isEqualToString:nodeNameCategory]) {
            article.category = tmpString;
        }
        else if ([elementName isEqualToString:nodeNamePublishDate]) {
            article.publishDate = [formatter dateFromString:tmpString];
        }
        else if ([elementName isEqualToString:nodeNameArticleId]) {
            article.articleId = tmpString;
        }
    }
    [tmpString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [tmpString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
#warning resolve TODO mark 
    // TODO: handle error properly
    [parser abortParsing];
}

@end
