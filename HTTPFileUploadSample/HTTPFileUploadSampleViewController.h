//
//  HTTPFileUploadSampleViewController.h
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPFileUpload.h"

@interface HTTPFileUploadSampleViewController : UIViewController <HTTPFileUploadDelegate>
{
 @private
}

- (IBAction)postButtonClicked:(id)sender;
@end
