//
// Created by Sergei Dorozhkin on 03.01.2021.
//

import UIKit

class TransitionNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    let interactiveTransition = CustomInteractiveTransition()
}

extension TransitionNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController:
            UIViewControllerAnimatedTransitioning)
                    -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil }


    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation:
            UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
                    -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push:
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimatorX()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimatorX()
        default:
            return nil
        }
    }
}

final class CustomPushAnimatorX: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame

        let translate = CGAffineTransform(translationX: 150, y: source.view.frame.width + 200)
        let rotate = CGAffineTransform(rotationAngle: -45)
        destination.view.transform = translate.concatenating(rotate)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModePaced,
                animations: {
                    UIView.addKeyframe(
                            withRelativeStartTime: 0,
                            relativeDuration: 0.75,
                            animations: {
                                let translation = CGAffineTransform(translationX: -100,y: 300)
                                let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                source.view.transform = translation.concatenating(scale)
                            })
                    UIView.addKeyframe(
                            withRelativeStartTime: 0.2,
                            relativeDuration: 0.8,
                            animations: {
                                destination.view.transform = .identity
                            })
                }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

final class CustomPopAnimatorX: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)

        destination.view.frame = source.view.frame

        let translation = CGAffineTransform(translationX: -100,y: 300)
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        destination.view.transform = translation.concatenating(scale)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModePaced,
                animations: {
                    UIView.addKeyframe(
                            withRelativeStartTime: 0.4,
                            relativeDuration: 0.4,
                            animations: {
                                let translate = CGAffineTransform(translationX: 150, y: source.view.frame.width + 200)
                                let rotate = CGAffineTransform(rotationAngle: -.pi/2)
                                source.view.transform = translate.concatenating(rotate)
                            })
                    UIView.addKeyframe(
                            withRelativeStartTime: 0.25,
                            relativeDuration: 0.75,
                            animations: {
                                destination.view.transform = .identity
                            })
                }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(
                    target: self,
                    action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x /
                    ( (recognizer.view?.bounds.width ?? 1) / 10 )
            let progress = max(0, min(1, relativeTranslation))
            self.shouldFinish = progress > 0.15
            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
}


