//
//  WBLogUtils.m
//  SlapArticle
//
//  Created by 成焱 on 15/11/8.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "WBLogUtils.h"

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;
    // Initialize a variable argument list.
    va_start (ap, format);
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n\n⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    // End using variable argument list.
    va_end (ap);
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "[%s LINE:%d]%s:\n%s",
            [fileName UTF8String],lineNumber,
            (functionName[0])=='-'?(&functionName[1]):functionName,
            [body UTF8String]);
}
