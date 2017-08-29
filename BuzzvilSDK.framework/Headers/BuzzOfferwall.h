//
//  BuzzOfferwall.h
//  buzzofferwall-sample
//
//  Created by jeseo on 2017. 6. 22..
//  Copyright © 2017년 Buzzvil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuzzOfferwall : NSObject

+ (BOOL)showOfferWallWithTitle:(NSString *)title;
+ (BOOL)showOfferWallWithTitle:(NSString *)title statusBarHidden:(BOOL)statusBarHidden;

+ (BOOL)showInquiryPage;
+ (BOOL)showInquiryPageWithStatusBarHidden:(BOOL)statusBarHidden;

@end
