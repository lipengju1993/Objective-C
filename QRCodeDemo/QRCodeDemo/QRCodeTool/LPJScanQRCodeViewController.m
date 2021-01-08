//
//  LPJScanQRCodeViewController.m
//  QRCodeDemo
//
//  Created by lipengju on 2021/1/7.
//

#import "LPJScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define LPJ_SCAN_WIDTH 270
#define LPJ_SCAN_MARGIN 10

@interface LPJScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) UIImageView *scanLineView;
@property (nonatomic, strong) UIImageView *scanBorderView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign, getter=isMoveUp) BOOL moveUp;
@property (nonatomic, assign) NSInteger num;
@end

@implementation LPJScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createSubviews];
    [self createSubLayers];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}

- (void)createSubviews {
    UIImageView *scanBorderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LPJ_SCAN_WIDTH, LPJ_SCAN_WIDTH)];
    scanBorderView.center = self.view.center;
    scanBorderView.image = [UIImage imageNamed:@"scan_border"];
    [self.view addSubview:scanBorderView];
    
    UIImageView *scanLineView = [[UIImageView alloc] initWithFrame:CGRectMake(scanBorderView.frame.origin.x, scanBorderView.frame.origin.y + LPJ_SCAN_MARGIN, scanBorderView.frame.size.width, 2)];
    scanLineView.image = [UIImage imageNamed:@"scan_line"];
    [self.view addSubview:scanLineView];
    
    self.scanBorderView = scanBorderView;
    self.scanLineView = scanLineView;
    self.moveUp = false;
    self.num = 0;
    __weak __typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf moveLineAction];
    }];
}

- (void)moveLineAction {
    if (self.isMoveUp) {
        self.num--;
        if (self.num == 0) {
            self.moveUp = false;
        }
    } else {
        self.num++;
        if (self.num * 2 >= LPJ_SCAN_WIDTH-LPJ_SCAN_MARGIN*2 ) {
            self.moveUp = true;
        }
    }
    CGRect frame = self.scanBorderView.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y + LPJ_SCAN_MARGIN + self.num * 2, frame.size.width, 2);
    self.scanLineView.frame = newFrame;
}

- (void)createSubLayers {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, self.scanBorderView.frame);
    CGPathAddRect(path, nil, self.view.bounds);
    [layer setFillRule:kCAFillRuleEvenOdd];
    [layer setPath:path];
    [layer setFillColor:[UIColor blackColor].CGColor];
    [layer setOpacity:0.6];
    [layer setNeedsDisplay];
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)setupCamera {
    // Device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头，无法使用此功能。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // Output
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat top = self.scanBorderView.frame.origin.y / screenHeight;
    CGFloat left = self.scanBorderView.frame.origin.x / screenWidth;
    CGFloat width = LPJ_SCAN_WIDTH / screenWidth;
    CGFloat height = LPJ_SCAN_WIDTH / screenHeight;
    ///top 与 left 互换  width 与 height 互换
    [output setRectOfInterest:CGRectMake(top,left, height, width)];

    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    // Start
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        //停止扫描
        [self.session stopRunning];
        [self.timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.session != nil && self.timer != nil) {
                [self.session startRunning];
                [self.timer setFireDate:[NSDate date]];
            }

        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
