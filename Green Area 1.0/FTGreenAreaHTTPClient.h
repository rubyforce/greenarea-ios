//
//  FTGreenAreaHTTPClient.h
//  Green Area 1.0
//
//  Created by DmVolk on 01.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "AFHTTPClient.h"

@protocol FTGreenAreaHTTPClientDelegate;

@interface FTGreenAreaHTTPClient : AFHTTPClient

@property (weak) id<FTGreenAreaHTTPClientDelegate> delegate;

+(FTGreenAreaHTTPClient *) sharedFTGreenAreaHTTPClient;
-(id)initWithBaseURL:(NSURL *)url;
-(void)updatePins;
-(void)uploadData:(NSDictionary *)uploadData;

@end

@protocol FTGreenAreaHTTPClientDelegate <NSObject>

@optional
-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client didUpdateWithPins:(id)pins;
-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client didFailWithError:(NSError *)error;
//upload data
-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client responseObject:(id)responseObject;
//upload progress
-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;

@end
