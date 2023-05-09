//
//  snapshot.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation
import WebKit

var imgArr: [UIImage] = []

//https://blog.csdn.net/qq_38863196/article/details/126361878
extension WKWebView {
    func snapshot2(complete:@escaping ((UIImage?) -> Void)) {
        scrollView.setContentOffset(.zero, animated: false)
        createSnapshot(offsetY: 0, remainingOffset: scrollView.contentSize.height, completion: complete)
    }
    
    func createSnapshot(offsetY: CGFloat, remainingOffset: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        if remainingOffset > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                UIGraphicsBeginImageContextWithOptions(self.frame.size, true, UIScreen.main.scale)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                self.layer.render(in: context)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                imgArr.append(img!)
                let newOffsetY = offsetY + self.frame.size.height
                let newReoffsetY = remainingOffset - self.frame.size.height
                self.createSnapshot(offsetY: newOffsetY, remainingOffset: newReoffsetY, completion: completion)
            }
        } else {
            let containerView = UIView(frame: CGRect(origin: .zero, size: scrollView.contentSize))
            var originYOfImgView: CGFloat = 0
            for i in imgArr {
                let imgV = UIImageView(image: i)
                imgV.frame = CGRect(x: 0, y: originYOfImgView, width: frame.width, height: frame.height)
                originYOfImgView += frame.height
                containerView.addSubview(imgV)
            }
            superview?.addSubview(containerView)
            
            let img = containerView.snapshopImg()
            containerView.removeFromSuperview()
            completion(img)
            imgArr.removeAll()
        }
    }
}

extension UIView {
    func snapshopImg() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}


extension UIScrollView {
    public func takeScreenshotOfFullContent(_ completion: @escaping ((UIImage?) -> Void)) {
        // 分页绘制内容到ImageContext
        let originalOffset = self.contentOffset

        // 当contentSize.height<bounds.height时，保证至少有1页的内容绘制
        var pageNum = 1
        if self.contentSize.height > self.bounds.height {
            pageNum = Int(floorf(Float(self.contentSize.height / self.bounds.height)))
        }

        let backgroundColor = self.backgroundColor ?? UIColor.white

        UIGraphicsBeginImageContextWithOptions(self.contentSize, true, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            completion(nil)
            return
        }
        context.setFillColor(backgroundColor.cgColor)
        context.setStrokeColor(backgroundColor.cgColor)

        self.drawScreenshotOfPageContent(0, maxIndex: pageNum) {
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.contentOffset = originalOffset
            completion(image)
        }
    }

    fileprivate func drawScreenshotOfPageContent(_ index: Int, maxIndex: Int, completion: @escaping () -> Void) {

        self.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * self.frame.size.height), animated: false)
        let pageFrame = CGRect(x: 0, y: CGFloat(index) * self.frame.size.height, width: self.bounds.size.width, height: self.bounds.size.height)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.drawHierarchy(in: pageFrame, afterScreenUpdates: true)

            if index < maxIndex {
                self.drawScreenshotOfPageContent(index + 1, maxIndex: maxIndex, completion: completion)
            }else{
                completion()
            }
        }
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

