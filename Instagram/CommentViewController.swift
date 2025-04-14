//
//  CommentViewController.swift
//  Instagram
//
//  Created by 杉下実和子 on 2025/04/14.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseFirestore

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    var postId: String!  // HomeViewController から渡される
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleSendCommentButton(_ sender: Any) {
        // postId, name, commentText が nil または空の場合は return
        guard let postId = postId,
              let name = Auth.auth().currentUser?.displayName,
              let commentText = commentTextField.text,
              !commentText.isEmpty else {
            print("必要な情報が足りません（postId, name, comment）")
            SVProgressHUD.showError(withStatus: "コメントが入力されていません")
            return
        }

        let commentData: [String: String] = [
            "name": name,
            "comment": commentText
        ]
        // 保存場所を定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postId)

        // Firestoreのcomments配列にコメントを追加（arrayUnionで重複防止されつつ追加）
        postRef.updateData([
            "comments": FieldValue.arrayUnion([commentData])
        ]) { error in
            if let error = error {
                print("コメントの保存に失敗: \(error)")
                SVProgressHUD.showError(withStatus: "コメントの保存に失敗しました")
            } else {
                print("コメントを保存しました！")
                SVProgressHUD.showSuccess(withStatus: "コメントを送信しました")
                self.dismiss(animated: true, completion: nil)  // モーダルを閉じる
            }
        }
    }
}
