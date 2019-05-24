//
//  SecondViewController.m
//  DemoTask
//
//  Created by admin on 21/02/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)getServices
{

    NSString* userInfo = [NSString stringWithFormat:@"%@?token=%@",URL_Get_Id,_tokenStr];
    [[BHNetworkAPI sharedInstance] executeGETRequestWithRequestURL:userInfo Withsuccess:^(BOOL success, id  _Nonnull response) {
        
        NSLog(@"cartVC :: executeRequest :: success: %@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self->_tablV reloadData];
            
        });
        
    }
            failure:^(BOOL success, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
            NSLog(@"ServicesVC :: executeRequest :: success: %@",error);
                                                                   
                });
                                                               
        }];
    
}

-(void)postmethod
{
    NSString* str = [NSString stringWithFormat:@"email=%@&password=%@",@"",@""];
    NSData* postId = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* postIdLenth = [NSString stringWithFormat:@"%lu",(unsigned long)[postId length]];
    NSString* url = @"";
    NSURL* nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsurl];
    [request setHTTPMethod:@"GET"];
    [request setValue:postIdLenth forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postId];
    NSURLSession* sesssion = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask* data = [sesssion dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        }else{
        NSMutableDictionary* responc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@",responc);
        }
    }];
    [data resume];
}
-(void)getmethodTatice
{
    NSString*str = @"";
    NSURL* url = [NSURL URLWithString:str];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
        NSMutableDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@",dict);
            
        }
    }];
    [dataTask resume];
    
}



@end
