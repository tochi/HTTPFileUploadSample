//
//  HTTPFileUpload.h
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPFileUpload : NSObject
{
 @private
  NSMutableArray *postStrings, *postImages;
}

- (void)setPostString:(NSString *)stringValue withPostName:(NSString *)postName;
- (void)setPostImage:(UIImage *)image withPostName:(NSString *)postName fileName:(NSString *)fileName;
- (NSString *)postWithUri:(NSString *)uri;
@end
