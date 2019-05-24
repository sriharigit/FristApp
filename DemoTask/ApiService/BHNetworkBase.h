//
//  BHNetworkBase.h


#import <Foundation/Foundation.h>
#import "BHURLHeader.h"

typedef void(^BHRequestSuccess)(BOOL success, id _Nonnull response);
typedef void(^BHRequestFailure)(BOOL success, NSError* _Nonnull  error);

@interface BHNetworkBase : NSObject

-(NSURL *)baseRequestWithURL:(NSString *)requestURL;

-(nonnull NSURLSession *)sessionConfiguration;

-(NSDictionary *)encodeJSONResonseData:(NSData *)data;

-(NSError*)configureErrorWithMessage:(NSString*)message errorCode:(NSInteger)errorCode;

@end
