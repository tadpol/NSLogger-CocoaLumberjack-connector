//
//  DDNSLoggerLogger.m
//  Created by Peter Steinberger on 26.10.10.
//
//  Modifications: 12-Aug-2014 Michael Conrad Tadpol Tilstra

#import "DDNSLoggerLogger.h"

// NSLogger is needed: http://github.com/fpillet/NSLogger
#import "LoggerClient.h"

@implementation DDNSLoggerLogger

+ (DDNSLoggerLogger *)sharedInstance
{
    static DDNSLoggerLogger *localLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localLogger = [DDNSLoggerLogger new];
    });
    return localLogger;
}

- (id)init
{
    if ((self = [super init])) {
        LoggerSetOptions(LoggerGetDefaultLogger(), kLoggerOption_BrowseBonjour|kLoggerOption_BrowseOnlyLocalDomain|kLoggerOption_BufferLogsUntilConnection|kLoggerOption_UseSSL);
        LoggerStart(NULL);
    }
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage
{
    NSString *logMsg = logMessage->logMsg;

    if (formatter) {
        // formatting is supported but not encouraged!
        logMsg = [formatter formatLogMessage:logMessage];
    }

    if (logMsg) {
        int nsloggerLogLevel;
        switch (logMessage->logFlag) {
            // NSLogger log levels start a 0, the bigger the number,
            // the more specific / detailed the trace is meant to be
            case LOG_FLAG_ERROR : nsloggerLogLevel = 0; break;
            case LOG_FLAG_WARN  : nsloggerLogLevel = 1; break;
            case LOG_FLAG_INFO  : nsloggerLogLevel = 2; break;
            case LOG_FLAG_VERBOSE:nsloggerLogLevel = 3; break;
            default : nsloggerLogLevel = 4; break;
        }

        NSString *tag = @"";
        if (logMessage->tag) {
            tag = [logMessage->tag description];
        }

        LogMessageF(logMessage->file, logMessage->lineNumber, logMessage->function, tag, nsloggerLogLevel, @"%@", logMsg);
    }
}

- (NSString *)loggerName
{
    return @"cocoa.lumberjack.NSLogger";
}

@end
/*  vim: set ai cin et sw=4 ts=4 : */

