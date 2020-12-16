//
//  TCTicketProductHeader.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/10.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import SDCycleScrollView
let kScale: CGFloat = (UIScreen.main.bounds.width/375.0)

class TCTicketProductHeader: UIView {//cycleH+325

    @IBOutlet weak var cycleView: SDCycleScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLConstraintH: NSLayoutConstraint!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var tagsViewConstraintH: NSLayoutConstraint!
    var tagLabelArray: [UIButton] = []

    @IBOutlet weak var adBannerViewConstraintH: NSLayoutConstraint!
    @IBOutlet weak var adBannerIV: UIImageView!
    
    @IBOutlet weak var cmsViewConstraintH: NSLayoutConstraint!
    @IBOutlet weak var cmsImageView: UIImageView!
    
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var finalLineView: UIView!
    var refreshHeaderHeight: ((_ height: CGFloat) -> ())?
    
    var cmsModelArr: [TCCMSModel]? = []
    
    lazy var pageControlBtn: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .black
        button.isUserInteractionEnabled = false
        button.alpha = 0.6
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        button.layer.cornerRadius = 8 // 圆角
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "image_list"), for: .normal)
        let spacing: CGFloat = 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        return button
    }()
    lazy var codeLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = .black
        label.alpha = 0.6
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        label.layer.cornerRadius = 8 // 圆角
        label.layer.masksToBounds = true
        label.textColor = .white
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cycleView.delegate = self
        cycleView.placeholderImage = UIImage.init(named: "image_rect_default")
        
       
            
    }
    
    
    func configBaseInfoData(baseInfo: TCBaseInfo) {
        
        cycleView.showPageControl = false
        cycleView.autoScrollTimeInterval = 4
        cycleView.bannerImageViewContentMode = .scaleAspectFill
        cycleView.imageURLStringsGroup = baseInfo.productImageInfos?.map({$0.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) as Any})
        
        cycleView.addSubview(pageControlBtn)
        pageControlBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(cycleView).offset(15)
            make.bottom.equalTo(cycleView.snp.bottom).offset(-10)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(50)
        }
        cycleView.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(pageControlBtn)
            make.width.greaterThanOrEqualTo(75)
            make.leading.equalTo(pageControlBtn.snp.trailing).offset(5)
        }
        codeLabel.text = baseInfo.productCode
        
        var tagList: [String] = []
        baseInfo.productTagList?.forEach({ (tagInfo) in
            tagList.append(tagInfo.producttagname ?? "")
        })
        
        let title = baseInfo.productName
        let height = title?.boundingRect(with: CGSize(width: titleLabel.bounds.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:titleLabel.font as Any], context: nil).size.height
        self.titleLConstraintH.constant = height ?? 0
        titleLabel.text = title
        configTagsData(data: tagList)
        
        self.getMaxHeight()
    }
    
    /// 创建tags
    func configTagsData(data: [String]) {
        var tagsViewH: CGFloat = 0
        
        let height: CGFloat = 20.0
        let space: CGFloat = 3
        let originY: CGFloat = 10
        for title in data {
            
            let width = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-regular", size: 12)!], context: nil).size.width + 10
            
            let lastBtn = tagLabelArray.last
            let nextBtn = self.createButton(title: title)
            var x: CGFloat = (lastBtn?.frame.origin.x ?? 0) + (lastBtn?.bounds.size.width ?? 0)+((lastBtn != nil) ? space : 0)
            var y: CGFloat = lastBtn?.frame.origin.y ?? originY
            if (x + width) > (tagsView.bounds.size.width) {
                y += height + space
                x = 0
            }
            tagsViewH = y+height
            nextBtn.frame = CGRect(x: x, y: y, width: width, height: height)
            tagLabelArray.append(nextBtn)
            tagsView.addSubview(nextBtn)
            
        }
        tagsViewConstraintH.constant = tagsViewH
        self.frame.size.height += tagsViewH
    }

    func configAdBannerData(model: TCAdBannerModel) {
        if model.activityUrl?.count ?? 0 > 0 {
            adBannerIV.sd_setImage(with: URL(string: "https://i02piccdn.sogoucdn.com/143f0a88137d5ad1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: nil, options: []) { (image, error, cacheType, url) in
                self.getMaxHeight()
            }
        } else {
            self.frame.size.height -= adBannerViewConstraintH.constant
            adBannerViewConstraintH.constant = 0
            adBannerIV.removeFromSuperview()
            
            self.getMaxHeight()
        }
    }
    
    func configCmsData(_ modelArr: [TCCMSModel]) {
        cmsModelArr = modelArr
        if modelArr.count == 0 {
            self.frame.size.height -= cmsViewConstraintH.constant
            cmsViewConstraintH.constant = 0
            return
        }
        let firstModel = modelArr.first
        cmsImageView.sd_setImage(with: URL(string: firstModel?.themePicUri ?? ""), placeholderImage: nil, options: [], completed: { (image, error, type, url) in
            self.getMaxHeight()
        })
        let cmsTap = UITapGestureRecognizer(target: self, action: #selector(cmsTapAction))
        cmsImageView.addGestureRecognizer(cmsTap)
        
        
    }
    
    func configCouponData(couponArr: [TCCouponModel]) {
        
        let height: CGFloat = 15
        var x: CGFloat = 50
        var width: CGFloat = 0
        let font = UIFont(name: "PingFangSC-Regular", size: 10)
        
        for i in 0..<2 {
            let cpName = couponArr[i].couponStr as NSString?
            x += (width)
            let width1 = cpName?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font as Any], context: nil).size.width ?? 0
              width = width1+15
            if i>0 {
                x+=5
            }
            
            let coupon1 = CGView(frame: CGRect(x: x, y: 0, width: width, height: height))
            couponView.addSubview(coupon1)
            coupon1.text = cpName as String?
            coupon1.textAlignment = .center
            coupon1.textColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
            coupon1.font = font
            
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(couponTapAction))
        couponView.addGestureRecognizer(tap)
        
        self.getMaxHeight()
    }
    
}

