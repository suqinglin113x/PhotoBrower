//
//  UgcReportContentView.swift
//  jjjj
//
//  Created by 苏庆林 on 2021/1/31.
//

import UIKit

/// 让列间距固定为minimumInteritemSpacing
/// 让列间距固定为minimumInteritemSpacing
class UgcReportFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attris = super.layoutAttributesForElements(in: rect) {
            for (i, att) in attris.enumerated() {
                if i>0 {
                    let cur = att
                    let pre = attris[i-1]
                    let preMaxX = pre.frame.maxX
                    //根据  maximumInteritemSpacing 计算出的新的 x 位置
                    let targetX = preMaxX + self.minimumInteritemSpacing;
                    if targetX < cur.frame.maxX && (targetX+cur.frame.width) < self.collectionViewContentSize.width {
                        var curFrame = cur.frame
                        curFrame.origin.x = targetX
                        cur.frame = curFrame
                    }
                }
            }
            return attris
        }
        return super.layoutAttributesForElements(in: rect)
    }
}



/// 主view ================
/// 主view ================
class UgcReportContentView: UIView, UIGestureRecognizerDelegate {
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contentVH: NSLayoutConstraint!
    var tv: UITextView = UITextView()
    /// 文章、life圈id
    var targetId: String?
    /// 举报来源类型 0：评论举报 1：内容举报
    var targetType: Int = 0 {
        didSet {
            if targetType == 1 {
                contentVH.constant = 430
            }
            self.getData()
        }
    }
    var currentVC: UIViewController!
    var lastSelectIndexPath: IndexPath!
    var dataSource: [UgcReportSectionModel]? = []
    var sectionTitles: [String] = []
    var userSelectedReasonModel: UgcReportEachModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let backBtn = UIButton(type: .custom)
        backBtn.frame = self.frame
        backBtn.addTarget(self, action: #selector(closeMyself), for: .touchUpInside)
        self.insertSubview(backBtn, at: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UgcReportCell.self, forCellWithReuseIdentifier: "UgcReportCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resigh))
//        tap.cancelsTouchesInView = false
        tap.delegate = self
        collectionView.addGestureRecognizer(tap)
        
        
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        for view in collectionView.visibleCells {
            if touch.view?.isDescendant(of: view) == true {
                return false
            }
            
        }
        return true
    }
    @objc func resigh() {
        self.endEditing(true)
    }
    @objc func keyboardUp(noti: NSNotification) {
        let kbInfo = noti.userInfo
         //获取键盘的size
        let kbRect = (kbInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardH = kbRect.size.height
        
            self.frame = CGRect(x: 0, y: -keyBoardH, width: self.bounds.size.width, height: self.bounds.size.height)
        
       

    }
    
    @objc func keyboardDismiss(noti: NSNotification) {
        let kbInfo = noti.userInfo
         //获取键盘的size
        let kbRect = (kbInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        if contentTextView.isFirstResponder {
        self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
//        }
    }
    func getData() {

        let url = fosunholidayHost+"/online/cms-api/reportReasons?type=\(targetType)"
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [unowned self](response) in
            if let res = response as? [String : Any]{
                if let hasError = res["hasError"] as? Bool, hasError{
                    guard let errorMessage = res["errorMessage"] as? String else {
                        return
                    }
                    GlobalUtils.Instance.showToastAddTo(self.currentVC.view, title: errorMessage, duration: 1.5)
                    return
                }
                if let data = res["data"] as? [String: Any], let reportReasons = data["reportReasons"] as? [[String: Any]] {
                    self.dataSource = UgcReportSectionModel.arrWith(dataArr: reportReasons)
                    self.collectionView.reloadData()
                    
                }
            }
        } failure: { (error) in
            
        }

    }
    
    @objc func closeMyself() {
        self.removeFromSuperview()
    }
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func submit(_ sender: Any) {
        if userSelectedReasonModel == nil {
            GlobalUtils.Instance.showToastAddTo(currentVC.view, title: "请选择举报理由", duration: 1.5)
            return
        }
       
        let url = fosunholidayHost+"/online/cms-api/user/contentReport"
        let dict = [
            "targetId": "5f48d4fbe822f1081d3917ad",
            "targetType": targetType,
            "reportReason": userSelectedReasonModel?.key as Any,
            "reportMsg": userSelectedReasonModel?.msg as Any
        ] as [String : Any]
        TCNetworkManager.Instance.post(URLString: url, parameters: dict) { (response) in
            
        } failure: { (error) in
            
        }

        self.contentV.removeFromSuperview()
        self.closeButton.removeFromSuperview()
        let v = UgcReportSuccessView(frame: CGRect(x: 35, y: 0, width: self.bounds.width-35*2, height: 110))
        v.center.y = self.center.y
        self.addSubview(v)
    }
    
   
}

extension UgcReportContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // 处理其他的情况
        if dataSource?.count == 1 {
            if dataSource?[0].reason?.last?.msg == "其他" {
                var model = UgcReportSectionModel(type: "", reason: [])
                let last = dataSource?[0].reason?.last
                model.reason = [last!]
                dataSource?.append(model)
                // 移除之前的位置
                dataSource?[0].reason?.removeLast()
            }
        }
        self.dataSource?.forEach({ (model) in
            sectionTitles.append(model.type ?? "")
        })
        return dataSource?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].reason?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UgcReportCell", for: indexPath) as! UgcReportCell
        let model = dataSource?[indexPath.section].reason?[indexPath.item]
        let str = model?.msg ?? ""
        let isSele = model?.isUserSelected ?? false
        cell.configData(str: str, isSele: isSele)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if lastSelectIndexPath != nil {
            dataSource?[lastSelectIndexPath.section].reason?[lastSelectIndexPath.item].isUserSelected = false
            dataSource?[indexPath.section].reason?[indexPath.item].isUserSelected = true
           
//            let lastCell = collectionView.cellForItem(at: lastSelectIndexPath) as! UgcReportCell
//            lastCell.updateStatus(isSele: false)
//            let curCell = collectionView.cellForItem(at: indexPath) as! UgcReportCell
//            curCell.updateStatus(isSele: true)
            
        } else {
            dataSource?[indexPath.section].reason?[indexPath.item].isUserSelected = true
//            let curCell = collectionView.cellForItem(at: indexPath) as! UgcReportCell
//            curCell.updateStatus(isSele: true)
        }
        collectionView.reloadData()
        lastSelectIndexPath = indexPath
        userSelectedReasonModel = dataSource?[indexPath.section].reason?[indexPath.item]
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let h: CGFloat = 20
        let str = dataSource?[indexPath.section].reason?[indexPath.item].msg ?? ""
        let w = (str as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 13) as Any], context: nil).size.width
        let cellW: CGFloat = 20+5+w
        return CGSize(width: cellW, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataSource?[section].type?.count == 0 {
            return .zero
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 43)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == dataSource!.count-1 {
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            // 脚view
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            if indexPath.section == dataSource!.count-1 {
                tv.frame = CGRect(x: 0, y: 5, width: footer.bounds.width, height: footer.bounds.height-10)
                tv.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                tv.layer.cornerRadius = 5
                tv.delegate = self
                tv.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 0)
                tv.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                tv.font = UIFont(name: "PingFangSC-Regular", size: 13)
                footer.addSubview(tv)
                let placeHoldL = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 13))
                placeHoldL.tag = 100
                placeHoldL.text = "不超过300字"
                placeHoldL.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                placeHoldL.font = UIFont(name: "PingFangSC-Regular", size: 13)
                tv.addSubview(placeHoldL)
                
                
            } else {
                let line = UIView(frame: CGRect(x: 0, y: 0, width: footer.bounds.width, height: 1))
                line.center.y = footer.bounds.height*0.5
                line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
                footer.addSubview(line)
                
            }
            return footer
        } else {
            // 头view
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            let la = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: header.bounds.height))
            la.center.y = header.bounds.height*0.5
            la.text = sectionTitles[indexPath.section]
            la.font = UIFont(name: "PingFangSC-Semibold", size: 13)
            la.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            header.addSubview(la)
            return header
        }
    }
}
extension UgcReportContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let la = textView.viewWithTag(100)
        if textView.text.isEmpty {
            la?.isHidden = false
        } else {
            la?.isHidden = true
        }
        
        // 修改掉举报理由为文本框内容
        userSelectedReasonModel?.msg = textView.text
        
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        let ind = IndexPath(item: 0, section: dataSource!.count-1)
//        let cell = collectionView.cellForItem(at: ind) as! UgcReportCell
//        cell.updateStatus(isSele: true)
//
//
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let indexPath = IndexPath(item: 0, section: dataSource!.count-1)
        dataSource?[indexPath.section].reason?[indexPath.item].isUserSelected = true
        let cell = collectionView.cellForItem(at: indexPath) as! UgcReportCell
        cell.updateStatus(isSele: true)
        if lastSelectIndexPath != nil && lastSelectIndexPath != indexPath {
            dataSource?[lastSelectIndexPath.section].reason?[lastSelectIndexPath.item].isUserSelected = false
            if let preCell = collectionView.cellForItem(at: lastSelectIndexPath) as? UgcReportCell {
                preCell.updateStatus(isSele: false)
            } else {
                self.collectionView.reloadItems(at: [lastSelectIndexPath])
            }
            
           
        }
        
        lastSelectIndexPath = indexPath
        userSelectedReasonModel = dataSource?[indexPath.section].reason?[indexPath.item]
    }
    
}







