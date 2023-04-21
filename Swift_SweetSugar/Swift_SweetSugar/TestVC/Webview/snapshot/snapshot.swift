//
//  snapshot.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    func snapshot2(complete:((UIImage) -> Void)?) {
        
    }
}
/// 对WKWebView进行长截图（没有规避H5悬浮栏）
/// @param webView 需要进行截图的webView
/// @param completionHandler 截图完成回调
// - (void)snapshotForWKWebView:(WKWebView *)webView CaptureCompletionHandler:(void (^)(UIImage * _Nonnull))completionHandler {
//    //1.添加遮罩层
//    UIView *snapshotView = [webView snapshotViewAfterScreenUpdates:YES];
//    snapshotView.frame = webView.frame;
//    [webView.superview addSubview:snapshotView];
//    //2.初始化数组
//    self.imgArr = [NSMutableArray array];
//    //3.进行截图操作
//    CGPoint savedCurrentContentOffset = webView.scrollView.contentOffset;
//    webView.scrollView.contentOffset = CGPointZero;
//    [self createSnapshotForWKWebView:webView offset:0.0 remainingOffset_y:webView.scrollView.contentSize.height comletionBlock:^(UIImage *snapshotImg) {
//        webView.scrollView.contentOffset = savedCurrentContentOffset;
//        [snapshotView removeFromSuperview];
//        completionHandler(snapshotImg);
//    }];
//}

/// 绘制WKWebView长截图
/// @param webView 所需要截图的WebView
/// @param offset_y 当前scollView的y偏移量
/// @param reOffset_y 剩余scollView的y偏移量
/// @param completeBlock 回调块
//- (void)createSnapshotForWKWebView:(WKWebView *)webView offset:(float)offset_y remainingOffset_y:(float)reOffset_y comletionBlock:(void(^)(UIImage *snapshotImg))completeBlock
//{
//    //判断scrollView是否已经滚动到底
//    if (reOffset_y>0) {
//        //设置
//        [webView.scrollView setContentOffset:CGPointMake(0, offset_y) animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
//            //对页面进行截图操作
//            UIGraphicsBeginImageContextWithOptions(webView.frame.size, YES, [UIScreen mainScreen].scale);
//            [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            //将截图添加进数组
//            [self.imgArr addObject:img];
//            //修改offsetY偏移量
//            CGFloat newOffset_y = offset_y + webView.scrollView.frame.size.height;
//            CGFloat newReOffset_y = reOffset_y - webView.frame.size.height;
//            [self createSnapshotForWKWebView:webView offset:newOffset_y remainingOffset_y:newReOffset_y comletionBlock:completeBlock];
//
//        });
//    }else {
//        //合成截图为最终截图
//        UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, webView.frame.size.width, webView.scrollView.contentSize.height)];
//        CGFloat originYOfImgView = 0;
//        for (int i = 0; i<self.imgArr.count; i++) {
//            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originYOfImgView, webView.frame.size.width, webView.frame.size.height)];
//            UIImage * img = self.imgArr[i];
//            imgView.image = img;
//            originYOfImgView += webView.frame.size.height;
//            [containerView addSubview:imgView];
//        }
//        //添加合成视图
//        [webView.superview addSubview:containerView];
//        //处理最终合并截图
//        UIGraphicsBeginImageContextWithOptions(containerView.frame.size, YES, [UIScreen mainScreen].scale);
//        [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        //移除合成视图
//        [containerView removeFromSuperview];
//        //返回截图
//        if (completeBlock) {
//            completeBlock(img);
//        }
//    }
//}

