

import UIKit

protocol PresentDelegate : class{
//需要外部传入开始动画的尺寸,结束动画的尺寸,执行动画的图片
    func presentEndRect(indexPath : NSIndexPath) ->CGRect
    func presentStartRect(indexPath : NSIndexPath) ->CGRect
    func presentAnimationView(indexPath : NSIndexPath) ->UIImageView
    func presentAnimationViewBackgroundImage()->UIImage
    
}
protocol DismissDelegate : class{
//需要获取当前的indexPath以及图片
    func dismissAnimationView() ->UIImageView
    func dismissIndexPath()->NSIndexPath
}

class FXDGTransformAnimation: NSObject {
    var ispresent : Bool = false
    var animationDuration : NSTimeInterval = 2
    weak var presentDelegate : PresentDelegate?
    weak var dismissDelegate : DismissDelegate?
    var indexPath : NSIndexPath?

}
extension FXDGTransformAnimation : UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = false
        return self
    }
}

extension FXDGTransformAnimation :UIViewControllerAnimatedTransitioning{
//执行时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        ispresent ? animateForPresentView(transitionContext) : animateForDismissView(transitionContext)
    }
    func animateForPresentView(transitionContext: UIViewControllerContextTransitioning){
    //出现动画
        //执行动画前判断
        guard let indexPath = indexPath else{
        return
        }
        guard let presentDelegate = presentDelegate else {
        return
        }
        //(获得控制器的View)
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let dismissView = UIImageView(image:presentDelegate.presentAnimationViewBackgroundImage())

        //为了让原来的界面看上去像没有消失,需要将获得的view添加到transitionContext上
        transitionContext.containerView()?.addSubview(presentedView!)
        transitionContext.containerView()?.addSubview(dismissView)
        //开始动画
        let animationView = presentDelegate.presentAnimationView(indexPath)
        animationView.frame = presentDelegate.presentStartRect(indexPath)
        transitionContext.containerView()?.addSubview(animationView)
        //为了最后界面是黑色的底纹需改变containerView的颜色
        presentedView!.alpha = 0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        //动画执行过程
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
            animationView.frame = presentDelegate.presentEndRect(indexPath)
            dismissView.alpha = 0
            }) { (Boolfinish) -> Void in

                presentedView!.alpha = 1
                dismissView.removeFromSuperview()
                animationView.removeFromSuperview()
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }

    }
    func animateForDismissView(transitionContext: UIViewControllerContextTransitioning){
        // 1.取出消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        dismissView.removeFromSuperview()
        
        // 2.执行动画
        // 2.1.获取执行动画的imageView
        guard let dismissDelegate = dismissDelegate else {
            return
        }
        guard let presentDelegate = presentDelegate else {
            return
        }
        let imageView = dismissDelegate.dismissAnimationView()
        transitionContext.containerView()?.addSubview(imageView)
        
        // 2.2.获取当前正在显示的indexPath
        let indexPath = dismissDelegate.dismissIndexPath()
        
        // 2.3.设置起始位置
        imageView.frame = presentDelegate.presentEndRect(indexPath)
        
        // 2.4.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentDelegate.presentStartRect(indexPath)
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}