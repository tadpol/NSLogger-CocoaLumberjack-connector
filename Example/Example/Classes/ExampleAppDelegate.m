//
//  ExampleAppDelegate.m
//  NSLogger-CocoaLumberjack-connector Example
//
//  Created by Peter Steinberger on 26.11.10.
//

#import "ExampleAppDelegate.h"
#import "Logging/PSDDFormatter.h"
#import "Logging/DDFileLogger.h"
#import "Logging/DDTTYLogger.h"
#import "Logging/DDNSLoggerLogger.h"

// http://code.google.com/p/cocoalumberjack/wiki/XcodeTricks - compiles most log messages out of the release build, but not all!
// DEBUG is defined as preprocessor macro in project settings
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_INFO;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ExampleAppDelegate

@synthesize window;

- (void)configureLogger {
    PSDDFormatter *psLogger = [[[PSDDFormatter alloc] init] autorelease];
    [[DDTTYLogger sharedInstance] setLogFormatter:psLogger];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[[DDFileLogger alloc] init] autorelease];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
}

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureLogger];
    
    DDLogInfo(@"Hello from the Logger!");
    self.window.rootViewController = [[[UITableViewController alloc] init] autorelease];
    [self.window makeKeyAndVisible];    
    DDLogWarn(@"I am a warning!");
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    DDLogWarn(@"Terminating...");
}


#pragma mark - Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
