//
//  DDNSLoggerLogger.m
//  Created by Peter Steinberger on 26.10.10.
//
//  Modifications: 12-Aug-2014 Michael Conrad Tadpol Tilstra
//  Modifications: 28-Mar-2015 Michael Conrad Tadpol Tilstra

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
    NSString *logMsg = logMessage->_message;

    if (_logFormatter) {
        // formatting is supported but not encouraged!
        logMsg = [_logFormatter formatLogMessage:logMessage];
    }

    if (logMsg) {
        int nsloggerLogLevel;
        switch (logMessage->_flag) {
            // NSLogger log levels start a 0, the bigger the number,
            // the more specific / detailed the trace is meant to be
            case DDLogFlagError  : nsloggerLogLevel = 0; break;
            case DDLogFlagWarning: nsloggerLogLevel = 1; break;
            case DDLogFlagInfo   : nsloggerLogLevel = 2; break;
            case DDLogFlagDebug  : nsloggerLogLevel = 3; break;
            case DDLogFlagVerbose:nsloggerLogLevel = 4; break;
            default : nsloggerLogLevel = 5; break;
        }

        NSString *tag = @"";
        if (logMessage->_tag) {
            tag = [logMessage->_tag description];
        }

        LogMessageF([logMessage->_file UTF8String], (int)logMessage->_line, [logMessage->_function UTF8String], tag, nsloggerLogLevel, @"%@", logMsg);
    }
}

- (NSString *)loggerName
{
    return @"cocoa.lumberjack.NSLogger";
}

@end
/*  vim: set ai cin et sw=4 ts=4 : */

