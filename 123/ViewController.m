//
//  ViewController.m
//  123
//
//  Created by T on 15/4/10.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "ViewController.h"
#import "AddressBookHandle.h"
#import "ABRecordHelper.h"
#import "ChineseToPinyin.h"
#import "BBTKAddressBook.h"
#import "BBContact.h"
#import "JsonUtils.h"
#import "BBFmdbTool.h"
#import "BBContactName.h"
#import "BBContactPhoneNumber.h"
#import "CustomKeyBoardViewController.h"
#import "BBCallSearchResultController.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate, CustomKeyBoardDelegate>
{
    NSMutableArray *contactSortedArr;
    NSMutableArray *contactSelStateArr;
    NSMutableArray *eachLetterNumArr;
    NSMutableArray *eachSectionNumArr; // UITable中组的数量
    NSMutableArray *eachSecCharArr;   //  UITable中每个组的字符(如A、B等)
    NSMutableArray *eachSecHeadPosArr; // UITable中每个组的第一个元素在contactSortedArr中的位置
    UISearchDisplayController *searchDisplay;
    UISearchBar *searchBar;
    NSMutableArray *searchResultArr;
    
    NSMutableArray *selectedPersons;
    
    T9SearchStatus _searchStatus;

}
@property (nonatomic, strong) NSArray *contactArray;

@property (strong, nonatomic) CustomKeyBoardViewController *customKeyBoardvc;
@property (nonatomic, strong) UITableView *tableview;
@property (copy, nonatomic) NSMutableString *dialNumber;
@property (strong, nonatomic) UILabel *numberLabel;
@property (nonatomic, strong) BBCallSearchResultController *callSearchResultVc;


@end

@implementation ViewController

- (BBCallSearchResultController *)callSearchResultVc{
    
    if (!_callSearchResultVc) {
        
        _callSearchResultVc = [[BBCallSearchResultController alloc] init];
        [self addChildViewController:_callSearchResultVc];
        _callSearchResultVc.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        _callSearchResultVc.view.hidden = YES;
        _callSearchResultVc.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        [self.view addSubview:_callSearchResultVc.view];
    }
    return _callSearchResultVc;
}

- (NSMutableString *)dialNumber{
    
    if (!_dialNumber) {
        
        _dialNumber = [[NSMutableString alloc] init];
    }
    return _dialNumber;
}

- (UILabel *)numberLabel{
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.backgroundColor = [UIColor redColor];
        _numberLabel.frame = CGRectMake(0, 0, 200, 30);
        self.navigationItem.titleView = _numberLabel;
    }
    return _numberLabel;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UITableView *contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        [self.view addSubview:contactTableView];
        contactTableView.delegate = self;
        contactTableView.dataSource = self;
    
    [self refreshData];
    
    
    self.customKeyBoardvc = [[CustomKeyBoardViewController alloc] initWithNibName:@"CustomKeyBoardViewController" bundle:nil];
    self.customKeyBoardvc.delegate = self;
    self.customKeyBoardvc.view.frame = CGRectMake(0, kScreenH - 216, self.customKeyBoardvc.view.frame.size.width, self.customKeyBoardvc.view.frame.size.height);
    [self.view addSubview:self.customKeyBoardvc.view];
//    [self.view bringSubviewToFront:self.customKeyBoardvc.view];
    [self.view insertSubview:self.customKeyBoardvc.view aboveSubview:self.callSearchResultVc.view];
//    self.customKeyBoardvc.view insertSubview:<#(UIView *)#> aboveSubview:<#(UIView *)#>
//    self.dialNumber = @"";
}

#pragma mark CustomKeyBoardDelegate
-(void)clickKeyBoardNumber:(NSInteger)number
{
    //显示拨号表，隐藏通话记录表
//    self.tableview.hidden = NO;
    [self.dialNumber appendFormat:@"%tu", number];
//    self.dialNumber = [self.dialNumber stringByAppendingFormat:@"%tu",number];
        self.numberLabel.text = self.dialNumber;
        self.numberLabel.font = [UIFont boldSystemFontOfSize:38.0f];
    
    self.callSearchResultVc.view.hidden = NO;
    self.callSearchResultVc.searchText = self.dialNumber;
}

