//
//  CFDetailInfoController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/26.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFDetailInfoController: CFBaseController,CFSegmentedControlDataSource,CFSegmentedControlDelegate,UIScrollViewDelegate {
    
    var narrowedModalView: LPSemiModalView!//透视效果动画视图
    var segmentedControl: CFSegmentedControl!
    var bgScrollView: UIScrollView!
    var segmentTitles: Array<String>!
    var detailViewController: CFDetailViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.modalPresentationStyle = .custom
        segmentTitles = ["详情","活动","其他"]
        navigationBgView.backgroundColor = UIColor.white;
        navigationBgView.alpha = 0;
        setSegmentedControl()
        showLeftBackButton()
        setBgScrollview();
        setShadowAnimationView();
        setDetailView();
    }
    
    func setSegmentedControl() {
        
        //注意宽度要留够，不然title显示不完，title宽度是计算出来的。代码并不复杂，可以根据需要去内部进行修改
        segmentedControl = CFSegmentedControl.init(frame: CGRect(x: Int(SCREEN_WIDTH/2) - (60 * segmentTitles.count)/2, y: Int(STATUS_AND_NAV_BAR_HEIGHT - 40), width: 60 * segmentTitles.count, height: 40))
        segmentedControl.delegate = self
        segmentedControl.dataSource = self
        segmentedControl.alpha = 0
        navigationView.addSubview(segmentedControl)
        
    }
    
    func setBgScrollview() {
        
        bgScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgScrollView.delegate = self
        bgScrollView.showsVerticalScrollIndicator = false
        bgScrollView.showsHorizontalScrollIndicator = false
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH * CGFloat(segmentTitles.count), height: SCREEN_HEIGHT)
        bgScrollView.isPagingEnabled = true
        bgScrollView.bounces = false
        self.view.addSubview(bgScrollView)
        //去掉顶部偏移
        if #available(iOS 11.0, *)
        {
            bgScrollView.contentInsetAdjustmentBehavior = .never;
        }
    }
    
    func setShadowAnimationView() {

        narrowedModalView = LPSemiModalView.init(size: CGSize(width: SCREEN_WIDTH, height: 300), andBaseViewController: navigationController)
        narrowedModalView.contentView.backgroundColor = UIColor.white
        
        let label = UILabel.init(frame: CGRect(x: narrowedModalView.contentView.mj_w/2 - 50, y: 100, width: 100, height: 20))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "暂无内容"
        narrowedModalView.contentView.addSubview(label)
    
    }
    
    func setDetailView() {
        
        //这里为了避免该控制器耦合性高的问题，所以使用addChildViewController的形式，来添加视图
        //详情
        
        detailViewController = CFDetailViewController()
        self.addChild(detailViewController)
        detailViewController.didMove(toParent: self)
        detailViewController.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgScrollView.addSubview(detailViewController.view)
        
        //swift闭包循环引用的问题：unowned表示确认当前闭包self不会提前释放；weak表示当前闭包self有可能会出现提前释放的情况，详细解释请查看官方文档
        detailViewController.scrollViewDidScroll_Closure = {[unowned self] (scrollView:UIScrollView)  in
            if scrollView == self.detailViewController.tableView{
                
                if scrollView.mj_offsetY > 0 && scrollView.mj_offsetY < 60 {
                    
                    self.navigationBgView.alpha = 1 * (scrollView.mj_offsetY / 60)
                    self.segmentedControl.alpha = self.navigationBgView.alpha
                }
                else if scrollView.mj_offsetY <= 0
                {
                    self.navigationBgView.alpha = 0
                    self.segmentedControl.alpha = self.navigationBgView.alpha
                }
                else if scrollView.mj_offsetY > 40
                {
                    if self.navigationBgView.alpha != 1 {
                        self.navigationBgView.alpha = 1
                        self.segmentedControl.alpha = self.navigationBgView.alpha
                    }
                }
                
            }
            
        }
        
        detailViewController.addActionWithBlock = {[unowned self] in
            self.narrowedModalView.open()
        }
        
        let activityController = CFActivityController()
        self.addChild(activityController)
        activityController.didMove(toParent: self)
        activityController.view.frame = CGRect(x: SCREEN_WIDTH, y: 140, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 300)
        bgScrollView.addSubview(activityController.view)
        
        let othersController = CFOthersController()
        self.addChild(othersController)
        othersController.didMove(toParent: self)
        othersController.view.frame = CGRect(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgScrollView.addSubview(othersController.view)
        
    }
    
    // MARK: - SegmentedControl Method
    func getSegmentedControlTitles() -> Array<Any> {
        return segmentTitles
    }
    
    func control(_ control: CFSegmentedControl, didSelectAt Index: Int) {
        bgScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(Index), y: 0), animated: true)
    }
    
    // MARK: - UIScrollView Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView {
            
            let index = scrollView.mj_offsetX/SCREEN_WIDTH;
            
            segmentedControl.didSelect(index: Int(index));
            if index == 0 {
                if detailViewController.tableView.mj_offsetY >= 0 && detailViewController.tableView.mj_offsetY < 60 {
                    UIView.animate(withDuration: 0.25) {
                        self.navigationBgView.alpha = 1 * (self.detailViewController.tableView.mj_offsetY / 60);
                        self.segmentedControl.alpha = self.navigationBgView.alpha;
                    }
                }
            }
            else if index >= 1
            {
                UIView.animate(withDuration: 0.25) {
                    self.navigationBgView.alpha = 1;
                    self.segmentedControl.alpha = self.navigationBgView.alpha;
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
