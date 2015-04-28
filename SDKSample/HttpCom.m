//
//  HttpCom.m
//  WeiDotaClient
//
//  Created by scilearn peng on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpCom.h"
#import <UIKit/UIAlertView.h>

@implementation HttpCom

#define USERAGENT @"Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20100101 Firefox/10.0"

+ (HttpCom*) instance
{
    static HttpCom* theInstance = nil;
    if (theInstance == nil)
    {
        theInstance = [[HttpCom alloc] init];
    }
    return theInstance;
}

- (NSDictionary*) sendHttpPostSyncRequest:(NSString*)urlString postData:(NSString*)post
{
    NSMutableString *uri = [NSMutableString stringWithString:urlString];
    NSLog(@"%@", uri);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [request setHTTPMethod:@"POST"];
    [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;    
    NSError *error = [[NSError alloc] init];
    // sychronize request, wait for response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //stausCode should be 0 
    NSLog(@"response code:%ld",[urlResponse statusCode]);
    NSLog(@"response:%@",result); 
    if([urlResponse statusCode] >= 200 && [urlResponse statusCode] <300)
    { 
        SBJSON *json = [SBJSON new];
        NSDictionary *results = (NSDictionary*)[json objectWithString:result error:nil];
        
        if ([[results objectForKey:@"error"] intValue] != 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert=[[UIAlertView alloc]
                                         initWithTitle:@"提示"
                                         message:[results objectForKey:@"message"]
                                         delegate:nil 
                                         cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
                [alert show];
            });
            return nil;
        } else if ([[results objectForKey:@"error"] intValue] != 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert=[[UIAlertView alloc]
                                    initWithTitle:@"提示"
                                    message:[results objectForKey:@"message"]
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
                [alert show];
            });
            return nil;
        } else {
            if ([results objectForKey:@"alert"] != nil) {
                NSMutableString * msg = [NSMutableString stringWithString:@""];
                if ([[results objectForKey:@"alert"] isKindOfClass:[NSArray class]]) {
                    NSArray *array = [results objectForKey:@"alert"];
                    for (NSString *s in array) {
                        if (msg.length) {
                            [msg appendString:@"\n"];
                        }
                        [msg appendString:s];
                    }
                } else {
                    [msg appendString:[results objectForKey:@"alert"]];
                }
                if (msg.length) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert=[[UIAlertView alloc]
                                            initWithTitle:@"提示"
                                            message:msg
                                            delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
                        [alert show];
                    });
                }
            }
        }

        return results;
    } 
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert=[[UIAlertView alloc]
                                     initWithTitle:@"提示"
                                     message:@"网络连接失败，请检查网络"
                                     delegate:nil 
                                     cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
            
            [alert show];
        });
    }
    return nil;
}

- (NSDictionary*) sendBackHttpSyncRequest:(NSString*)urlString
{
    NSMutableString *uri = [NSMutableString stringWithString:urlString];
    
    NSLog(@"%@", uri);
    // init http request and auto release memory 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"]; 
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *urlResponse = nil; 
    NSError *error = [[NSError alloc] init];
    // sychronize request, wait for response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    //stausCode should be 0 
    NSLog(@"response code:%ld",[urlResponse statusCode]);
    NSLog(@"response:%@",result); 
    if([urlResponse statusCode] >= 200 && [urlResponse statusCode] <300)
    { 
        SBJSON *json = [SBJSON new];
        NSDictionary *results = (NSDictionary*)[json objectWithString:result error:nil];
        
        if ([[results objectForKey:@"error"] intValue] != 0)
        {
            return nil;
        }
        return results;
    } 

    return nil;
}


- (NSString*) sendHttpSyncRequest:(NSString*)urlString
{
    NSMutableString *uri = [NSMutableString stringWithString:urlString];
    NSLog(@"%@", uri);
    // init http request and auto release memory 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    //[request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];

    [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml; charset=utf-8"]; 
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *urlResponse = nil;//[[NSHTTPURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    // sychronize request, wait for response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        NSLog(@"%@", error);
    }
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    //stausCode should be 0 
    NSLog(@"response code:%ld",[urlResponse statusCode]);
    NSLog(@"response:%@",result); 
    if([urlResponse statusCode] >= 200 && [urlResponse statusCode] <300)
    { 
        
        return result;
    } 
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert=[[UIAlertView alloc]
                                 initWithTitle:@"提示"
                                 message:@"网络连接失败"
                                 delegate:nil 
                                 cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
        });
    }
    return nil;
}

// wait for implement
- (void) sendHttpAsyncRequest:(NSString*)urlString handle:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSMutableString *uri = [NSMutableString stringWithString:urlString];
    NSLog(@"%@", uri);
    // init http request and auto release memory 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"]; 
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //NSHTTPURLResponse *urlResponse = nil; 
    // asychronize request
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
}


@end
