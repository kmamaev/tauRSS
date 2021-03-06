#import "RSSParser.h"
#import "Article.h"
#import "NSString+StringHelper.h"


static NSDateFormatter *formatter = nil;

static NSString *const nodeNameItem = @"item";
static NSString *const nodeNameTitle = @"title";
static NSString *const nodeNameDescription = @"description";
static NSString *const nodeNameLink = @"link";
static NSString *const nodeNameCategory = @"category";
static NSString *const nodeNamePublishDate = @"pubDate";
static NSString *const nodeNameArticleId = @"guid";
static NSString *const nodeNameImage = @"image";
static NSString *const nodeNameEnclosure = @"enclosure";
static NSString *const attributeNameType = @"type";
static NSString *const attributeNameUrl = @"url";


@interface RSSParser () <NSXMLParserDelegate>
{
    Article *_article;
    NSMutableSet *_articles;
    NSMutableString *_tmpString;
    Source *_currentSource;
}
@end


@implementation RSSParser

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _articles = [NSMutableSet set];
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            formatter.locale = local;
            formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
        }
    }
    return self;
}

- (NSMutableSet *)parseResponse:(NSXMLParser *)xmlParser forSource:(Source *)source
{
    _currentSource = source;
    xmlParser.delegate = self;
    [xmlParser parse];
    return _articles;
}

#pragma mark - UIWebView delegate methods

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    _tmpString = [NSMutableString string];
#warning Some RSS sources contain 'entry' node instead of 'item' (e.g. github RSS). Need to additional investigation.
    if ([elementName isEqualToString:nodeNameItem]) {
        _article = [[Article alloc] init];
    }
    if ([elementName isEqualToString:nodeNameEnclosure]) {
        if (_article != nil) {
            if (!_article.imageURL) {
                NSString *type = [attributeDict valueForKey:attributeNameType];
                // Examples of type: "image/jpeg", "video/wmv".
                if ([type containsString:@"image"]) {
                    NSString *url = [attributeDict valueForKey:attributeNameUrl];
                    _article.imageURL = [NSURL URLWithString:url];
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:nodeNameItem]) {
        if (!_article.articleId && _article.link) {
            // Assume that value of 'link' node is primary key for items which have no 'guid' node
            _article.articleId = _article.link.absoluteString;
        }
        _article.source = _currentSource;
        [_articles addObject:_article];
    }
    if (_article != nil && _tmpString != nil) {
        if ([elementName isEqualToString:nodeNameTitle]) {
            _article.title = _tmpString;
        }
        else if ([elementName isEqualToString:nodeNameDescription]) {
            _article.articleDescription = [_tmpString stringByTrimmingCharactersInSet:[NSCharacterSet
                whitespaceAndNewlineCharacterSet]];
        }
        else if ([elementName isEqualToString:nodeNameLink]) {
            _article.link = [NSURL URLWithString:_tmpString];
        }
        else if ([elementName isEqualToString:nodeNameCategory]) {
            _article.category = _tmpString;
        }
        else if ([elementName isEqualToString:nodeNamePublishDate]) {
            _article.publishDate = [formatter dateFromString:_tmpString];
        }
        else if ([elementName isEqualToString:nodeNameArticleId]) {
            _article.articleId = _tmpString;
        }
        else if ([elementName isEqualToString:nodeNameImage]) {
            _article.imageURL = [NSURL URLWithString: _tmpString];
        }
    }
    [_tmpString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_tmpString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
#warning resolve TODO mark 
    // TODO: handle error properly
    [parser abortParsing];
}

@end
