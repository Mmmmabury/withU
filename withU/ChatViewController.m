//
//  chatViewController.m
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatSearchResultController.h"
#import "Chat.h"
#import "netWorkTool.h"
#import "withUNetTool.h"
#import "define.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource >
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (copy, nonatomic) NSArray *chatData;
@property (strong, nonatomic) id <withUNetTool> delegate;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:@"ChatTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"chatCellTableIdentifier"];
    [self loadData];
//    搜索栏
    NSMutableArray *names = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.chatData)
    {
        [names addObject:dict[@"nickName"]];
    }
    ChatSearchResultController *resultController = [[ChatSearchResultController alloc] initWithData:[NSArray arrayWithArray:names]];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultController];
    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    self.searchController.searchResultsUpdater = resultController;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginView) name:@"presentLoginView" object:nil];
     self.delegate = [[netWorkTool alloc] initWithMqttClientId:@"sub"];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    if (!isLogin) {
        NSLog(@"islogin == no");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"presentLoginView" object:nil];
//        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        UIViewController *cv = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginMain"];
//        [self presentViewController:cv animated:YES completion:nil];
    }else{
        
         [self.delegate mqttSub];
    }
   
   
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receiveMessage" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"registerSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsDidGet) name:@"friendsDidGet" object:nil];
}

- (void) friendsDidGet{
    
    
    NSMutableArray *friendsId = [[NSMutableArray alloc] init];
    for (NSDictionary *fDict in self.chatData){
        
        [friendsId addObject:fDict[@"userId"]];
    }
    for (NSString *userId in friendsId){
        
        [self.delegate getAvatarById:userId];
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self loadData];
    [self.tableView reloadData];
}
/**
 *  加载聊天数据
 */
- (void) loadData{
    
    NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    // 聊天数据路径，放在沙盒的 document 目录下
    NSString *docpath = [docpaths objectAtIndex:0];
    docpath = [docpath stringByAppendingString:@"/chatMessages.plist"];
    NSDictionary *chatDict = [NSDictionary dictionaryWithContentsOfFile:docpath];
    NSArray *userIdArray = [[chatDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (chatDict.count == 0) {
        return;
    }
    docpath = [docpaths[0] stringByAppendingString:@"/c.plist"];
    NSDictionary *friendsDict = [NSDictionary dictionaryWithContentsOfFile:docpath];
    NSArray *allFriendsInfo = [friendsDict allValues];
    NSMutableArray *chatData = [[NSMutableArray alloc] init];
    for (NSString *friendId in userIdArray){
        NSArray *a = chatDict[friendId];
        if ([a count] == 0) {
            continue;
        }
        for (NSArray *friends in allFriendsInfo){
            
            if (friends.count == 0) {
                
                continue;
            }else{
                for(NSDictionary *friend in friends){
                    
                    
                    if ([[NSString stringWithFormat:@"%d" ,[friend[@"userId"] intValue]] isEqualToString: friendId]) {
                        
                        NSMutableDictionary *chatInfo = [[chatDict[friendId]lastObject] mutableCopy];
                        [chatInfo setObject:friendId forKey:@"friendId"];
                        [chatInfo setObject:friend[@"userNickName"] forKey:@"nickName"];
                        [chatData addObject:chatInfo];
                    }
                }
            }
        }
    }
    self.chatData = [chatData copy];
}

- (void) loginSuccess{
    
    // 登陆成功初始化好友
    [self.delegate getFriendsFromServer];
    // 初始化聊天数据
    [self.delegate initMessageData];
    [self.delegate mqttSub];
    [self createFriendFolder];
//    [self.tableView reloadData];
}

- (void) createFriendFolder{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent: @"/friendAvatar"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL y = YES;
    BOOL fileIsExist = [fileManager fileExistsAtPath: fullPathToFile isDirectory: &y];
    if (fileIsExist) {
        
        [fileManager removeItemAtPath:fullPathToFile error:nil];
    }
    [fileManager createDirectoryAtPath:fullPathToFile withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    
}

- (void) receiveMessage:(NSNotification *)notification{
    
    NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docpath = [docpaths objectAtIndex:0];
    docpath = [docpath stringByAppendingString:@"/chatMessages.plist"];
    NSMutableDictionary *chatDict = [[NSDictionary dictionaryWithContentsOfFile:docpath] mutableCopy];
    
    NSDictionary *dict = [notification userInfo];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    NSArray *keys = [chatDict allKeys];
    NSUInteger result = [keys indexOfObject:dict[@"userId"]];
    NSMutableArray *chatArray;
    if (result == NSNotFound) {
        
        chatArray = [[NSMutableArray alloc] init];
    }else{
        
        chatArray = [chatDict[dict[@"userId"]] mutableCopy];
    }
    NSDictionary *messageDict = @{@"text": dict[@"text"], @"time": currentDateString, @"type": @"1"};
    [chatArray addObject: messageDict];
    
    [chatDict setObject:chatArray forKey:dict[@"userId"]];
    
    [chatDict writeToFile:docpath atomically:YES];
    [self loadData];
    [self.tableView reloadData];
    
    
}

- (void) presentLoginView{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *cv = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginMain"];
    [self presentViewController:cv animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewDidAppear:(BOOL)animated{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCellTableIdentifier" forIndexPath:indexPath];
    
    NSDictionary *rowData = self.chatData[indexPath.row];
    
    cell.name = rowData[@"nickName"];
    cell.msg = rowData[@"text"];
    NSString *time = rowData[@"time"];
    time = [time substringFromIndex:11];
    cell.time = time;
    cell.chatImageView.layer.masksToBounds = YES;
    cell.chatImageView.layer.cornerRadius = 4;
    cell.chatImageView.image = [UIImage imageNamed:@"friend_icon"];
    cell.friendId = rowData[@"friendId"];
    return cell;

    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70.0;
//}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Chat *chatView = [[Chat alloc]init];
    NSDictionary *rowData = self.chatData[indexPath.row];
    chatView.userId = rowData[@"friendId"];
//    chatView.view.frame = self.view.frame;
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];

}
@end
