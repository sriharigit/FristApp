//
//  BHNetworkBase.m
//

#import "BHNetworkBase.h"

@implementation BHNetworkBase

-(NSURL *)baseRequestWithURL:(NSString *)requestURL{
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@",URL_BASE,requestURL];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(NSURLSession *)sessionConfiguration{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    return session;
}

-(NSDictionary *)encodeJSONResonseData:(NSData *)data{
    
    NSError *jsonError;
    id response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    NSDictionary * jsonDictionary = [NSDictionary new];
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        jsonDictionary = response;
    }
    else{
        jsonDictionary = [response lastObject];
    }
    
    return jsonDictionary;
}

-(NSError*)configureErrorWithMessage:(NSString*)message errorCode:(NSInteger)errorCode{
    NSDictionary* dictionary = @{NSLocalizedDescriptionKey: message };
    NSError* errorCustom = [NSError errorWithDomain:@"com.FreshMasahari.kcf" code:errorCode userInfo:dictionary];
    return errorCustom;
    
}
@end
