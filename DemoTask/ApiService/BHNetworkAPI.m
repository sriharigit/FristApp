//
//  BHNetworkAPI.m


#import "BHNetworkAPI.h"

@implementation BHNetworkAPI

+(instancetype)sharedInstance{
    
    static BHNetworkAPI *webAPIRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     webAPIRequest = [[BHNetworkAPI alloc] init];
    });
    
    return webAPIRequest;
}

-(void)executePOSTRequestWithUserInfo:(NSString*)userInfo requestURL:(NSString*)url Withsuccess:(BHRequestSuccess)successHandler failure:(BHRequestFailure)failureHandler{
    
    NSURL *baseURL = [self baseRequestWithURL:url];
    
    NSMutableURLRequest *requestURL = [[NSMutableURLRequest alloc] initWithURL:baseURL];
    
    [requestURL setHTTPMethod:@"POST"];
    
    [requestURL addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   
    requestURL.HTTPBody = [userInfo dataUsingEncoding:NSUTF8StringEncoding];
 
    NSURLSession *session = [self sessionConfiguration];
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:requestURL completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode =[httpResponse statusCode];
        
        if (statusCode == 200 && data != nil)
        {
            NSDictionary *jsonDictionary = [self encodeJSONResonseData:data];
            
            if ([[jsonDictionary valueForKey:@"error"] integerValue] == 1) {
            NSError* errorCustom = [self configureErrorWithMessage:[jsonDictionary valueForKey:@"error_msg"]  errorCode:400];
        failureHandler(FALSE, errorCustom);
            }
            else{
        successHandler(TRUE, jsonDictionary);
            }
        }
        else
        {
        failureHandler(FALSE, error);
        }
        
    }];
    
    [dataTask resume];
    
}

-(void)executeGETRequestWithRequestURL:(NSString*)url Withsuccess:(BHRequestSuccess)successHandler failure:(BHRequestFailure)failureHandler{
    
    NSURL *requestedURL = [self baseRequestWithURL:url];
    
    NSLog(@"requestedURL: %@",requestedURL);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestedURL];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [self sessionConfiguration];
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200 && data != nil)
        {
            NSDictionary *jsonDictionary = [self encodeJSONResonseData:data];
            
            if ([[jsonDictionary valueForKey:@"error"] integerValue] == 1) {
                
                NSError* errorCustom = [self configureErrorWithMessage:[jsonDictionary valueForKey:@"error_msg"]  errorCode:400];
                failureHandler(FALSE, errorCustom);
                
            }
            else{
                
                successHandler(TRUE, jsonDictionary);
            }
        }
        else
        {
            failureHandler(FALSE, error);
        }
        
    }];
    
    [dataTask resume];
    
}


@end
