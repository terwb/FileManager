//
//  FileManagerController.m
//  FileManager
//
//  Created by Mikhail on 14.02.2025.
//

#import "FileManagerController.h"

@interface FileManagerController ()
@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSArray* contents;

@end

@implementation FileManagerController

- (id)initWithFolderPath:(NSString *)path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
        NSError *error = nil;
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.path lastPathComponent];
}

- (BOOL)isDirectoryAtIndexPath:(NSIndexPath *)indexPath {
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:fileName] isDirectory:&isDirectory];
    return isDirectory;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    BOOL isFile = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:fileName] isDirectory:&isFile];
    
    cell.textLabel.text = fileName;
    if ([self isDirectoryAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
    }
    return cell;
}

#pragma mark - Table view delegate navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* path = [self.path stringByAppendingPathComponent:fileName];
        FileManagerController* vc = [[FileManagerController alloc] initWithFolderPath:path];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
