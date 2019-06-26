//
//  CFDetailViewController.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/26.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit
import WebKit

class CFDetailViewController: CFBaseController,UITableViewDelegate,UITableViewDataSource,CFCycleScrollViewDataSource,WKNavigationDelegate {
    
    var tableView: UITableView!
    //闭包-类似于oc中的block
    var addActionWithBlock: (() ->())?
    var scrollViewDidScroll_Closure: ((UIScrollView) ->())?
    var bigView: UIView!
    var webView: WKWebView!
    var tempScrollView: UIScrollView!
    var cycleView: CFCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setBgUI()
        setHeaderAndFooterView()
        setBottomView()
    }
    
    func setBgUI() {
        
        //存放tableView和webView，tableview在上面，webview在下面
        bigView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (SCREEN_HEIGHT - TABBAR_HEIGHT) * 2))
        bigView.backgroundColor = UIColor.white
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TABBAR_HEIGHT))
        tableView.backgroundColor = UIColor.white;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //去掉顶部偏移
        if #available(iOS 11.0, *)
        {
            tableView.contentInsetAdjustmentBehavior = .never;
        }
        
        webView = WKWebView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TABBAR_HEIGHT))
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        view.addSubview(bigView)
        bigView.addSubview(tableView)
        bigView.addSubview(webView)
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
        }
    }
    
    func setHeaderAndFooterView() {
        //添加头部和尾部视图
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        headerView.backgroundColor = UIColor.white
        
        tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        headerView.addSubview(tempScrollView)
        
        cycleView = CFCycleScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        cycleView.dataSource = self;
        tempScrollView.addSubview(cycleView)
        
        tableView.tableHeaderView = headerView
        
        let pullMsgView = UILabel.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        pullMsgView.textAlignment = .center
        pullMsgView.text = "上拉显示网页"
        pullMsgView.textColor = UIColor.gray
        
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        footView.addSubview(pullMsgView)
        
        tableView.tableFooterView = footView
        
        //设置下拉提示视图
        let downPullMsgView = UILabel.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        downPullMsgView.textAlignment = .center
        downPullMsgView.text = "下拉显示列表"
        downPullMsgView.textColor = UIColor.gray
        
        let downMsgView = UIView.init(frame: CGRect(x: 0, y: -40, width: SCREEN_WIDTH, height: 40))
        downMsgView.addSubview(downPullMsgView)
        webView.scrollView.addSubview(downMsgView)
    }
    
    func setBottomView() {
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: TABBAR_HEIGHT))
        bottomView.backgroundColor = BACKGROUND_VIEW_COLOR;
        self.view.addSubview(bottomView)
        
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: bottomView.mj_w/2, y: 0, width: bottomView.mj_w/2, height: TABBAR_HEIGHT)
        addButton.backgroundColor = UIColor.red;
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        addButton.setTitle("加入购物车", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        bottomView.addSubview(addButton)
    }
    
    @objc func addAction() {
        addActionWithBlock?()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y;
        
        if scrollView == tableView{
            //重新赋值，就不会有用力拖拽时的回弹
            tempScrollView.contentOffset = CGPoint(x: tempScrollView.contentOffset.x, y: 0)
            if offset >= 0 && offset <= SCREEN_WIDTH {
                //因为tempScrollView是放在tableView上的，tableView向上速度为1，实际上tempScrollView的速度也是1，此处往反方向走1/2的速度，相当于tableView还是正向在走1/2，这样就形成了视觉差！
                tempScrollView.contentOffset = CGPoint(x: tempScrollView.contentOffset.x, y: -offset / 2)
            }
        }
        
        scrollViewDidScroll_Closure?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y;
        if scrollView == tableView {
            if offset > tableView.contentSize.height - SCREEN_HEIGHT + TABBAR_HEIGHT + 50 {
                
                UIView.animate(withDuration: 0.4) {
                    self.bigView.transform = self.bigView.transform.translatedBy(x: 0, y: -SCREEN_HEIGHT + TABBAR_HEIGHT + STATUS_AND_NAV_BAR_HEIGHT)
                }
            }
        }
        if scrollView == webView.scrollView {
            if offset < -50 {
                UIView.animate(withDuration: 0.4) {
                    self.bigView.transform = self.bigView.transform.translatedBy(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT)
                }
            }
        }
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel?.text = "哈哈哈哈哈"
        return cell!
    }
    
    // MARK: - CFCycleScrollViewDataSource
    func getImagesWithArray() -> Array<Any> {
        return ["commodity_1","commodity_2","commodity_3","commodity_4","commodity_5"]
    }
    
    // MARK: - wkWebView
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载...")
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        print("当内容开始返回...")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("页面加载完成...")
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print("页面加载失败...")
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
