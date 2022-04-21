//
//  ViewController.m
//  TestMMKVSize
//
//  Created by klaus on 2022/4/21.
//

#import "ViewController.h"
#import <MMKV/MMKV.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) MMKV *mmkv;
@property (nonatomic, strong) NSString *mmkvFilePath;
@property (nonatomic, strong, readonly) NSString *mmkvFileSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.editable = NO;
    
    [self.mmkv clearAll];
    [self appendLog:[NSString stringWithFormat:@"mmkv 版本 %@ 初始文件大小 %@", [MMKV version], self.mmkvFileSize]];
}

- (IBAction)textAction:(id)sender {
    NSData *data = [[NSMutableData alloc] initWithLength:1024];
    NSInteger count = 1000;
    for (NSInteger i = 0; i < count; i++) {
        [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data1_%ld", i]];
    }
    [self appendLog:[NSString stringWithFormat:@"写入 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    for (NSInteger i = 0; i < count; i++) {
        [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data1_%ld", i]];
    }
    [self appendLog:[NSString stringWithFormat:@"修改之前 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    // ----------------------
    for (NSInteger j = 0; j < 500; j++) {
        for (NSInteger i = 0; i < count; i++) {
            [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data1_%ld", i]];
        }
    }
    [self appendLog:[NSString stringWithFormat:@"修改 500 次之前的 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    [self.mmkv trim];
    [self appendLog:[NSString stringWithFormat:@"mmkv trim 后的文件大小 %@", self.mmkvFileSize]];
    // ----------------------
    data = [[NSMutableData alloc] initWithLength:2048];
    for (NSInteger i = 0; i < count; i++) {
        [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data1_%ld", i]];
    }
    [self appendLog:[NSString stringWithFormat:@"修改之前 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    [self.mmkv trim];
    [self appendLog:[NSString stringWithFormat:@"mmkv trim 后的文件大小 %@", self.mmkvFileSize]];
    // ----------------------
    [self appendLog:@""];
    data = [[NSMutableData alloc] initWithLength:3072];
    for (NSInteger i = 0; i < count; i++) {
        [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data2_%ld", i]];
    }
    [self appendLog:[NSString stringWithFormat:@"新写入 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    data = [[NSMutableData alloc] initWithLength:1024];
    for (NSInteger j = 0; j < 200; j++) {
        for (NSInteger i = 0; i < count; i++) {
            [self.mmkv setData:data forKey:[NSString stringWithFormat:@"data2_%ld", i]];
        }
    }
    [self appendLog:[NSString stringWithFormat:@"修改 200 次之前的 %ld 个 key，value size = %ld 的数据后的文件大小 %@", count, data.length, self.mmkvFileSize]];
    [self.mmkv trim];
    [self appendLog:[NSString stringWithFormat:@"mmkv trim 后的文件大小 %@", self.mmkvFileSize]];
}

- (void)appendLog:(NSString *)log {
    self.textView.text = [self.textView.text stringByAppendingFormat:@"- %@\n", log ?: @""];
    
    if (self.textView.contentSize.height > self.textView.frame.size.height) {
        [self.textView setContentOffset:CGPointMake(0, self.textView.contentSize.height - self.textView.frame.size.height) animated:YES];
    }
}

- (NSString *)mmkvFileSize {
    size_t mmkvSize = [self.mmkv totalSize];
    if (mmkvSize >= 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.1fG", (CGFloat)mmkvSize / (1024.0 * 1024.0 * 1024.0)];
    } else if (mmkvSize >= 1024 * 1024) {
        return [NSString stringWithFormat:@"%.1fM", (CGFloat)mmkvSize / (1024.0 * 1024.0)];
    } else if (mmkvSize >= 1024) {
        return [NSString stringWithFormat:@"%.1fK", (CGFloat)mmkvSize / 1024.0];
    }
    return [NSString stringWithFormat:@"%zu", mmkvSize];
}

- (MMKV *)mmkv {
    if (!_mmkv) {
        _mmkv = [MMKV defaultMMKV];
    }
    return _mmkv;
}

@end
