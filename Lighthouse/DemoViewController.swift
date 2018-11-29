//
//  DemoViewController.swift
//  Lighthouse
//
//  Created by Shirley Zhou on 11/25/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import paper_onboarding

class DemoViewController: UIViewController {
  
  //outlets
  //@IBOutlet weak var demoObj: DemoViewClass!
  
  @IBOutlet var skipButton: UIButton!
  
  fileprivate let items = [
    OnboardingItemInfo(informationImage: Asset.welcome.image,
                       title: "hi there! welcome.",
                       description: "we try to not just mitigate your attacks but also help you learn more about them! \n let’s walk through it together.",
                       pageIcon: Asset.key.image,
                       color: UIColor(red:0.65, green:0.76, blue:0.93, alpha:1.0),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    OnboardingItemInfo(informationImage: Asset.logicon.image,
                       title: "log view",
                       description: "here, you can view a log of your episodes",
                       pageIcon: Asset.wallet.image,
                        color: UIColor(red:0.95, green:0.73, blue:0.17, alpha:1.0),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    OnboardingItemInfo(informationImage: Asset.stores.image,
                       title: "Lighthouse 3",
                       description: "All local stores are categorized for your convenience",
                       pageIcon: Asset.shoppingCart.image,
                       color: UIColor(red:0.33, green:0.44, blue:0.62, alpha:1.0),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    ]

    override func viewDidLoad() {
      super.viewDidLoad()
      
      skipButton.isHidden = true
    
      setupPaperOnboardingView()
      
      view.bringSubview(toFront: skipButton)
      
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
       }
  
  private func setupPaperOnboardingView() {
    let onboarding = PaperOnboarding()
    onboarding.delegate = self
    onboarding.dataSource = self
    onboarding.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(onboarding)
    
    // Add constraints
    for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
      let constraint = NSLayoutConstraint(item: onboarding,
                                          attribute: attribute,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: attribute,
                                          multiplier: 1,
                                          constant: 0)
      view.addConstraint(constraint)
    }
  }

}

// MARK: Actions

extension DemoViewController {
  
  @IBAction func skipButtonTapped(_: UIButton) {
    print(#function)
  }
}
extension DemoViewController: PaperOnboardingDelegate {

  func onboardingWillTransitonToIndex(_ index: Int) {
    skipButton.isHidden = index == 2 ? false : true
  }
  
  func onboardingDidTransitonToIndex(_: Int) {
  }
  
  func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
    //item.titleLabel?.backgroundColor = .redColor()
    //item.descriptionLabel?.backgroundColor = .redColor()
    //item.imageView = ...
  }
  
  
}

extension DemoViewController: PaperOnboardingDataSource {
  
  //  func onboardingItem(at index: Int) -> OnboardingItemInfo {
  //    let bgOne: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
  //    let descriptionColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  //    let image: UIImage = #imageLiteral(resourceName: "panic_button")
  //    let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
  //    let subFont = UIFont(name: "HelveticaNeue", size: 14)!
  //
  //    return [OnboardingItemInfo(informationImage: image ,
  //                               title: "title",
  //                               description: "description alkdsfjasldf",
  //                               pageIcon: image,
  //                               color: bgOne,
  //                               titleColor: bgOne,
  //                               descriptionColor: descriptionColor,
  //                               titleFont: titleFont,
  //                               descriptionFont: subFont)][0]
  //  }
  //
  //  func onboardingItemsCount() -> Int {
  //    return 1
  //  }
  //
  
  
  func onboardingItem(at index: Int) -> OnboardingItemInfo {
    return items[index]
  }
  
  func onboardingItemsCount() -> Int {
    return 3
  }
  
  //    func onboardinPageItemRadius() -> CGFloat {
  //        return 2
  //    }
  //
  //    func onboardingPageItemSelectedRadius() -> CGFloat {
  //        return 10
  //    }
  //    func onboardingPageItemColor(at index: Int) -> UIColor {
  //        return [UIColor.white, UIColor.red, UIColor.green][index]
  //    }
}

//MARK: Constants
extension DemoViewController {
  
  private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
  private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
