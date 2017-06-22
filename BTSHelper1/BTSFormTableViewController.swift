//
//  BTSFormTableViewController.swift
//  BTSHelper1
//
//  Created by Valera_IMac on 18.06.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

import UIKit
import MessageUI

class BTSFormTableViewController: UITableViewController {
    var issue: Issue? = nil
    var attachments: [Attachment] = [Attachment]()
    var selectedIssueType: String? = "Bug"
    var selectedPriority: String? = "Medium"
    
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var attachmentsCollectionView: UICollectionView!
    @IBOutlet weak var issueTypeTableViewCell: UITableViewCell!
    @IBOutlet weak var priorityTableViewCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.issueTypeTableViewCell.detailTextLabel?.text = selectedIssueType
        self.priorityTableViewCell.detailTextLabel?.text = selectedPriority
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0) , size: CGSize(width: 100, height: 100)))
        self.activityIndicator?.center = self.view.center
        self.activityIndicator?.startAnimating()
        self.activityIndicator?.isHidden = true
        self.view.addSubview(self.activityIndicator!)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoggedIn()
        
        self.setNavigationItems()
    }
    
    func setNavigationItems() {
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(BTSFormTableViewController.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        let createBtn = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.done, target: self, action: #selector(BTSFormTableViewController.sendIssue))
        self.navigationItem.rightBarButtonItem = createBtn
    }

    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkLoggedIn() {
        if !APIManager.shared.isAuthorized() {
            let sb = UIStoryboard(name: "BTSHelper", bundle: nil)
            let signupVC = sb.instantiateViewController(withIdentifier: "SigninVC")
            self.navigationController?.present(signupVC, animated: true, completion: nil)
        }
    }
    
    func sendIssue() {
        if self.summaryTextField.isFirstResponder {
            self.summaryTextField.resignFirstResponder()
        }
        if self.descriptionTextView.isFirstResponder {
            self.descriptionTextView.resignFirstResponder()
        }
        
        if (self.descriptionTextView.text.isEmpty) || self.selectedPriority == nil || self.selectedIssueType == nil {
            self.displayAlertMessage(alertTitle: "Fields required", alertDescription: "Some of fields are empty")
        } else {
            self.activityIndicator?.isHidden = false
            
            self.issue = APIManager.shared.createIssue()
            APIManager.shared.sendIssue(issue: issue!, sender: self, completion: { (error, response) in
                if error != nil {
                    self.displayAlertMessage(alertTitle: "Error", alertDescription: error!.localizedDescription)
                } else {
                    if response is UIViewController {
                        if response is MFMailComposeViewController {
                            let mail = response as! MFMailComposeViewController
                            mail.mailComposeDelegate = self
                        }
                        self.present(response as! UIViewController, animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
}


extension BTSFormTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func displayImagePickerControl() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) { 
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let attachment = Attachment(filename: "screenshot\(self.attachments.count+1)", mimeType: .imagePng, attachmentData: UIImagePNGRepresentation(img)!)
            self.attachments.append(attachment)
            self.attachmentsCollectionView.reloadData()
        }
    }
}

extension BTSFormTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.displayImagePickerControl()
        }
    }
}

extension BTSFormTableViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attachments.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCollectionViewCell", for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCollectionViewCell", for: indexPath)
            
            let imgIndex = indexPath.row - 1
            let imgView = UIImageView(frame: cell.contentView.frame)
            imgView.image = UIImage(data: self.attachments[imgIndex].attachmentData)!
            
            cell.contentView.addSubview(imgView)
        }
        
        return cell
    }
}


extension BTSFormTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
