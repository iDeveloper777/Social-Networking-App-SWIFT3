//
//  InformationViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 12/30/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import MessageUI

class InformationViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_Information: UITextView!
    
    var strTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_Title.text = strTitle
        
        txt_Information.textAlignment = .center
        txt_Information.isUserInteractionEnabled = true
        txt_Information.dataDetectorTypes = .link
        txt_Information.isSelectable = true
        txt_Information.isEditable = false
        
        loadTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func loadTextView(){
        if (strTitle == "TERMS OF SERVICES"){
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            paragraph.lineSpacing = 3
            let stringTest = "Terms Of Service"
            let agreeAttributedString = NSMutableAttributedString(string: stringTest, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSRange(location: 0, length: agreeAttributedString.length))
            let paragraph1 = NSMutableParagraphStyle()
            paragraph1.alignment = .left
            paragraph1.lineSpacing = 3
            
            let stringTest1: String = "\n\nPlease read these Terms of Service carefully before using.\nThe www.mymotiff.com , www.mymotiff.co.uk website and my-mo mobile application (the \"Service\") operated by My Motiff \n\nYour access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.\n\n By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the Terms then you may not access the Service.\n\n Content \n\n Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material (\"Content\"). You are responsible for the Content that you post to the Service, including its legality, reliability, and appropriateness.\n\n By posting Content to the Service, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through the Service. You retain any and all of your rights to any Content you submit, post or display on or through the Service and you are responsible for protecting those rights. You agree that this license includes the right for us to make your Content available to other users of the Service, who may also use your Content subject to these Terms.\n\n You represent and warrant that: (i) the Content is yours (you own it) or you have the right to use it and grant us the rights and license as provided in these Terms, and (ii) the posting of your Content on or through the Service does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person.\n\n Accounts \n\n When you create an account with us, you must provide us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account with our Service.\n\n You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service.\n\n You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.\n\nYou may not use as a username the name of another person or entity or that is not lawfully available for use, a name or trade mark that is subject to any rights of another person or entity other than you without appropriate authorization, or a name that is otherwise offensive, vulgar or obscene. You expressly agree that we cannot be held liable for any loss or damage arising out of any misrepresentations you make in this regard.\n\nIntellectual Property\nThe Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of my-mo and its licensors. The Service is protected by copyright, trademark, and other laws of both the United Kingdom and foreign countries. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of my-mo.\n\nWhen you upload content, you give my-mo a worldwide, non-exclusive, royalty-free, transferable licence (with right to sub-licence) to use, reproduce, distribute, prepare derivative works of, display, and perform that Content in connection with the provision of the Service and otherwise in connection with the provision of the Service and my-mo business.\n\nLinks To Other Web Sites\n\nOur Service may contain links to third-party web sites or services that are not owned or controlled by Mymotiff.\n\nmy-mo has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that my-mo shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n\nWe strongly advise you to read the terms and conditions and privacy policies of any third-party web sites or services that you visit.\n\nTermination\n\nWe may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n\nUpon termination, your right to use the Service will immediately cease. If you wish to terminate your account, you may simply discontinue using the Service.\n\nAll provisions of the Terms which by their nature should survive termination shall survive termination, including,without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.\n\nIndemnification\n\nYou agree to defend, indemnify and hold harmless my-mo and its licensee and licensors, and their employees, contractors, agents, officers and directors, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney's fees), resulting from or arising out of a) your use and access of the Service, by you or any person using your account and password; b) a breach of these Terms, or c) Content posted on the Service.\n\nLimitation Of Liability\n\nIn no event shall my-mo, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the Service; (ii) any conduct or content of any third party on the Service; (iii) any content obtained from the Service; and (iv) unauthorized access, use or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence) or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose.\n\nDisclaimer\n\nYour use of the Service is at your sole risk. The Service is provided on an \"AS IS\" and \"AS AVAILABLE\" basis. The Service is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance.\n\nmy-mo and its subsidiaries, affiliates, and its licensors do not warrant that a) the Service will function uninterrupted, secure or available at any particular time or location; b) any errors or defects will be corrected; c) the Service is free of viruses or other harmful components; or d) the results of using the Service will meet your requirements.\n\nExclusions\n\nWithout limiting the generality of the foregoing and notwithstanding any other provision of these Terms, under no circumstances will my-mo ever be liable to you or any other person for any indirect, incidental, consequential, special, punitive or exemplary loss or damage arising from, connected with, or relating to your use of the Service, these Terms, the subject matter of these Terms, the termination of these Terms or otherwise, including but not limited to personal injury, loss of data, business, markets, savings, income, profits, use, production, reputation or goodwill, anticipated or otherwise, or economic loss, under any theory of liability (whether in contract, tort, strict liability or any other theory or law or equity), regardless of any negligence or other fault or wrongdoing (including without limitation gross negligence and fundamental breach) by my-mo or any person for whom my-mo is responsible, and even if my-mo has been advised of the possibility of such loss or damage being incurred.\n\nGoverning Law\n\nThese Terms shall be governed and construed in accordance with the laws of England and Wales, without regard to its conflict of law provisions.\n\nOur failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have between us regarding the Service.\n\nChanges\n\nWe reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\nBy continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new Terms, you must stop using the service.\n\nPrivacy Policy and Cookie Policy\n\nPlease refer to our Privacy Policy and Co okies Policy. You agree that they constitute part of these Terms. You must read our Privacy Policy and Cookies Policy before you use the Service.\n\nContact Us\nIf you have any questions about these Terms, please contact us.";
            let agreeAttributedString1 = NSMutableAttributedString(string: stringTest1, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraph1, range: NSRange(location: 0, length: agreeAttributedString1.length))
            agreeAttributedString.append(agreeAttributedString1)
            txt_Information.attributedText = agreeAttributedString
        }else if (strTitle == "PRIVACY POLICY"){
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            paragraph.lineSpacing = 3
            let StringTest: String = "My Motiff operates the www.mymotiff.com, www.mymotiff.co.uk website and the my-mo mobile application (the \"Service\") \n\nThis page informs you of our policies regarding the collection, use and disclosure of Personal Information when you use our Service.\n\nWe will not use or share your information with anyone except as described in this Privacy Policy.\n\nWe use your Personal Information for providing and improving the Service. By using the Service, you agree to the collection and use of information in accordance with this Privacy Policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.\n\nInformation Collection And Use\n\nWhile using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to, your email address, name, phone number, postal address, other information (\"Personal Information\").\n\nLog Data\n\nWe collect information that your browser sends whenever you visit our Service (\"Log Data\"). This Log Data may include information such as your computer's Internet Protocol (\"IP\") address, browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages and other statistics.\n\nIn addition, we may use third party services such as Google Analytics that collect, monitor and analyse this type of information in order to increase our Service's functionality. These third party service providers have their own Privacy Policies addressing how they use such information.\n\nWhen you access the Service by or through a mobile device, we may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use and other statistics\n\nLocation information\n\nWe may use and store information about your location, if you give us permission to do so. We use this information to provide features of our Service, to improve and customise our Service. You can enable or disable location services when you use our Service at anytime, through your mobile device setti\n\nCookies\n\nCookies are files with small amounts of data, which may include an anonymous unique identifier. Cookies are sent to your browser from a web site and stored on your computer's hard drive.\n\nWe use \"cookies\" to collect information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service. \n\nService Providers\n\nWe may employ third party companies and individuals to facilitate our Service, to provide the Service on our behalf, to perform Service-related services or to assist us in analysing how our Service is used.\n\nThese third parties have access to your Personal Information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.\n\nBusiness Transaction\n\nIf my-mo is involved in a merger, acquisition or asset sale, your Personal Information may be transferred. We will provide notice before your Personal Information is transferred and becomes subject to a different Privacy Policy. In the event of such a transfer of information, your rights under the Data Protection Act 1998 are not affected.\n\nSecurity\n\nThe security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security. As such we make no warranties as to the level of security afforded to your data, except that we will always act in accordance with the relevant UK and EU legislation.\n\nInternational Transfer\n\nYour information, including Personal Information, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.\n\nIf you are located outside United Kingdom and choose to provide information to us, please note that we transfer the information, including Personal Information, to United Kingdom and process it there.\n\nYour consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.\n\nIn the event that a dispute arises with regards to the international transfer of data, you agree that the courts of England and Wales shall have exclusive jurisdiction over the matter.\n\nLinks To Other Sites\n\nOur Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.\n\nWe have no control over, and assume no responsibility for the content, Privacy Policies or practices of any third party sites or services.\n\nChildren's Privacy\n\n    Our Service does not address anyone under the age of 13 (\"Children\").\n\nWe do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your Children has provided us with Personal Information, please contact us. If we become aware that we have collected Personal Information from a child under age 13 without verification of parental consent, we take steps to remove that information from our servers.\n\nChanges To This Privacy Policy\n\nWe may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.\n\nIf we make any material changes to this Privacy Policy, we will notify you either through the email address you have provided us, or by placing a prominent notice on our website.\n\nJurisdiction"
            let agreeAttributedString = NSMutableAttributedString(string: StringTest, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSRange(location: 0, length: agreeAttributedString.length))
            txt_Information.attributedText = agreeAttributedString
        }else if (strTitle == "SUPPORT"){
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            paragraph.lineSpacing = 3
            let stringTest = "Creating Your Account And Username"
            let agreeAttributedString = NSMutableAttributedString(string: stringTest, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSRange(location: 0, length: agreeAttributedString.length))
            let paragraph1 = NSMutableParagraphStyle()
            paragraph1.alignment = .left
            paragraph1.lineSpacing = 3
            let stringTest1: String = "\nTo get started, you will need to download the my-mo app from the iTunes app Store for iOS or from the Google Play Store for Android.\nOnce this has been successfully completed please follow steps below.\n 1. On the Login screen, tap"
            
            let agreeAttributedString1 = NSMutableAttributedString(string: stringTest1, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraph1, range: NSRange(location: 0, length: agreeAttributedString1.length))
            agreeAttributedString.append(agreeAttributedString1)
            
            let paragraph16 = NSMutableParagraphStyle()
            paragraph16.alignment = .left
            paragraph16.lineSpacing = 3
            let stringTest16 = " ‘Sign Up for my-mo"
            let agreeAttributedString16 = NSMutableAttributedString(string: stringTest16, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString16.addAttribute(NSParagraphStyleAttributeName, value: paragraph16, range: NSRange(location: 0, length: agreeAttributedString16.length))
            agreeAttributedString.append(agreeAttributedString16)
            
            let paragraph17 = NSMutableParagraphStyle()
            paragraph17.alignment = .left
            paragraph17.lineSpacing = 3
            let stringTest17 = "\n2. Tap the field that says"
            let agreeAttributedString17 = NSMutableAttributedString(string: stringTest17, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString17.addAttribute(NSParagraphStyleAttributeName, value: paragraph17, range: NSRange(location: 0, length: agreeAttributedString17.length))
            agreeAttributedString.append(agreeAttributedString17)
            
            let paragraph18 = NSMutableParagraphStyle()
            paragraph18.alignment = .left
            paragraph18.lineSpacing = 3
            let stringTest18 = "'Email'"
            let agreeAttributedString18 = NSMutableAttributedString(string: stringTest18, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString18.addAttribute(NSParagraphStyleAttributeName, value: paragraph18, range: NSRange(location: 0, length: agreeAttributedString18.length))
            agreeAttributedString.append(agreeAttributedString18)
            
            let paragraph19 = NSMutableParagraphStyle()
            paragraph19.alignment = .left
            paragraph19.lineSpacing = 3
            let stringTest19: String = "  and enter a valid email address. It's important to have a valid email address associated with your account. If you forget your password, your email address can be used to reset it.\n3. Choose your username. Your username is your identity on my-mo. Make it something unique to you and remember that you cannot change your username once you have set it.\n4. Tap the field that says "
            let agreeAttributedString19 = NSMutableAttributedString(string: stringTest19, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString19.addAttribute(NSParagraphStyleAttributeName, value: paragraph19, range: NSRange(location: 0, length: agreeAttributedString19.length))
            agreeAttributedString.append(agreeAttributedString19)

            let paragraph20 = NSMutableParagraphStyle()
            paragraph20.alignment = .left
            paragraph20.lineSpacing = 3
            let stringTest20 = "  'Password'"
            let agreeAttributedString20 = NSMutableAttributedString(string: stringTest20, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString20.addAttribute(NSParagraphStyleAttributeName, value: paragraph20, range: NSRange(location: 0, length: agreeAttributedString20.length))
            agreeAttributedString.append(agreeAttributedString20)
            
            let paragraph21 = NSMutableParagraphStyle()
            paragraph21.alignment = .left
            paragraph21.lineSpacing = 3
            let stringTest21 = "  and enter a secure password. You will need to enter the"
            let agreeAttributedString21 = NSMutableAttributedString(string: stringTest21, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString21.addAttribute(NSParagraphStyleAttributeName, value: paragraph21, range: NSRange(location: 0, length: agreeAttributedString21.length))
            agreeAttributedString.append(agreeAttributedString21)
            
            let paragraph22 = NSMutableParagraphStyle()
            paragraph22.alignment = .left
            paragraph22.lineSpacing = 3
            let stringTest22 = "  'Password'"
            let agreeAttributedString22 = NSMutableAttributedString(string: stringTest22, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString22.addAttribute(NSParagraphStyleAttributeName, value: paragraph22, range: NSRange(location: 0, length: agreeAttributedString22.length))
            agreeAttributedString.append(agreeAttributedString22)
            
            let paragraph23 = NSMutableParagraphStyle()
            paragraph23.alignment = .left
            paragraph23.lineSpacing = 3
            let stringTest23 = "  again to make sure that they match.\nYour password must be at least 8 characters.\n5. Adding Phone number and Country/City. This step is optional, and you can add it at any time.\n6. Last step, prove you're not a machine once you complete this step you're ready to share your current motiffs with your friends and family. "
            let agreeAttributedString23 = NSMutableAttributedString(string: stringTest23, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString23.addAttribute(NSParagraphStyleAttributeName, value: paragraph23, range: NSRange(location: 0, length: agreeAttributedString23.length))
            agreeAttributedString.append(agreeAttributedString23)
            
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.alignment = .left
            paragraph2.lineSpacing = 3
            let stringTest2 = "\n\nSafety Guidelines For The Community "
            let agreeAttributedString2 = NSMutableAttributedString(string: stringTest2, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString2.addAttribute(NSParagraphStyleAttributeName, value: paragraph2, range: NSRange(location: 0, length: agreeAttributedString2.length))
            agreeAttributedString.append(agreeAttributedString2)
            
            let paragraph3 = NSMutableParagraphStyle()
            paragraph3.alignment = .left
            paragraph3.lineSpacing = 3
            let stringTest3 = "\nmy-mo is about"
            let agreeAttributedString3 = NSMutableAttributedString(string: stringTest3, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString.append(agreeAttributedString3)
            
            let paragraph24 = NSMutableParagraphStyle()
            paragraph24.alignment = .left
            paragraph24.lineSpacing = 3
            let stringTest24 = "  sharing your current motiffs and living life on the edge."
            let agreeAttributedString24 = NSMutableAttributedString(string: stringTest24, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString24.addAttribute(NSParagraphStyleAttributeName, value: paragraph24, range: NSRange(location: 0, length: agreeAttributedString24.length))
            agreeAttributedString.append(agreeAttributedString24)
            
            let paragraph25 = NSMutableParagraphStyle()
            paragraph25.alignment = .left
            paragraph25.lineSpacing = 3
            let stringTest25 = "  The aim in creating these rules is that it accommodates to the broadest range while balancing the need for my-mo users to be able to use our service safely and enjoyably."
            let agreeAttributedString25 = NSMutableAttributedString(string: stringTest25, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString25.addAttribute(NSParagraphStyleAttributeName, value: paragraph25, range: NSRange(location: 0, length: agreeAttributedString25.length))
            agreeAttributedString.append(agreeAttributedString25)
            
            let paragraph26 = NSMutableParagraphStyle()
            paragraph26.alignment = .left
            paragraph26.lineSpacing = 3
            let stringTest26 = "\nKeep it legal. "
            let agreeAttributedString26 = NSMutableAttributedString(string: stringTest26, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString26.addAttribute(NSParagraphStyleAttributeName, value: paragraph26, range: NSRange(location: 0, length: agreeAttributedString26.length))
            agreeAttributedString.append(agreeAttributedString26)
            
            let paragraph27 = NSMutableParagraphStyle()
            paragraph27.alignment = .left
            paragraph27.lineSpacing = 3
            let stringTest27 = "Don’t use my-mo for any illegal shenanigans and if you’re under 18 please take good care when attending location. "
            let agreeAttributedString27 = NSMutableAttributedString(string: stringTest27, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString27.addAttribute(NSParagraphStyleAttributeName, value: paragraph27, range: NSRange(location: 0, length: agreeAttributedString27.length))
            agreeAttributedString.append(agreeAttributedString27)

            
            let paragraph28 = NSMutableParagraphStyle()
            paragraph28.alignment = .left
            paragraph28.lineSpacing = 3
            let stringTest28 = "\nWhat not to Host:"
            let agreeAttributedString28 = NSMutableAttributedString(string: stringTest28, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString28.addAttribute(NSParagraphStyleAttributeName, value: paragraph28, range: NSRange(location: 0, length: agreeAttributedString28.length))
            agreeAttributedString.append(agreeAttributedString28)
            
            let paragraph29 = NSMutableParagraphStyle()
            paragraph29.alignment = .left
            paragraph29.lineSpacing = 3
            let stringTest29 = "\n• Things that can bring harm to another or your self\n• Illegal activities (people under the age of 18)\n• Activities that are physically dangerous and harmful\n• Invasions of privacy\n• Locations you have no right to be in\n\nGoing against these rules can and will result in the removal of your current motiff also your account and not being able to use my-mo in the future.\n\nPlease take these rules seriously and honor them in the spirit in which they are intended. The rules will change along side with the app as it continues to grow."
            let agreeAttributedString29 = NSMutableAttributedString(string: stringTest29, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString29.addAttribute(NSParagraphStyleAttributeName, value: paragraph29, range: NSRange(location: 0, length: agreeAttributedString29.length))
            agreeAttributedString.append(agreeAttributedString29)

            
            
            let paragraph4 = NSMutableParagraphStyle()
            paragraph4.alignment = .left
            paragraph4.lineSpacing = 3
            let stringTest4 = "\n\n"
            let agreeAttributedString4 = NSMutableAttributedString(string: stringTest4, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString4.addAttribute(NSParagraphStyleAttributeName, value: paragraph4, range: NSRange(location: 0, length: agreeAttributedString4.length))
            agreeAttributedString.append(agreeAttributedString4)
            
            let paragraph5 = NSMutableParagraphStyle()
            paragraph5.alignment = .left
            paragraph5.lineSpacing = 3
            let stringTest5 = "\n\nInstallation For IOS And Updating Issue"
            let agreeAttributedString5 = NSMutableAttributedString(string: stringTest5, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString5.addAttribute(NSParagraphStyleAttributeName, value: paragraph5, range: NSRange(location: 0, length: agreeAttributedString5.length))
            agreeAttributedString.append(agreeAttributedString5)
            
            let paragraph6 = NSMutableParagraphStyle()
            paragraph6.alignment = .left
            paragraph6.lineSpacing = 3
            let stringTest6 = "\nIf my-mo has disappeared from your IOS device, but is downloaded in the App Store and tapping “OPEN” doesn't work, try connecting your phone to your computer and syncing your apps from iTunes.\nIf that doesn’t work or if my-mo is stuck on installation, try restarting your phone. Then try reinstalling my-mo again by connecting your phone to your computer and syncing the app from iTunes.\nIf you are still having trouble updating or installing my-mo, please contact Apple Support"
            let agreeAttributedString6 = NSMutableAttributedString(string: stringTest6, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString6.addAttribute(NSParagraphStyleAttributeName, value: paragraph6, range: NSRange(location: 0, length: agreeAttributedString6.length))
            agreeAttributedString.append(agreeAttributedString6)
            
            let paragraph7 = NSMutableParagraphStyle()
            paragraph7.alignment = .left
            paragraph7.lineSpacing = 3
            let stringTest7 = "\n\nInstallation For Android And Updating Issue"
            let agreeAttributedString7 = NSMutableAttributedString(string: stringTest7, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString7.addAttribute(NSParagraphStyleAttributeName, value: paragraph7, range: NSRange(location: 0, length: agreeAttributedString7.length))
            agreeAttributedString.append(agreeAttributedString7)

            let paragraph8 = NSMutableParagraphStyle()
            paragraph8.alignment = .left
            paragraph8.lineSpacing = 3
            let stringTest8 = "\nIf you’re having trouble installing or updating my-mo on your Android device from the Google Play Store, please visit the Google Play Help Centre for troubleshooting tips and suggestions."
            let agreeAttributedString8 = NSMutableAttributedString(string: stringTest8, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString.append(agreeAttributedString8)
            
            let paragraph9 = NSMutableParagraphStyle()
            paragraph9.alignment = .left
            paragraph9.lineSpacing = 3
            let stringTest9 = "\n\nThird-Party Applications And Plugins"
            let agreeAttributedString9 = NSMutableAttributedString(string: stringTest9, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString9.addAttribute(NSParagraphStyleAttributeName, value: paragraph9, range: NSRange(location: 0, length: agreeAttributedString9.length))
            agreeAttributedString.append(agreeAttributedString9)
            
            let paragraph10 = NSMutableParagraphStyle()
            paragraph10.alignment = .left
            paragraph10.lineSpacing = 3
            let stringTest10 = "\nThird-party applications and pluggins (or tweaks) are not supported by My Motiff and can compromise the security of your account. Please see our Terms and Service for more information.\nA third-party application is any app that isn't the official my-mo application, but uses you’re my-mo login information (username and password) to access my-mo services. A plugin (or tweak) is an add-on that creates additional functionalities that are not included in the official my-mo application.\nKeep in mind that there is no official my-mo client for Windows or Blackberry devices, so if you’re accessing my-mo with one of those devices, you are using an unauthorized third-party application. To ensure the security of your account, please change your password."
            let agreeAttributedString10 = NSMutableAttributedString(string: stringTest10, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString10.addAttribute(NSParagraphStyleAttributeName, value: paragraph10, range: NSRange(location: 0, length: agreeAttributedString10.length))
            agreeAttributedString.append(agreeAttributedString10)

            
            let paragraph30 = NSMutableParagraphStyle()
            paragraph30.alignment = .left
            paragraph30.lineSpacing = 3
            let stringTest30 = "\nYou must uninstall any plugins or third-party applications before attempting to unlock your account, or it may be locked again. The use of third-party applications or plugins can lead to your account being permanently locked. "
            let agreeAttributedString30 = NSMutableAttributedString(string: stringTest30, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString30.addAttribute(NSParagraphStyleAttributeName, value: paragraph30, range: NSRange(location: 0, length: agreeAttributedString30.length))
            agreeAttributedString.append(agreeAttributedString30)
            
            let paragraph11 = NSMutableParagraphStyle()
            paragraph11.alignment = .left
            paragraph11.lineSpacing = 3
            let stringTest11 = "\n\n\n\n\n\nI’ve Been Experiencing Problems With my-mo"
            let agreeAttributedString11 = NSMutableAttributedString(string: stringTest11, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString11.addAttribute(NSParagraphStyleAttributeName, value: paragraph11, range: NSRange(location: 0, length: agreeAttributedString11.length))
            agreeAttributedString.append(agreeAttributedString11)
            
            let paragraph12 = NSMutableParagraphStyle()
            paragraph12.alignment = .left
            paragraph12.lineSpacing = 3
            let stringTest12 = "\nTeam my-mo apologies for the problems you may be experiencing with the app. Things you may try that might help you if you haven’t already done, please try your best to following the steps below.\n• Uninstall and reinstall you’re my-mo app which will upgrade you to the latest version.\n• Try restarting your device and leaving it off for a few seconds.\n• Try to use my-mo on a Wi-Fi connection or 3G to see if the problem occurs with your Internet connection.\nIf you are still experience trouble with the app my-mo please don’t hesitate to contact the support team.\n\nDue to the volume of reports we receive on a daily basis, you may not receive a personal response on the issue - however, please be assured that we review and appreciate the reports submitted to our team. "
            let agreeAttributedString12 = NSMutableAttributedString(string: stringTest12, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString12.addAttribute(NSParagraphStyleAttributeName, value: paragraph12, range: NSRange(location: 0, length: agreeAttributedString12.length))
            agreeAttributedString.append(agreeAttributedString12)

            let paragraph13 = NSMutableParagraphStyle()
            paragraph13.alignment = .left
            paragraph13.lineSpacing = 3
            let stringTest13 = "\n\n\nI Think My Account Was Hacked"
            let agreeAttributedString13 = NSMutableAttributedString(string: stringTest13, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString13.addAttribute(NSParagraphStyleAttributeName, value: paragraph13, range: NSRange(location: 0, length: agreeAttributedString13.length))
            agreeAttributedString.append(agreeAttributedString13)

            let paragraph31 = NSMutableParagraphStyle()
            paragraph31.alignment = .left
            paragraph31.lineSpacing = 3
            let stringTest31 = "\nIf your account is behaving abnormal, such as:"
            let agreeAttributedString31 = NSMutableAttributedString(string: stringTest31, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString31.addAttribute(NSParagraphStyleAttributeName, value: paragraph31, range: NSRange(location: 0, length: agreeAttributedString31.length))
            agreeAttributedString.append(agreeAttributedString31)
            
            let paragraph14 = NSMutableParagraphStyle()
            paragraph14.alignment = .left
            paragraph14.lineSpacing = 3
            let stringTest14 = "\n• Spam sent by your account\n• If you were informed that someone logged into your account from a different location, IP address, or device\n• Having to continually re-login to the app\n• Have contacts added to your list without your permission\n• If the phone number or email address associated with you’re my-mo account was changed without your consent"
            let agreeAttributedString14 = NSMutableAttributedString(string: stringTest14, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString14.addAttribute(NSParagraphStyleAttributeName, value: paragraph14, range: NSRange(location: 0, length: agreeAttributedString14.length))
            agreeAttributedString.append(agreeAttributedString14)

            
            let paragraph32 = NSMutableParagraphStyle()
            paragraph32.alignment = .left
            paragraph32.lineSpacing = 3
            let stringTest32 = "\n…it’s very likely that your account may have been (HACKED)."
            let agreeAttributedString32 = NSMutableAttributedString(string: stringTest32, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString32.addAttribute(NSParagraphStyleAttributeName, value: paragraph32, range: NSRange(location: 0, length: agreeAttributedString32.length))
            agreeAttributedString.append(agreeAttributedString32)
            
            let paragraph33 = NSMutableParagraphStyle()
            paragraph33.alignment = .left
            paragraph33.lineSpacing = 3
            let stringTest33 = "\n\nIf you believe your account has been (HACKED) but are unsure, please change your password as soon as possible and verify that the email address associated with your account are accurate in my-mo settings."
            let agreeAttributedString33 = NSMutableAttributedString(string: stringTest33, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: CGFloat(13.0))!])
            agreeAttributedString33.addAttribute(NSParagraphStyleAttributeName, value: paragraph33, range: NSRange(location: 0, length: agreeAttributedString33.length))
            agreeAttributedString.append(agreeAttributedString33)
            
            let paragraph34 = NSMutableParagraphStyle()
            paragraph34.alignment = .left
            paragraph34.lineSpacing = 3
            let stringTest34 = "\nSelect a complex and distinctive password that is at least 8 characters in length, with a mix of numbers, symbols and capital and lowercase letters. Avoid using your username, phone number, name, birthday, or any other personal information in your new password.\n\nPlease contact us if you continue to experience problems with above points, please click (here) "
            let agreeAttributedString34 = NSMutableAttributedString(string: stringTest34, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: CGFloat(13.0))!])
            agreeAttributedString34.addAttribute(NSParagraphStyleAttributeName, value: paragraph34, range: NSRange(location: 0, length: agreeAttributedString34.length))
            agreeAttributedString.append(agreeAttributedString34)

            //
            agreeAttributedString.addAttribute(NSLinkAttributeName, value: "chhavi", range: NSRange(location: agreeAttributedString.length - 7, length: 6))
            txt_Information.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
            //
            let paragraph15 = NSMutableParagraphStyle()
            paragraph15.alignment = .left
            paragraph15.lineSpacing = 3
            let stringTest15 = "\n\nTeam my-mo"
            let agreeAttributedString15 = NSMutableAttributedString(string: stringTest15, attributes: [NSForegroundColorAttributeName: UIColor.orange, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString15.addAttribute(NSParagraphStyleAttributeName, value: paragraph15, range: NSRange(location: 0, length: agreeAttributedString15.length))
            agreeAttributedString.append(agreeAttributedString15)
            
            txt_Information.attributedText = agreeAttributedString
        }else if (strTitle == "CONTACT"){
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            paragraph.lineSpacing = 3
            let stringTest = " Product Support\n support@Mymotiff.com\n\n All Inquiries\n info@Mymotiff.com"
            let agreeAttributedString = NSMutableAttributedString(string: stringTest, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Arial", size: CGFloat(15.0))!])
            agreeAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSRange(location: 0, length: agreeAttributedString.length))
            txt_Information.attributedText = agreeAttributedString
        }
        
    }

}
