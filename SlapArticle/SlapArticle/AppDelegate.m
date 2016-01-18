//
//  AppDelegate.m
//  SlapArticle
//
//  Created by 成焱 on 15/10/17.
//  Copyright © 2015年 成焱. All rights reserved.
//

#import "AppDelegate.h"
#import "WBIntroduceViewController.h"
#import "UMFeedback.h"
#import "MobClick.h"
#import "User.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "SAEncryt.h"
#import "APService.h"
#import "GDTSplashAd.h"
#import "GDTViewController.h"
#import "SAArticleViewController.h"
#define UMengAppKey @"562642a267e58e72bd003022"

#define SHOULD_SHOW_GUANG_DIAN_TONG     0

@interface AppDelegate ()<UITabBarControllerDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (SHOULD_SHOW_GUANG_DIAN_TONG) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:appHasLaunchedKey] == NO) {
            [self makeWindowRootViewControllerToIntruduce];
            [self setAppHasLaunched];
        }else {
            [self setUpGuandiantong];
        }
    }else{
        if ([[NSUserDefaults standardUserDefaults]boolForKey:appHasLaunchedKey] == NO) {
            [self makeWindowRootViewControllerToIntruduce];
            [self setAppHasLaunched];
        }
    }
    
    [SAEncryt getEncrytParams];
    [self setUpUMeng];
    [self setUpShareSdk];
    [self setUpJPush:launchOptions];
    
    return YES;
}




- (void)setUpShareSdk
{
    [ShareSDK registerApp:@"b4c87fd55640"
    
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1421676409"
                                           appSecret:@"fdb8365d8e9dbb49fe67ba2d5536908f"
                                         redirectUri:@"http://quanwen.bmob.cn/sina2/callback"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb8925036bfc74e8e"
                                       appSecret:@"319a4e14d7455c9db11228b387f3f4f3"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104869203"
                                      appKey:@"M5huVZXwtA5xuJUB"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
}

- (void)setUpGuandiantong
{
    
    UIViewController *curRoot = self.window.rootViewController;
    UITabBarController *tabbar = (UITabBarController *)curRoot;
    [self setDelegateToSelfTabbarCtl:tabbar];
    
    GDTViewController *GdtVC = [[GDTViewController alloc]init];
    GdtVC.window = self.window;
    GdtVC.finish = ^(void){
        self.window.rootViewController = curRoot;
    };
    self.window.rootViewController = GdtVC;
}

- (void)setUpUMeng
{
    [UMFeedback setAppkey:UMengAppKey];
    [MobClick startWithAppkey:UMengAppKey reportPolicy:BATCH channelId:nil];
}

- (void)setDelegateToSelfTabbarCtl:(UITabBarController *)tabbarctl
{
    tabbarctl.delegate = self;
}

- (void)setUpJPush:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             
                                             
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
}

//force jump to HomePage and Refrsh ,this method will called when user revieve remote notificaton on the background
- (void)forceJumpToHomePageAndRefresh:(id)userInfo
{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SAArticleViewController *articelVC = [mainStory instantiateViewControllerWithIdentifier:@"SAArticleViewController"];
    articelVC.isPresent = YES;
    UINavigationController *navagation = [[UINavigationController alloc]initWithRootViewController:articelVC];
    navagation.navigationBar.barTintColor = RGBCOLOR(72, 179, 166);
    [navagation.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
    UIViewController *currentRootViewController = [self.window rootViewController];
    if ([currentRootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController *)currentRootViewController;
        UIViewController *selectedCtl = [tbc selectedViewController];
        if ([selectedCtl isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)selectedCtl;
            UIViewController *top = [navi topViewController];
            if (top != nil) {
                [top presentViewController:navagation animated:YES completion:nil];
            }
        }else{
            [selectedCtl presentViewController:navagation animated:YES completion:nil];
        }
    }
}

- (void)setAppHasLaunched
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:appHasLaunchedKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)makeWindowRootViewControllerToIntruduce
{
    UIViewController *curRoot = self.window.rootViewController;
    
    NSArray <UIImage *>* intruduceImages = @[[UIImage imageNamed:@"sa_intrduce_1"],
                                             [UIImage imageNamed:@"sa_intrduce_2"],
                                             [UIImage imageNamed:@"sa_intrduce_3"]];
    WBIntroduceViewController *indruduceVC = [[WBIntroduceViewController alloc]initWithIntruduceImages:intruduceImages];
    [indruduceVC setHandleLastImageViewClickCallBack:^{
        self.window.rootViewController = curRoot;
        UITabBarController *tabbar = (UITabBarController *)curRoot;
        [self setDelegateToSelfTabbarCtl:tabbar];
    }];
    self.window.rootViewController = indruduceVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    CGFloat systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    
    if (systemVersion >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 1) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    [APService resetBadge];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "chenyan.SlapArticle" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SlapArticle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SlapArticle.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //TODO,do not deal this condition
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self forceJumpToHomePageAndRefresh:userInfo];
        });
    }
}

#pragma mark -TABBAR_DELEGATE

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"VIEWCONTROLLER = %@",viewController);
    
    UIViewController *naviroot = [(UINavigationController *)viewController topViewController];
    if ([NSStringFromClass([naviroot class]) isEqualToString:@"SAArticleViewController"]) {
        [MobClick event:@"MobclickAgent1"];
    }else if ([NSStringFromClass([naviroot class]) isEqualToString:@"SADiscoverViewController"]){
        [MobClick event:@"MobclickAgent2"];
    }else if ([NSStringFromClass([naviroot class]) isEqualToString:@"SAOurViewController"]){
        [MobClick endEvent:@"MobclickAgent3"];
    }
}
@end
