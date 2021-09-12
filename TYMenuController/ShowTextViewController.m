//
//  ShowTextViewController.m
//  TYMenuController
//
//  Created by TY on 2021/9/8.
//

#import "ShowTextViewController.h"

#define kSCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define kSCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define isPhoneX [self isIPhoneX]

@interface ShowTextViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UIMenuController *menuController;
@property (nonatomic, assign) BOOL isAutoShowMenu;
@property (nonatomic, copy) NSString *selectedText;

@end

@implementation ShowTextViewController

- (BOOL)isIPhoneX {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom > 0;
    }
    return NO;
}

- (void)dealloc {
    if (self.isAutoShowMenu) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isAutoShowMenu = YES;
    [self handleContent];
    if (self.isAutoShowMenu) {
        [self.contentTV becomeFirstResponder];
        if (self.contentTV.text.length > 1) {
            self.contentTV.selectedRange = NSMakeRange(0, 2);
        }else {
            self.contentTV.selectedRange = NSMakeRange(0, self.contentTV.text.length);
        }
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MenuFrameDidChangeNoti:) name:UIMenuControllerMenuFrameDidChangeNotification object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isAutoShowMenu) {
        CGFloat selectedTextWidth = [self getStringWidthWithText:self.selectedText font:[UIFont systemFontOfSize:26]];
        CGFloat offsetX = -(kSCREEN_WIDTH/2-selectedTextWidth/2-20); //改变箭头位置
        CGFloat offsetY = self.contentTV.textContainerInset.top;
        if (self.contentTV.contentSize.height > kSCREEN_HEIGHT) {
            offsetY = -10;
        }
        if (@available(iOS 13.0, *)) {
            [self.menuController showMenuFromView:self.contentTV rect:CGRectMake(offsetX, offsetY, self.contentTV.bounds.size.width, 45)];
        }else {
            self.menuController.menuVisible = YES;
            [self.menuController setTargetRect:CGRectMake(offsetX, offsetY, self.contentTV.bounds.size.width, 45) inView:self.contentTV];
        }
    }
}

/*
- (void)MenuFrameDidChangeNoti:(NSNotification *)notifi {
    NSLog(@"菜单位置开始改变了");
    //不在主线程会崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat selectedTextWidth = [self getStringWidthWithText:self.selectedText font:[UIFont systemFontOfSize:26]];
        CGFloat offsetX = -(kSCREEN_WIDTH/2-selectedTextWidth/2-20); //改变箭头位置
        CGFloat offsetY = self.contentTV.textContainerInset.top;
        if (self.contentTV.contentSize.height > kSCREEN_HEIGHT) {
            offsetY = -10;
        }
        if (@available(iOS 13.0, *)) {
            [self.menuController showMenuFromView:self.contentTV rect:CGRectMake(offsetX, offsetY, self.contentTV.bounds.size.width, 45)];
        }else {
            [self.menuController setTargetRect:CGRectMake(offsetX, offsetY, self.contentTV.bounds.size.width, 45) inView:self.contentTV];
        }
    });
}
*/

//为了在页面消失时，隐藏菜单
- (void)hideMenuView {
    if (self.menuController.menuVisible) {
        if (@available(iOS 13.0, *)) {
            [self.menuController hideMenuFromView:self.contentTV];
        }else {
            self.menuController.menuVisible = NO;
        }
    }
}

- (void)handleContent {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.contentTV.text];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26],
                                    NSForegroundColorAttributeName:[UIColor blackColor]}
                            range:NSMakeRange(0, attributeString.length)];
    self.contentTV.attributedText = attributeString;

    CGFloat textHeight = [self getStringHeightWithText:self.contentTV.text font:[UIFont systemFontOfSize:26] viewWidth:(kSCREEN_WIDTH-30)];
    CGFloat contentHeght = self.contentTV.frame.size.height;
    
    if (textHeight < contentHeght) {
        self.contentTV.textContainerInset = UIEdgeInsetsMake((contentHeght-textHeight)/2, 15, (contentHeght-textHeight)/2, 15);
    }else{
        self.contentTV.textContainerInset = UIEdgeInsetsMake(0, 15, 0 ,15);
    }
    
    UIMenuItem *note = [[UIMenuItem alloc] initWithTitle:@"自定义" action:@selector(customMenuItemClick:)];
    self.menuController = [UIMenuController sharedMenuController];
    [self.menuController setMenuItems:[NSArray arrayWithObject:note]];
    if (!self.isAutoShowMenu) {
        if (@available(iOS 13.0, *)) {
            [self.menuController showMenuFromView:self.contentTV rect:self.contentTV.frame];
        }else {
            [self.menuController setMenuVisible:NO animated:YES];
            [self.menuController setTargetRect:self.contentTV.frame inView:self.contentTV];
        }
    }
        
    [self.view addSubview:self.contentTV];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeText)];
    [self.contentTV addGestureRecognizer:singleTap];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(customMenuItemClick:)) {
        if (self.contentTV.selectedRange.length > 0) {
            return YES;
        }
    }
    return NO;
}

-(void)removeText {
    [self hideMenuView];
    [self dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self hideMenuView];
    self.selectedText = [textView textInRange:textView.selectedTextRange];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideMenuView];
}

//自定义
- (void)customMenuItemClick:(id)sender {
    NSLog(@"点击了自定义菜单");
}

//获取文本高度
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName:font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font {
    // 设置文字属性要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName:font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, 35);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    // 当你是把获得的宽度来布局控件的View的高度的时候.size转化为ceilf(size.width)。
    return  ceilf(size.width);
}

- (UITextView *)contentTV {
    if (!_contentTV) {
        _contentTV = [[UITextView alloc] initWithFrame:CGRectMake(0,isPhoneX?44:20,kSCREEN_WIDTH,isPhoneX?(kSCREEN_HEIGHT-44-34):(kSCREEN_HEIGHT-20))];
        _contentTV.font = [UIFont systemFontOfSize:26];
        _contentTV.textColor = [UIColor blackColor];
        _contentTV.delegate = self;
        _contentTV.editable = NO;
        _contentTV.text = @"所谓日落，关键是日落需要如何写。了解清楚日落到底是一种怎么样的存在，是解决一切问题的关键。而这些并不是完全重要，更加重要的问题是，罗素·贝克曾经提到过，一个人即使已登上顶峰，也仍要自强不息。这不禁令我深思。卡耐基曾经说过，一个不注意小事情的人，永远不会成就大事业。带着这句话，我们还要更加慎重的审视这个问题: 所谓日落，关键是日落需要如何写。日落因何而发生？既然如此，要想清楚，日落，到底是一种怎么样的存在。既然如此，生活中，若日落出现了，我们就不得不考虑它出现了的事实。日落，发生了会如何，不发生又会如何。一般来讲，我们都必须务必慎重的考虑考虑。日落的发生，到底需要如何做到，不日落的发生，又会如何产生。";
    }
    return _contentTV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
