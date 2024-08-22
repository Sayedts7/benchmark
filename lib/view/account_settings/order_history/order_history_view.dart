import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/textStyles.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Order History',
          style: AppTextStyles.label14600ATC,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 0.5,
            decoration: const BoxDecoration(
              color: secondaryColor,

              boxShadow: [
                BoxShadow(
                  // offset: Offset(3 , 3),
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 2
                )
              ],
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: kIsWeb
                  ? EdgeInsets.symmetric(
                  vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
                  : EdgeInsets.all(MySize.size20),
              child: Column(
                children: [

                  ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                    return Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.
                    symmetric(vertical: MySize.size10,
                         ),
                          child: ListTile(
                            // dense: true,
                            title: Padding(
                              padding:  EdgeInsets.symmetric(vertical: MySize.size6),
                              child: Text('Project name', style: AppTextStyles.label14700B,),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: MySize.size14,),
                            subtitle: Text('Oh, I finished de-bugging the phones, but the system\'s compiling for eighteen minutes.',
                              style:AppTextStyles.label12400BTC ,),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
