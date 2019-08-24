//
//  EEDetailVC.m
//  EERSSReader
//
//  Created by fengyi on 2019/4/1.
//  Copyright © 2019 橙晓侯. All rights reserved.
//

#import "EEDetailVC.h"
#import "AFNetworking.h"
#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface EEDetailVC ()

@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *webSuperView;
@property (strong, nonatomic) NSString *url;
@end

@implementation EEDetailVC

#pragma mark show
+ (void)showWithURL:(NSString *)url from:(UIViewController *)superVC
{
    EEDetailVC *vc = [[EEDetailVC alloc] initWithNibName:@"EEDetailVC" bundle:nil];
    vc.url = url;
    [superVC presentViewController:vc animated:0 completion:nil];
}

#pragma mark Network Test
+ (void)testFrom:(UIViewController *)superVC
{
    [self request:@"https://api.github.com/repos/feng520ckx/CustomNavigationBar" needCallBack:0 from:superVC];
    [self request:@"https://api.github.com/repos/chengxiaohou/RReader" needCallBack:1 from:superVC];
    [self request:@"https://api.github.com/repos/molon/MLTransition" needCallBack:0 from:superVC];
    [self request:@"https://api.github.com/repos/yscMichael/YYButton" needCallBack:0 from:superVC];
}

+ (void)request:(NSString *)url needCallBack:(BOOL)need from:(UIViewController *)superVC
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *branchName = dic[@"default_branch"];
        NSString *blog = dic[@"blog"];
        if (need) {
            // jump
            if (branchName.length > 0 && ![branchName containsString:@"master"]) {
                
                NSString *newURL = [NSString stringWithFormat:@"https://api.github.com/users/%@",branchName];
                [self request:newURL needCallBack:1 from:superVC];
            }
            // done
            if ([blog containsString:@"http"])
            {
                [EEDetailVC showWithURL:blog from:superVC];
            }
        }
    } failure:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    _webView = [[UIWebView alloc] init];
    _webView.frame = self.webSuperView.bounds;
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
