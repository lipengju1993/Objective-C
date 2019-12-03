//
//  ViewController.m
//  UseCoreData
//
//  Created by lipengju on 2019/12/3.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

static NSString *entityName = @"Person";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    
    [self createSqlite];
    
    [self queryAllData];
}

// 创建数据库
- (void)createSqlite {
    
    // 1.创建模型对象
    // 获取模型路径
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSLog(@"modelUrl: %@", modelUrl);
    // 根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    // 2.创建持久化存储助理：数据库
    // 利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 数据库的名称和路径
    NSString *docStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
    NSLog(@"数据库 path = %@ ", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error;
    // 设置数据库相关信息，添加一个持久化存储库并设置存储类型和路径
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    if (error) {
        NSLog(@"添加数据库失败： %@", error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    // 创建上下文， 保存信息， 操作数据库
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 关联持久化助理
    context.persistentStoreCoordinator = store;
    
    _context = context;
    
}

// 查询所有数据
- (void)queryAllData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *resArray = [self.context executeFetchRequest:request error:nil];
    self.dataSource = [NSMutableArray arrayWithArray:resArray];
    
    [self.tableView reloadData];
}

// 插入数据
- (void)insertData {
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Person
    Person *per = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
    
    //  2.根据表Person中的键值，给NSManagedObject对象赋值
    per.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
    per.age = arc4random()%20;
    
    // 查询所有数据请求
    [self queryAllData];
    
    // 3.保存插入的数据源
    NSError *error;
    if ([_context save:&error]) {
        [self alertViewWithMessage:@"数据插入到数据库成功"];
    }else{
        [self alertViewWithMessage:[NSString stringWithFormat:@"数据插入到数据库失败, %@",error]];
    }
}

// 删除数据
- (void)deleteData {
    // 创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 创建条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < 7"];
    request.predicate = pre;
    
    // 查询
    NSArray *resArray = [self.context executeFetchRequest:request error:nil];
    
    // 遍历，从数据库中删除
    for (Person *per in resArray) {
        [self.context deleteObject:per];
    }
    
    // 查询所有数据
    [self queryAllData];
    
    NSError *error = nil;
    //保存--记住保存
    if ([_context save:&error]) {
        [self alertViewWithMessage:@"删除 age < 7 的数据"];
    }else{
        NSLog(@"删除数据失败, %@", error);
    }
}

// 根据筛选条件，查询数据
- (void)queryData {
    // 创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 10];
    request.predicate = pre;
    
    // 分页处理， 每页显示的条数
    //request.fetchLimit = 2;
    
    // 发送查询请求，并返回结果
    NSArray *resArray = [self.context executeFetchRequest:request error:nil];
    self.dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    [self alertViewWithMessage:@"查询所有年龄小于10岁的"];
}

// 更新数据
- (void)updateData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"Mr-77"];
    request.predicate = pre;
    
    //发送请求
    NSArray *resArray = [self.context executeFetchRequest:request error:nil];
    
    //修改
    for (Person *per in resArray) {
        per.name = @"帅气依旧";
    }
    self.dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    //保存
    NSError *error = nil;
    if ([_context save:&error]) {
        [self alertViewWithMessage:@"更改数据 name为Mr-77，改为 帅气依旧"];
    }else{
        NSLog(@"更新数据失败, %@", error);
    }
}

// 按条件，排序
- (void)sortData {
    //创建排序请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
    request.sortDescriptors = @[ageSort];
    
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [_context executeFetchRequest:request error:&error];
    
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    if (error == nil) {
        [self alertViewWithMessage:@"按照age排序"];
    }else{
        NSLog(@"排序失败, %@", error);
    }
}


- (IBAction)insertData:(UIButton *)sender {
    [self insertData];
}


- (IBAction)deleteData:(UIButton *)sender {
    [self deleteData];
}

- (IBAction)updateData:(UIButton *)sender {
    [self updateData];
}

// 查询数据
- (IBAction)queryData:(UIButton *)sender {
    [self queryData];
}

// 排序数据
- (IBAction)sortData:(UIButton *)sender {
    [self sortData];
}

- (void)alertViewWithMessage:(NSString *)message{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
    
    [NSThread sleepForTimeInterval:0.5];
        
    [alert dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Person * per = self.dataSource[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"2.jpg"];
    cell.textLabel.text = [NSString stringWithFormat:@" name = %@ \n age = %d", per.name, per.age];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



@end
