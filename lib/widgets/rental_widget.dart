import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Rental.dart';
import 'package:project/screens/apartment_details_screen.dart';
import 'package:project/widgets/rental_edit.dart';

import '../providers/cancleRentalProvider.dart';

class RentalWidget extends ConsumerStatefulWidget {
  const RentalWidget({
    super.key,
    required this.rental,
    required this.ownerView,
    this.tenantNameTemp,
  });

  final Rental rental;
  final bool ownerView;

  final String? tenantNameTemp;

  @override
  ConsumerState<RentalWidget> createState() => _RentalWidgetState();
}

class _RentalWidgetState extends ConsumerState<RentalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AppLocalizations t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final shadowColor = _shadowColor(cs, widget.rental.status);

    final df = DateFormat('yyyy-MM-dd');
    final fromStr = df.format(widget.rental.start);
    final toStr = df.format(widget.rental.end);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(200),
            blurRadius: 0,
            spreadRadius: 0.5,
            offset: isRtl ? const Offset(0, 0) : const Offset(-5, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        child: SizedBox(
          height: screenHeight * 0.277,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                    vertical: screenHeight * 0.02,
                  ),
                  color: cs.surfaceContainerHighest.withAlpha(180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _line(
                        t.apartment,
                        '#${widget.rental.apartmentId}',
                        cs,
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.006),
                      _line(t.from, fromStr, cs, screenWidth),
                      _line(t.to, toStr, cs, screenWidth),
                      SizedBox(height: screenHeight * 0.006),

                      if (!widget.ownerView)
                        _line(
                          t.owner,
                          widget.rental.owner_name,
                          cs,
                          screenWidth,
                        )
                      else
                        _line(
                          t.tenant,
                          '${t.tenant} #${widget.rental.userId}',
                          cs,
                          screenWidth,
                        ),

                      SizedBox(height: screenHeight * 0.006),

                      _line(t.status, widget.rental.status, cs, screenWidth),

                      SizedBox(height: screenHeight * 0.015),

                      _actionsRow(
                        t: t,
                        cs: cs,
                        screenWidth: screenWidth,
                        btnHeight: screenHeight * 0.05,
                        ownerView: widget.ownerView,
                        status: widget.rental.status,
                      ),
                    ],
                  ),
                ),
              ),

              // RIGHT image
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ApartmentDetailsScreen(
                        apartmentId: widget.rental.apartmentId,
                      ),
                      withNavBar: false,
                    );
                  },
                  child: Image.network(
                    widget.rental.cover_image_url == null
                        ? "assets/images/apartments/test.jpg"
                        : "http://10.0.2.2:8000/storage/${widget.rental.cover_image_url}",
                    width: double.infinity,
                    height: screenHeight * 0.3,
                    fit: BoxFit.cover,

                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/images/apartments/test.jpg',
                        width: double.infinity,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(String k, String v, ColorScheme cs, double screenWidth) {
    return Text(
      '$k: $v',
      style: TextStyle(
        color: cs.onSurface,
        fontSize: screenWidth * 0.04,
        height: 1.2,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _shadowColor(ColorScheme cs, String status) {
    if (status == 'pending' || status == 'passed') return cs.tertiary;
    if (status == 'approved' || status == 'ongoing') return cs.secondary;
    return cs.error;
  }

  Widget _actionsRow({
    required AppLocalizations t,
    required ColorScheme cs,
    required double screenWidth,
    required double btnHeight,
    required bool ownerView,
    required String status,
  }) {
    if (!ownerView &&
        (status == 'approved' || status == 'ongoing' || status == 'pending')) {
      bool canceling = ref.watch(CancelRentalProvider(widget.rental.id));

      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //edit button
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: t.edit,
              onTap: () async {
                final range = await showEditBookingDatesDialog(
                  context,
                  initialFrom: widget.rental.start,
                  initialTo: widget.rental.end,
                  firstDate: DateTime(2020, 1, 1), //calendar start and end
                  lastDate: DateTime(2060, 1, 1),
                );

                if (range != null) {
                  //hereee we send the edit request/use the edit logic
                  setState(() {
                    widget.rental.start = range.start;
                    widget.rental.end = range.end;
                  });
                }
              },
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: _ActionBtn(
              //cancel button
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: t.cancel,
              onTap: canceling
                  ? () {}
                  : () async{
                       try{
                         setState(() {
                           canceling = true;
                         });
                        print("CANCELING");
                        await ref.read(CancelRentalProvider(widget.rental.id).future);
                        canceling = false;
                        print("DONE CANCELING");

                        setState(() {});
                      }catch(e){
                         ScaffoldMessenger.of(context)
                             .showSnackBar(SnackBar(content: Text(e.toString())));
                       }
                    },
            ),
          ),
        ],
      );
    }

    if (ownerView && status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //accept buttn
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: t.accept,
              onTap: () {},
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: _ActionBtn(
              //reject buttton
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: t.reject,
              onTap: () {},
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.cs,
    required this.screenWidth,
    required this.height,
    required this.radius,
    required this.text,
    required this.onTap,
  });

  final ColorScheme cs;
  final double screenWidth;
  final double height;
  final double radius;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fontSize = screenWidth * 0.04;
    return SizedBox(
      height: height,
      child: Material(
        color: cs.primary.withAlpha(180),
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
