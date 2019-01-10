import 'package:flutter/material.dart';
import 'package:lesson01/models/location.dart';
import 'package:lesson01/styles.dart';
import 'package:lesson01/components/location_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lesson01/components/default_app_bar.dart';
import 'package:lesson01/components/banner_image.dart';

const BannerImageHeight = 300.0;
const BodyVerticalPadding = 20.0;
const FooterHeight = 100.0;

class LocationDetail extends StatefulWidget {
  final int locationID;

  LocationDetail(this.locationID);

  @override
  createState() => _LocationDetailState(this.locationID);
}

class _LocationDetailState extends State<LocationDetail> {
  final int locationID;
  Location location = Location.blank();

  _LocationDetailState(this.locationID);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(),
        body: Stack(children: [
          _renderBody(context, location),
          _renderFooter(context, location)
        ]));
  }

  loadData() async {
    final location = await Location.fetchByID(this.locationID);

    if (mounted) {
      setState(() {
        this.location = location;
      });
    }
  }

  Widget _renderBody(BuildContext context, Location location) {
    var results = List<Widget>();
    results.add(BannerImage(url: location.url, height: BannerImageHeight));
    results.add(_renderHeader());
    results.addAll(_renderFacts(context, location));
    results.add(_renderBottomSpacer());
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: results),
    );
  }

  Widget _renderBottomSpacer() {
    return Container(height: FooterHeight);
  }

  Widget _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: LocationTile(location: this.location, darkTheme: false),
    );
  }

  Widget _renderFooter(BuildContext context, Location location) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
            height: FooterHeight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: _renderBookButton(),
            ),
          ),
        ]);
  }

  Widget _renderBookButton() {
    return FlatButton(
      color: Styles.accentColor,
      textColor: Styles.textColorBright,
      onPressed: _handleBookPress,
      child: Text('Book'.toUpperCase(), style: Styles.textCTAButton),
    );
  }

  void _handleBookPress() async {
    const url = 'mailto:hello@tourism.co?subject=Inquiry';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> _renderFacts(BuildContext context, Location location) {
    var results = List<Widget>();
    for (int i = 0; i < location.facts.length; i++) {
      results.add(_sectionTitle(location.facts[i].title));
      results.add(_sectionText(location.facts[i].text));
    }
    return results;
  }

  Widget _sectionTitle(String text) {
    return Container(
      padding: EdgeInsets.fromLTRB(Styles.horizontalPaddingDefault, 25.0,
          Styles.horizontalPaddingDefault, 0.0),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.left,
        style: Styles.headerLarge,
      ),
    );
  }

  Widget _sectionText(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: Styles.horizontalPaddingDefault),
      child: Text(
        text,
        style: Styles.textDefault,
      ),
    );
  }
}
