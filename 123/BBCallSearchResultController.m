//
//  BBCallSearchResultController.m
//  123
//
//  Created by 李灵斌 on 15-4-18.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "BBCallSearchResultController.h"
#import "SearchCoreManager.h"
#import "BBFmdbTool.h"
#import "BBContact.h"
#import "BBContactPhoneNumber.h"
#define KDailSearchFunction @"22233344455566677778889999"

@interface BBCallSearchResultController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *searchByPhone;
@property (nonatomic, strong) NSMutableArray *searchByName;
@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation BBCallSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self searchBarInit];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    self.contactDic = dic;
    
    NSMutableArray *nameIDArray = [[NSMutableArray alloc] init];
    self.searchByName = nameIDArray;

    NSMutableArray *phoneIDArray = [[NSMutableArray alloc] init];
    self.searchByPhone = phoneIDArray;

    
    //添加到搜索库
     NSArray  *contacts = [[BBFmdbTool shareFmdbTool] QueryDatabase];
    for (int i = 0; i<contacts.count; i++) {
        
        BBContact *contact = contacts[i];
        NSMutableArray *phoneArray = [NSMutableArray array];
        NSArray *phones = contact.phoneNumbers;
        
        for (BBContactPhoneNumber *phone in phones) {
            
            [phoneArray addObject:phone.value];
        }
        contact.localID = [NSNumber numberWithInt:i];
        
        [[SearchCoreManager share] AddContact:contact.localID name:contact.displayName phone:phoneArray];
        [self.contactDic setObject:contact forKey:contact.localID];
    }
    
}

- (void)setSearchText:(NSString *)searchText{
    
    NSLog(@"%@", searchText);
    
    [[SearchCoreManager share] SearchWithFunc:KDailSearchFunction searchText:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];

//    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
        [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    if ([self.searchText length] <= 0) {
//        return [self.contactDic count];
//    } else {
        return [self.searchByName count] + [self.searchByPhone count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier] ;
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    }
    
//    if ([self.searchText length] <= 0) {
//        BBContact *contact = [[self.contactDic allValues] objectAtIndex:indexPath.row];
//        cell.textLabel.text = contact.displayName;
//        cell.detailTextLabel.text = [contact.localID stringValue];
//        return cell;
//    }
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    if (indexPath.row < [_searchByName count]) {
        localID = [self.searchByName objectAtIndex:indexPath.row];
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        if ([self.searchText length]) {
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
    }else {
        localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
        NSMutableArray *matchPhones = [NSMutableArray array];
        
        //号码匹配 获取对应匹配的号码串 及高亮位置
        if ([self.searchText length]) {
            [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
            [matchString appendString:[matchPhones objectAtIndex:0]];
        }
    }
    BBContact *contact = self.contactDic[localID];
    
    cell.textLabel.text = contact.displayName;
    BBContactPhoneNumber *phone = contact.phoneNumbers[0];
    NSString *phoneNumber = phone.value;
    cell.detailTextLabel.text = phoneNumber;
    
    return cell;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
//    NSLog(@"%@", searchText);
//    [self.tableView reloadData];
//}



@end
