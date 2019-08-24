//
//  EEDetailVC.m
//  EERSSReader
//
//  Created by fengyi on 2019/4/1.
//  Copyright © 2019 橙晓侯. All rights reserved.
//

#import "EEDetailVC.h"
//#import <WebKit/WebKit.h>

@interface EEDetailVC ()

@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *webSuperView;
@property (strong, nonatomic) NSString *url;
@end

@implementation EEDetailVC

#pragma mark show方法
+ (void)showWithURL:(NSString *)url from:(UIViewController *)superVC
{
    EEDetailVC *vc = [[EEDetailVC alloc] initWithNibName:@"EEDetailVC" bundle:nil];
    vc.url = url;
    [superVC presentViewController:vc animated:0 completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    _webView = [[UIWebView alloc] init];
    [_webSuperView addSubview:_webView];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.webSuperView);
//    }];
    [_webView loadRequest:request];
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = 1;
    
}
- (IBAction)back:(id)sender
{
    [_webView goBack];
}

- (IBAction)onRefresh:(id)sender
{
    [_webView reload];
}

- (IBAction)forward:(id)sender
{
    [_webView goForward];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
