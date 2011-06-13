//
//  HTTPFileUpload.h
//
//  Version: 1.01
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu Inc. All rights reserved.
//
//  License: MIT License
//

#import <Foundation/Foundation.h>


@protocol HTTPFileUploadDelegate;
@interface HTTPFileUpload : NSObject
{
 @private
  id <HTTPFileUploadDelegate> delegate_;
  NSMutableArray *postStrings_, *postImages_;
  NSMutableData *resultData_;
}
@property(nonatomic, assign) id<HTTPFileUploadDelegate> delegate;

- (void)setPostString:(NSString *)stringValue withPostName:(NSString *)postName;
- (void)setPostImage:(UIImage *)image withPostName:(NSString *)postName fileName:(NSString *)fileName;
- (void)postWithUri:(NSString *)uri;
@end

@protocol HTTPFileUploadDelegate <NSObject>
 @required
- (void)httpFileUploadDidFinishLoading:(NSURLConnection *)connection result:(NSString *)result;
 @optional
- (void)httpFileUpload:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