/// UgcReportCell --- 单元格 =================
/// UgcReportCell --- 单元格 =================
class UgcReportCell: UICollectionViewCell {
    var la: UILabel!
    var iv: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createUI() {
        iv = UIImageView(image: UIImage.init(named: "ugc_report_singleSele"))
        
        self.contentView.addSubview(iv)
        
        la = UILabel()
        la.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        la.font = UIFont(name: "PingFangSC-Regular", size: 13)
        
        self.contentView.addSubview(la)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = self.contentView.bounds.height
        iv.frame = CGRect(x: 0, y: 0, width: w, height: w)
        la.frame = CGRect(x: iv.frame.maxX+5, y: 0, width: self.contentView.bounds.width-(iv.frame.maxX+5), height: w)
    }
    func configData(str: String, isSele: Bool = false) {
        if isSele {
            iv.image = UIImage.init(named: "ugc_report_Selected")
        } else {
            iv.image = UIImage.init(named: "ugc_report_singleSele")
        }
        la.text = str
    }
    func updateStatus(isSele: Bool) {
        if isSele {
            iv.image = UIImage.init(named: "ugc_report_Selected")
        } else {
            iv.image = UIImage.init(named: "ugc_report_singleSele")
        }
    }
}


/// UgcReportSectionModel --- 模型数据 =================
/// UgcReportSectionModel --- 模型数据 =================
struct UgcReportSectionModel: Decodable {
    var type: String?
    var reason: [UgcReportEachModel]? = []
    
