//
//  AppDelegate.m
//  123
//
//  Created by T on 15/4/10.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "AppDelegate.h"
#import "AddressBookHandle.h"
#import "ABRecordHelper.h"
#import "BBFmdbTool.h"
#import "AddressBookHandle.h"
#import "ABRecordHelper.h"
#import "ChineseToPinyin.h"
#import "BBTKAddressBook.h"
#import "BBContact.h"
#import "JsonUtils.h"
#import "BBFmdbTool.h"
#import "BBContactName.h"
#import "BBContactPhoneNumber.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupCreateDataBase{
    
    NSArray *array = [[AddressBookHandle sharedAddressBook] getContactInfos];
    NSArray *dicArray = [BBContact keyValuesArrayWithObjectArray:array];
    
    for (int i = 0; i <dicArray.count; i++) {
        
        NSDictionary *dic = dicArray[i];
        NSString *email = [JsonUtils DataToJsonString:[dic valueForKey:@"emails"]];
        NSString *ims = [JsonUtils DataToJsonString:[dic valueForKey:@"ims"]];
        NSString *phoneNumbers = [JsonUtils DataToJsonString:[dic valueForKey:@"phoneNumbers"]];
        NSString *contactAddress = [JsonUtils DataToJsonString:[dic valueForKey:@"contactAddress"]];
        NSString *urls = [JsonUtils DataToJsonString:[dic valueForKey:@"urls"]];
        NSString *uuid = [dic valueForKey:@"uuid"];
        NSString *displayName = [dic valueForKey:@"displayName"];
        NSString *contactName = [JsonUtils DataToJsonString:[dic valueForKey:@"contactName"]];
        NSString *nickname = dic[@"nickname"];
        NSString *nameRemark = dic[@"nameRemark"];
        NSString *birthday = dic[@"birthday"];
        NSString *note = dic[@"note"];
        NSString *contactOrganization = [JsonUtils DataToJsonString:[dic valueForKey:@"contactOrganization"]];
        NSString *photo = dic[@"photo"];
        BOOL success = [[BBFmdbTool shareFmdbTool] insertContact:uuid displayName:displayName contactName:contactName nickname:nickname nameRemark:nameRemark phoneNumbers:phoneNumbers emails:email contactAddress:contactAddress ims:ims contactOrganization:contactOrganization birthday:birthday note:note photo:photo urls:urls];
        BBContact *contact = array[i];
        for (int j = 0; j<contact.phoneNumbers.count; j++) {
            BBContactPhoneNumber *phones = contact.phoneNumbers[j];
            NSString *phoneStr = phones.value;
            [[BBFmdbTool shareFmdbTool] insertTel:phoneStr classid:(i+1)];
        }
        
        if (success) {
            
            NSLog(@"插入成功");
        }else {
            
            NSLog(@"插入失败");
            
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@"successInsert" forKey:kSetupDataBase];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%@", NSHomeDirectory());
    
    
    // 是否需要插入数据库
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSetupDataBase]) {
        // 程序第一次启动
        [self setupCreateDataBase];
    }
    
    

    
//    BBFmdbTool *too = [[BBFmdbTool shareFmdbTool];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        // 2.申请授权
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            // 授权完毕后调用
            if (granted == YES) { // 允许
                
                // 发送通知授权成功
                NSLog(@"---允许");
                
            } else { // 不允许
                NSLog(@"---不允许");
            }
            
            // 释放对象
            CFRelease(book);
        });
    }
    
    
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