- (void)clickKeyBoardRight{
    
//    [self.dialNumber substringToIndex:self.dialNumber.length - 1];
//   [self.dialNumber substringToIndex:self.dialNumber.length-1];
    if (self.dialNumber.length <=0) {
        return;
    }
    NSRange range = NSMakeRange(self.dialNumber.length - 1, 1);
    [self.dialNumber deleteCharactersInRange:range];
    self.callSearchResultVc.searchText = self.dialNumber;
//    NSLog(@"%@", self.dialNumber);
    self.numberLabel.text = self.dialNumber;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    
//    UITableView *contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
//    [self.view addSubview:contactTableView];
//    contactTableView.delegate = self;
//    contactTableView.dataSource = self;
//    contactTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 64)];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    
//    searchResultArr = [[NSMutableArray alloc] init];
//    
//    selectedPersons = [[NSMutableArray alloc] init];
//    
//    [self refreshData];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    
//    NSLog(@"%@", searchText);
//    
//    NSMutableArray *resultTmp = [NSMutableArray array];
//    
//    NSArray *localContact = [[AddressBookHandle sharedAddressBook] sortedLocalContact];
//    for (NSDictionary *item in localContact) {
//        
//        NSValue *value = item[keyPointer];
//        ABRecordRef record = value.pointerValue;
//        NSString *name = [ABRecordHelper nameOfPerson:record];
//        NSString *pinyinName = item[keyName];
//        NSString *pinyinTitle = [ChineseToPinyin translateTitleFromString:pinyinName];
//        NSArray *phones = [ABRecordHelper phonesOfPerson:record];
//        
//        NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        NSString *tmpPinyin = [pinyinName stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSRange pinyinRange = [tmpPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        NSString *tmpPinyinTitle = [pinyinTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSRange pinyinTitleRange = [tmpPinyinTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        if ((nameRange.length != 0 && nameRange.location != NSNotFound) || (pinyinRange.length != 0 && pinyinRange.location != NSNotFound) || (pinyinTitleRange.length != 0 && pinyinTitleRange.location != NSNotFound)) {
//            [resultTmp addObject:item];
//            continue;
//        }
//        
//        for (NSString *subPhone in phones) {
//            NSString *stand = [subPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            NSRange range = [stand rangeOfString:searchText options:NSCaseInsensitiveSearch];
//            if (range.length != 0 && range.location != NSNotFound) {
//                [resultTmp addObject:item];
//                break;
//            }
//        }
//    }
//    
//    [searchResultArr removeAllObjects];
//    [searchResultArr addObjectsFromArray:resultTmp];
//    for (NSDictionary *item in searchResultArr) {
//        
//        NSValue *value = item[keyPointer];
//        ABRecordRef record = value.pointerValue;
//        NSString *name = [ABRecordHelper nameOfPerson:record];
//        NSLog(@"%@", name);
//    }
//
//}
//
- (void)refreshData
{
    _contactArray = [[BBFmdbTool shareFmdbTool] QueryDatabase];
    
    contactSortedArr = [[NSMutableArray alloc] initWithArray:self.contactArray];
    
    contactSelStateArr = [[NSMutableArray alloc] initWithCapacity:contactSortedArr.count];
    
    for (int i=0; i < contactSortedArr.count; i++) {
        [contactSelStateArr addObject:@(NO)];
    }
    eachLetterNumArr = [[NSMutableArray alloc] initWithCapacity:27];
    for (int i=0; i<27; i++) {
        [eachLetterNumArr addObject:@(0)];
    }
    
    for (int i=0; i<contactSortedArr.count; i++) {
        BBContact *contact = contactSortedArr[i];
//        NSDictionary *dic = contactSortedArr[i];
        NSString *contactName = contact.displayName;
        NSString *pinyinName = [ChineseToPinyin translatePinyinFromString:contactName];
        if ([pinyinName isEqualToString:@""] || pinyinName == nil) {
            pinyinName = @"#";
        }
        NSString *pinyin = pinyinName;
        NSInteger position = [pinyin characterAtIndex:0] - 'A';
        if(position >= 0 && position < 26 ){
            NSNumber *num = eachLetterNumArr[position];
            [eachLetterNumArr replaceObjectAtIndex:position withObject:@(num.intValue +1)];
        }else{
            NSNumber *num = eachLetterNumArr.lastObject;
            [eachLetterNumArr replaceObjectAtIndex:eachLetterNumArr.count-1 withObject:@(num.intValue +1)];
        }
    }
    
    eachSectionNumArr = [[NSMutableArray alloc] init];
    eachSecCharArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < eachLetterNumArr.count; i++) {
        NSNumber *num = eachLetterNumArr[i];
        if (num.intValue > 0) {
            [eachSectionNumArr addObject:num];
            NSString *letter = [alphabet substringWithRange:NSMakeRange(i, 1)];
            [eachSecCharArr addObject:letter];
        }
    }

    eachSecHeadPosArr = [[NSMutableArray alloc] init];
    for (int i=0; i<eachSectionNumArr.count; i++) {
        if (i == 0) {
            [eachSecHeadPosArr addObject:@(0)];
        }else{
            NSInteger before = ((NSNumber *)eachSecHeadPosArr[i-1]).intValue + ((NSNumber *)eachSectionNumArr[i-1]).intValue;
            [eachSecHeadPosArr addObject:@(before)];
        }
    }

}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"%tu", [[[AddressBookHandle sharedAddressBook] getContactInfos] count]);
//    return [[[AddressBookHandle sharedAddressBook] getContactInfos] count];
    NSNumber *count = eachSectionNumArr[section];
//    NSLog(@"%@", count);
    return count.intValue;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return eachSectionNumArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return eachSecCharArr[section];
}
//
////-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
////{
////    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.f)];
////    head.backgroundColor = [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:0.8f];
////    UILabel *letterLab = [[UILabel alloc]init];
////    letterLab.backgroundColor = [UIColor clearColor];
////    letterLab.bounds = CGRectMake(0, 0, 20.f, 20.f);
////    letterLab.center = CGPointMake(15, 20.f/2);
////    letterLab.text = eachSecCharArr[section];
////    letterLab.textAlignment = 1;
////    letterLab.font = [UIFont systemFontOfSize:15];
////    [head addSubview:letterLab];
////    
////    return head;
////}
//
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return eachSecCharArr;
}
//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    NSInteger position = ((NSNumber *)eachSecHeadPosArr[indexPath.section]).intValue+indexPath.row;
    
    BBContact *contact = contactSortedArr[position];
//    NSDictionary *dic = contactSortedArr[position];
//    NSValue *value = dic[keyPointer];
//    ABRecordRef record = value.pointerValue;

//    NSString *name = [ABRecordHelper nameOfPerson:record];
    NSString *name = contact.displayName;
    cell.textLabel.text = name;
   
    return cell;
}

@end