    static func arrWith(dataArr: Any) -> [UgcReportSectionModel] {
        var arr: [UgcReportSectionModel] = []
        guard let dataArr = dataArr as? [[String: Any]]  else { return [] }
        dataArr.forEach { (item) in
            
            if let data = try? JSONSerialization.data(withJSONObject: item, options: []) {
                do {
                    let model = try JSONDecoder.init().decode(UgcReportSectionModel.self, from: data)
                    arr.append(model)
                }
                catch {
                    print(error)
                }
            }
        }
        return arr
    }
}

struct UgcReportEachModel: Decodable {
    var key: Int?
    var msg: String?
    
    /// 额外属性
    var isUserSelected: Bool?
}


















/// 举报成功 view ==============
/// 举报成功 view ==============
fileprivate class UgcReportSuccessView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backBtn = UIButton(type: .custom)
        backBtn.frame = self.frame
        backBtn.addTarget(self, action: #selector(closeMyself), for: .touchUpInside)
        self.insertSubview(backBtn, at: 0)
        
        self.createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {

        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        let contentL = UILabel()
        contentL.text = "举报成功，平台会在24小时内\n处理你的举报信息。"
        contentL.font = UIFont(name: "PingFangSC-Regular", size: 14)
        contentL.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        contentL.textAlignment = .center
        contentL.numberOfLines = 2
        self.addSubview(contentL)
        contentL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentL.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            contentL.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            contentL.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35),
            contentL.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        let cloBtn = UIButton(type: .custom)
        cloBtn.translatesAutoresizingMaskIntoConstraints = false
        cloBtn.addTarget(self, action: #selector(closeMyself), for: .touchUpInside)
        cloBtn.setImage(UIImage.init(named: "hotel_order_close_white"), for: .normal)
        self.addSubview(cloBtn)
        NSLayoutConstraint.activate([
            cloBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            cloBtn.widthAnchor.constraint(equalToConstant: 35),
            cloBtn.heightAnchor.constraint(equalToConstant: 35),
            cloBtn.bottomAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    @objc func closeMyself() {
        self.superview?.removeFromSuperview()
    }
}
