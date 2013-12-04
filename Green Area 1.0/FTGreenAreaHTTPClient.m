//
//  FTGreenAreaHTTPClient.m
//  Green Area 1.0
//
//  Created by DmVolk on 01.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTGreenAreaHTTPClient.h"

@implementation FTGreenAreaHTTPClient

+(FTGreenAreaHTTPClient *) sharedFTGreenAreaHTTPClient
{
    NSString *urlStr = @"http://greenarea.herokuapp.com/api/";
    
    static dispatch_once_t pred;
    static FTGreenAreaHTTPClient *_sharedFTGreenAreaHTTPClient = nil;
    
    dispatch_once(&pred, ^{
        _sharedFTGreenAreaHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    });
    return _sharedFTGreenAreaHTTPClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

-(void)updatePins
{
    /*
     //Parameters
     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
     [parameters setValue:@"<#string#>" forKey:<#(NSString *)#>];
     */
    
    [self getPath:@"projects"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self.delegate respondsToSelector:@selector(greenAreaHTTPClient:didUpdateWithPins:)]) {
                  [self.delegate greenAreaHTTPClient:self didUpdateWithPins:responseObject];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if ([self.delegate respondsToSelector:@selector(greenAreaHTTPClient:didFailWithError:)]) {
                  [self.delegate greenAreaHTTPClient:self didFailWithError:error];
              }
          }];
}

-(void)uploadData:(NSDictionary *)uploadData
{
    UIImage *image = uploadData[@"image"];
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);
    if (imageToUpload) {
        
        //query string
        NSMutableString *queryString = [NSMutableString string];
        [queryString appendFormat:@"?latitude=%@", uploadData[@"latitude"]];
        [queryString appendFormat:@"&longitude=%@", uploadData[@"longitude"]];
        [queryString appendFormat:@"&title=%@", uploadData[@"title"]];
        [queryString appendFormat:@"&description=%@", uploadData[@"description"]];
        //[queryString appendFormat:@"&price=%@", uploadData[@"donate"]];
        
        NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                       path:[NSString stringWithFormat:@"projects/%@",queryString]
                                                                 parameters:nil
                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                      [formData appendPartWithFileData:imageToUpload name:@"userfile" fileName:@"iphonefile.jpeg" mimeType:@"application/octet-stream"];
                                                  }];
        
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //upload progress block
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            if ([self.delegate respondsToSelector:@selector(greenAreaHTTPClient:bytesWritten:totalBytesWritten:totalBytesExpectedToWrite:)]) {
                [self.delegate greenAreaHTTPClient:self bytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
            }
        }];
        //leads to exc bad access code 2 on 2nd call
        //[self enqueueHTTPRequestOperation:operation];
        
        //completion block with success
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(greenAreaHTTPClient:responseObject:)]) {
                
                NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:kNilOptions
                                                                        error:nil];
                [self.delegate greenAreaHTTPClient:self responseObject:jsons];
            }
            //...with failure
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(greenAreaHTTPClient:didFailWithError:)]) {
                if ([operation.response statusCode] == 403) {
                    NSLog(@"Upload Failed");
                    return;
                }
                [self.delegate greenAreaHTTPClient:self didFailWithError:[operation error]];
            }
        }];
        
        [operation start];
    }
}

@end
