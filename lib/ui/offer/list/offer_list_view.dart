import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/ui/offer/list/offer_list_view_app_bar.dart';
import 'package:flutterbuyandsell/ui/offer/list/offer_receive_list_view.dart';
import 'package:flutterbuyandsell/ui/offer/list/offer_sent_list_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

int _selectedIndex = 0;

class OfferListView extends StatefulWidget {
  const OfferListView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;
  @override
  _OfferListViewState createState() => _OfferListViewState();
}

class _OfferListViewState extends State<OfferListView> {
  final PageController _pageController =
      PageController(initialPage: _selectedIndex);
  @override
  Widget build(BuildContext context) {
    final OfferListViewAppBar pageviewAppBar = OfferListViewAppBar(
      selectedIndex: _selectedIndex,
      onItemSelected: (int index) => setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }),
      items: <OfferListViewAppBarItem>[
        OfferListViewAppBarItem(
            title: Utils.getString(context, 'offer_list__offer_sent'),
            activeColor: PsColors.activeColor),
        OfferListViewAppBarItem(
            title: Utils.getString(context, 'offer_list__offer_receive'),
            activeColor: PsColors.activeColor),
      ],
    );
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: PsColors.baseColor,
        body: Column(children: <Widget>[
          pageviewAppBar,
          Expanded(
              child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    OfferSentListView(
                      animationController: widget.animationController,
                    ),
                    OfferReceivedListView(
                      animationController: widget.animationController,
                    ),
                  ],
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  })),
        ]),
      ),
    );
  }
}
