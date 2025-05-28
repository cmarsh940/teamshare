import 'package:flutter/material.dart';

class TermsDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none, 
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  'Terms of Use',
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "By using this application, you agree to the conditions set forth below (this 'Agreement'). If you disagree with any of the conditions of this Agreement, do not use this application. We reserve the right to change this Agreement at any time, so please check for changes to this Agreement each time you use this application. Your continued use of this site following the posting of changes to this Agreement means that you accept those changes.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Licenses and Restrictions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "This application is owned and operated by Fitness You Trust (hereinafter 'we', 'us', or a similar term). Material found at this application (including visuals, text, displays, databases, media, and general information) is owned or licensed by us. Unless otherwise indicated, individuals may: post material from portions of this application to another website or on a computer network for their own personal, noncommercial use; and view, download, and print materials from this application for their own personal, noncommercial use. In this regard, materials may not be posted from this application to another website. In addition, materials from this application may be reproduced by media personnel for use in traditional public news forums unless otherwise indicated. Any other use of information or materials found at this application, including any use by organizations or legal entities, is not permitted without our prior written permission. (See “Permission to Use Copyrights and Trademarks” below.) Notwithstanding the foregoing, we reserve sole discretion and right to deny, revoke, or limit use of this application, including the reproduction and any other use of any materials available through this application. It is not our responsibility, however, to determine what “fair use” means for persons wishing to use materials from this application. That remains wholly a responsibility of individual users of this application. Furthermore, we are not required to give additional source citations, or to guarantee that the materials of this application are cleared for any alternate use. Such responsibility also ultimately remains with individual users of this application. However, we maintain the right to prevent infringement of Fitness You Trust materials and to interpret “fair use” as we understand the law.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Fees and Payments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "You agree to pay to Fitness You Trust any fees for each Service you purchase or use (including any overage fees), in accordance with the pricing and payment terms presented to you for that Service. Buy purchasing any of our Services you represent and warrant that the credit card information you provide is correct and you will promptly notify Fitness You Trust of any changes to such information. Fees paid by you are non-refundable, except as provided in these Terms or when required by law.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Code of Conduct',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "You agree that you will not individually, or as part of any collective effort, submit or post information to this application that could be deemed harmful or offensive to other users, nor will you impersonate another user in order to hide your identity or implicate another in such actions. You agree to do nothing that might disrupt the flow of data to and from this application, impact the service or performance of this application, or circumvent any of the controls or usage rules that we have implemented. You understand that the result of harmful or offensive actions may include revocation of your right to use this application (including your right to use any materials from this application) and legal action against you.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Linking',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "For your convenience, this application may contain links to websites operated by others. Such third-party sites are not maintained or controlled by us, and we are not responsible for their content. Although we have made a good faith effort to link only to tasteful, appropriate sites, some may contain inappropriate or objectionable material. If you find such material while using a website that you accessed through a link on this application, please notify us immediately. We believe that those who make information available on the Internet expect that it will be publicly and widely available. Therefore, we believe that linking to other sites is legally permissible and consistent with the expectations of those who use the Internet. However, if access to a particular website should be restricted, the operator of such site should promptly notify us.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Jurisdiction and Applicable Law',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "This Agreement shall be governed by the laws of the State of Texas, United States of America, as applied to agreements entered into and to be performed entirely within the state, without giving effect to any principles of conflicts of law. Any action you bring to enforce this Agreement or any matters related to this application shall be brought in either the state or federal courts located in Denton, Texas, and you hereby consent and submit to the personal jurisdiction of such courts for the purposes of litigating any such action. If any provision of this Agreement is unlawful, void, or unenforceable in whole or in part, the remaining provisions shall not be affected, unless we determine that the invalid or unenforceable provision is an essential term to the Agreement, in which case we may at our sole discretion amend this Agreement.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Limitations of Liability',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "We are not liable for any special or consequential damages resulting from your use of, or your inability to use, this application or the materials in this application or any linked site, including, but not limited to, lost profits, business interruption, and loss of programs or other data on your information handling system. In no event shall our total liability to you for all damages, losses, and causes of action exceed the amount paid by you, if any, for accessing this application or any linked site.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Disclaimers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "THIS APPLICATION AND THE MATERIALS AT THIS APPLICATION AND ANY LINKED SITE ARE PROVIDED “AS IS” AND WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMISSIBLE PURSUANT TO APPLICABLE LAW, WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, WARRANTIES OF TITLE AND IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. WE DO NOT WARRANT THAT THE FUNCTIONS OF THIS APPLICATION WILL BE UNINTERRUPTED OR ERROR FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT THIS APPLICATION OR THE SERVER THAT MAKES IT AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Trademarks',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "These marks are identifiers of Fitness You Trust and are registered in the United States and other countries. For additional information regarding Fitness You Trust trademarks and service marks and their proper use, please contact Fitness You Trust.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "By using this application, you agree to the conditions set forth below (this 'Agreement'). If you disagree with any of the conditions of this Agreement, do not use this application. We reserve the right to change this Agreement at any time, so please check for changes to this Agreement each time you use this application. Your continued use of this site following the posting of changes to this Agreement means that you accept those changes.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'User Privacy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "Fitness You Trust handels your data as confidental information. Fitness You Trust does not store payment card information on our servers, Fitness You Trust uses a third party company that is designed, and secure for handling payments. Fitness You Trust does not allow third party to access your stored data or sell your data to any third party. Fitness You Trust may disclose your Content when required by law or legal process, but only after Fitness You Trust, if permitted by law, attempts to notify you, in anyway, to give you the opportunity to challenge the requirement to disclose. Please contact us for more details.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Cookies',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "We use cookies for a number of different purposes. Some cookies are necessary for technical reasons; some enable a personalized experience for both visitors and registered users; and some allow the display of advertising from selected third party networks. Some of these cookies may be set when a page is loaded, or when a visitor takes a particular action (clicking the 'like' or 'follow' button on a post, for example). Many of the cookies we use are only set if you are a registered Fitness You Trust user (so you don’t have to log in every time, for example), while others are set whenever you visit one of our websites or applications, irrespective of whether you have an account. For more information please contact us at support@marshalltechnologygroup.com.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Anti-Spamming',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "Fitness You Trust does not tolerate spamming of any kind. Recipients must have agreed to receiving communications from you, the sender. Subscribed accounts may be terminated for sending unsolicited email or text messages. You are responsible for ensuring that the email messages you send in connection with your profile do not generate a number of spam complaints. If it is determined that your level of spam complaints is at a high rate, Fitness You Trust, has the right to suspend or terminate your use of its website and/or services. We reserve the right to monitor and may request additional information regarding your mailing lists in we deem it necessary. In any case we can suspend or remove email privileges on your account. If you feel like you have been spammed by anyone using Fitness You Trust please contact us at support@marshalltechnologygroup.com",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const Text(
                  'Questions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "For further assistance or information regarding Fitness You Trust trademarks and copyrighted materials, you may contact Fitness You Trust at: Phone: (940)222-5295 E-mail: support@marshalltechnologygroup.com Effective date: October 1, 2020",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),

              ],
            ),
          ),
        ]
      )
    );
  }
}