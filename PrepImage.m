//
//  PrepImage.m
//  circus-one
//
//  Created by colman on 25.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrepImage.h"


@implementation PrepImage

int h=0;

-(void) init {
    self = [super init];

    return self;
}
// prepare background
// this is your main image method for both views
-(UIImage *)prepareImage:(NSString *)fname {
    
//    UIImage *resultingImage = [UIImage imageNamed:fname];
                    
    CFStringRef cffilename	=(CFStringRef) fname;
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), cffilename, NULL, NULL);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(page, kCGPDFCropBox));
    uint height = pageRect.size.height;
    uint width = pageRect.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(pageRect.size.width ,  pageRect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, 1024 - 1024);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    CGContextSaveGState(context);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, CGRectMake(0, 0, pageRect.size.width, -pageRect.size.height), 0, true);
    
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
    // returns an autorelease object
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    
    [pdf release];
     h = resultingImage.size.height;
    return resultingImage;
    
}

-(int *) geth {
    return h;
}

@end