// MARK: UI
extension TCTicketProductHeader {
    
    /// 获取最终高度
    func getMaxHeight() {
        self.layoutIfNeeded()
        let maxY = self.finalLineView.frame.maxY
        print(maxY)
        self.frame.size.height = maxY
        if self.refreshHeaderHeight != nil {
            self.refreshHeaderHeight!(maxY)
        }
    }
    func createButton(title: String) -> UIButton {
        let font = UIFont(name: "PingFangSC-regular", size: 12)
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.23, green: 0.53, blue: 0.95, alpha: 1), for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }
    
    @objc func clickButton() {
        debugPrint("标签点击")
    }
    
    @objc func cmsTapAction() {
        let bgView = UIButton(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        bgView.addTarget(self, action: #selector(closeCmsView), for: .touchUpInside)
        UIApplication.shared.windows[0].addSubview(bgView)
        let contentView = UIView(frame: CGRect(x: 0, y: bgView.bounds.height-184*kScale - 30, width: bgView.bounds.width, height: 184*kScale + 30))
        contentView.backgroundColor = .white
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        contentView.layer.mask = mask
        bgView.addSubview(contentView)
        let imv = UIImageView(frame: CGRect(x: 0, y: 30, width: bgView.bounds.width, height: 184*kScale))
        imv.backgroundColor = .white
        imv.sd_setImage(with: URL(string: cmsModelArr?.last?.themePicUri ?? ""), placeholderImage: nil)
        contentView.addSubview(imv)
    }
    @objc func closeCmsView(btn: UIButton) {
        btn.removeFromSuperview()
    }
    
    @objc func couponTapAction() {
        debugPrint("展示优惠券列表")
    }
}

extension TCTicketProductHeader: SDCycleScrollViewDelegate {
    func cycleScrollViewDidScroll(_ scrollView: UIScrollView!, index: Int) {
        
        pageControlBtn.setTitle(" \(index+1)/\(cycleView.imageURLStringsGroup.count) ", for: .normal)
    }
}
