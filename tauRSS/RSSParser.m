#import "RSSParser.h"
#import "Article.h"


static NSString *const nodeNameItem = @"item";
static NSString *const nodeNameTitle = @"title";
static NSString *const nodeNameDescription = @"description";
static NSString *const nodeNameLink = @"link";
static NSString *const nodeNameCategory = @"category";
static NSString *const nodeNamePublishDate = @"pubDate";


@interface RSSParser () <NSXMLParserDelegate> {
    Article *article;
    NSMutableArray *articles;
    NSMutableString *tmpString;
}
@end


@implementation RSSParser

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        articles = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)parseResponse:(NSXMLParser *)xmlParser
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
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            formatter.locale = local;
            formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
            article.publishDate = [formatter dateFromString:tmpString];
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
