//
//  BHNetworkAPI.h


#import "BHNetworkBase.h"

@interface BHNetworkAPI : BHNetworkBase

+(instancetype)sharedInstance;

-(void)executePOSTRequestWithUserInfo:(NSString*)userInfo requestURL:(NSString*)url Withsuccess:(BHRequestSuccess)successHandler failure:(BHRequestFailure)failureHandler;
-(void)executeGETRequestWithRequestURL:(NSString*)url Withsuccess:(BHRequestSuccess)successHandler failure:(BHRequestFailure)failureHandler;

@end
