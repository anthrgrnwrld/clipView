//
//  ViewController.swift
//  ClipView
//
//  Created by Masaki Horimoto on 2015/11/19.
//  Copyright © 2015年 Masaki Horimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clipSegControl: UISegmentedControl!
    
    //clipTypeをenumで定義しておく(一個だけだが練習)
    enum clipType :Int {
        case type100x100
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "mountain.jpg")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     対象のViewを指定したrectで切り取りUIImageとして取得する

     - parameter view:切り取り対象のview
     - parameter rect:切り取る座標と大きさ
     - returns: 切り取り結果を返す
    */
    func clipView(view: UIView?, rect: CGRect?) -> UIImage? {
        
        guard let targetView = view else {
            return nil
        }
        
        guard let frameRect = rect else {
            return nil
        }
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(frameRect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        //Affine変換
        let affineMoveLeftTop = CGAffineTransformMakeTranslation(-frameRect.origin.x, -frameRect.origin.y)
        CGContextConcatCTM(context, affineMoveLeftTop)
        
        // 対象のview内の描画をcontextに複写する.
        targetView.layer.renderInContext(context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return clippedImage
    }

    /**
     SegControlが押下された時に呼ばれる
    */
    @IBAction func pressClipSegControl(sender: AnyObject) {
        
        var rect: CGRect?       //切り取るrect値格納用
        
        //セグコントロールとclipTypeを紐付け。そしてその値がnilになる場合(= Non Clip)には元のイメージを表示する
        let clipValues : [clipType?] = [nil, .type100x100]
        
        guard let clipValue = clipValues[clipSegControl.selectedSegmentIndex] else {
            imageView.image = UIImage(named: "mountain.jpg")
            return
        }
        
        //セグコントロールが.type100x100(= Clip(100x100))の時、それに従ったrectの値を入れる
        switch clipValue {
        case .type100x100:
            rect = CGRectMake(137, 284, 100, 100)
        }
        
        //imageViewからframeRectで切り取り、結果をUIImageで取得する
        guard let clippedImage = clipView(imageView, rect: rect) else {
            imageView.image = UIImage(named: "mountain.jpg")
            return
        }
        
        //切り取り結果を拡大表示
        imageView.image = clippedImage
        
        
    }

}

