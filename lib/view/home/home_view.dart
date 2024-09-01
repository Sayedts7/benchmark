
import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/textStyles.dart';
import 'package:benchmark_estimate/view/account_settings/account_settings_view.dart';
import 'package:benchmark_estimate/view/account_settings/my_profile/my_profile_view.dart';
import 'package:benchmark_estimate/view/create_project/create_project_view.dart';
import 'package:benchmark_estimate/view/notifications/notification_view.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view_model/provider/homescreen_status_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../view_model/firebase/global.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import '../../view_model/firebase/global.dart';
import '../../view_model/firebase/notification_services.dart';
import '../../view_model/firebase/push_notifications.dart';
import '../project_status/wait_for_delivery.dart';
import '../project_status/wait_for_quote.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;

// Import other necessary files and packages

// Project model
class Project {
  final String id;
  final String projectName;
  final String status;
  final DateTime deadLine;
  final String userId;
  final String customerName;
  final String price; // Changed to String
  final String message;
  final Map<String, dynamic> category; // Changed to Map<String, dynamic>
  final bool paid;
  final List<String> fileUrls;

  Project({
    required this.id,
    required this.projectName,
    required this.status,
    required this.deadLine,
    required this.userId,
    required this.customerName,
    required this.price,
    required this.message,
    required this.category,
    required this.paid,
    required this.fileUrls,
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      projectName: data['projectName'] ?? '',
      status: data['status'] ?? '',
      deadLine: (data['deadLine'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      customerName: data['customerName'] ?? '',
      price: data['price'] ?? '', // Now expects a String
      message: data['message'] ?? '',
      category: data['category'] ?? {}, // Now expects a Map<String, dynamic>
      paid: data['paid'] ?? false,
      fileUrls: List<String>.from(data['fileUrls'] ?? []),
    );
  }
}
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    notificationServices.sendToken(uid);
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateProjectView(preview: false))),
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: whiteColor),
      ),
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      title: const Text('Home', style: AppTextStyles.label14600ATC),
      centerTitle: true,
      leading: _buildMenuButton(context),
      actions: [_buildNotificationBadge(context)],
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AccountSettingsView())),
      child: Padding(
        padding: EdgeInsets.all(MySize.size20),
        child: SvgPicture.asset(menu),
      ),
    );
  }

  Widget _buildNotificationBadge(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Notifications')
          .where('toId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        int unreadCount = snapshot.data?.docs.length ?? 0;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          badgeContent: Text(unreadCount.toString(), style: const TextStyle(color: Colors.white)),
          badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
          showBadge: unreadCount > 0,
          child: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => const NotificationView())),
            icon: const Icon(Icons.notifications, color: blackColor),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDivider(),
          Padding(
            padding: EdgeInsets.all(MySize.size20),
            child: SizedBox(
              height: MySize.safeHeight * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatusFilters(),
                    SizedBox(height: MySize.size25),
                    _buildProjectList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 0.5,
      decoration: const BoxDecoration(
        color: secondaryColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2)],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Consumer<HomeScreenStatusProvider>(
      builder: (context, projectProvider, child) {
        return Row(
          children: ['All', 'In Progress', 'Completed'].map((status) {
            return Padding(
              padding: EdgeInsets.only(right: MySize.size12),
              child: _buildFilterChip(status, projectProvider),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilterChip(String status, HomeScreenStatusProvider provider) {
    bool isSelected = provider.status == status;
    return InkWell(
      onTap: () => provider.updateStatus(status),
      child: Container(
        height: MySize.size28,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : whiteColor,
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: const Color(0xFFDEE3EA), width: 1.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              status,
              style: isSelected ? AppTextStyles.label12500W : AppTextStyles.label12500PTC,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectList() {
    return Consumer<HomeScreenStatusProvider>(
      builder: (context, hmsp, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: _getProjectStream(hmsp.status),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return _buildEmptyProjectList();
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Project project = Project.fromFirestore(snapshot.data!.docs[index]);
                return _buildProjectItem(project);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProjectItem(Project project) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ProjectReusableContainer(
        height: MySize.size90,
        projectName: project.projectName,
        expiryDate: project.deadLine.toString().replaceRange(11, 23, ''),
        statusText: project.status == 'Quote Submitted' ? 'Quote Received' : project.status,
        textColor: _getStatusColor(project.status),
        borderColor: _getStatusColor(project.status),
        bgColor: _getStatusBackgroundColor(project.status),
        ontap: () => _navigateToProjectDetails(project),
      ),
    );
  }
  void _navigateToProjectDetails(Project project) {
    Widget destinationPage;
    switch (project.status) {
      case 'Requirements Submitted':
        destinationPage = ProjectSubmittedView(docId: project.id);
        break;
      case 'Quote Submitted':
        destinationPage = WaitForQuoteView(
          docId: project.id,
          price: project.price,
          userId: project.userId,
          userName: project.customerName,
          projectName: project.projectName,
          message: project.message,
          date: Timestamp.fromDate(project.deadLine),
          categories: project.category,
          paid: project.paid,
          files: project.fileUrls,
        );
        break;
      default:
        destinationPage = WaitForDeliveryView(docId: project.id);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Quote Submitted':
        return yellowDark;
      case 'Project Started':
        return blueDark;
      case 'Requirements Submitted':
        return Colors.grey;
      default:
        return greenDark;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Quote Submitted':
        return yellowLight;
      case 'Project Started':
        return blueLight;
      case 'Requirements Submitted':
        return Colors.grey.withOpacity(0.2);
      default:
        return greenLight;
    }
  }

  Widget _buildEmptyProjectList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200),
        SvgPicture.asset(noOrders),
        SizedBox(height: MySize.size20),
        const Text('No Project Yet', style: AppTextStyles.label14600P),
      ],
    );
  }

  Stream<QuerySnapshot> _getProjectStream(String status) {
    final query = FirebaseFirestore.instance
        .collection('Projects')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy('id', descending: true);

    switch (status) {
      case 'Completed':
        return query.where('status', isEqualTo: 'Completed').snapshots();
      case 'In Progress':
        return query.where('status', whereIn: ['Project Started', 'Quote Submitted', 'Requirements Submitted']).snapshots();
      default:
        return query.snapshots();
    }
  }
}
