import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Rental.dart';
import 'package:project/providers/cancelUpdate.dart';
import 'package:project/screens/apartment_details_screen.dart';
import 'package:project/widgets/rental_edit.dart';

import '../providers/cancleRentalProvider.dart';
import '../providers/updateRentalProvider.dart';

class RentalWidget extends ConsumerStatefulWidget {
  const RentalWidget({
    super.key,
    required this.rental,
    required this.ownerView,
    required this.onActive,
    this.tenantNameTemp,
  });

  final Rental rental;
  final bool ownerView;
  final bool onActive;
  final String? tenantNameTemp;

  @override
  ConsumerState<RentalWidget> createState() => _RentalWidgetState();
}

class _RentalWidgetState extends ConsumerState<RentalWidget> {
  bool _isEditing = false;
  bool _isCanceling = false;
  bool _isAccepting = false;
  bool _isRejecting = false;

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
    String fromStr = df.format(widget.rental.start);
    String toStr = df.format(widget.rental.end);

    final isUpdating = widget.rental.updateRequest != null;
    if (isUpdating) {
      fromStr = df.format(widget.rental.updateRequest!.start!);
      toStr = df.format(widget.rental.updateRequest!.end!);
    }

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
                        t.rentalId,
                        '#${widget.rental.id}',
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

                      _line(
                        t.status,
                        isUpdating ? "update" : widget.rental.status,
                        cs,
                        screenWidth,
                      ),

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
                    print("GO TO ${widget.rental.apartmentId}");
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

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Widget _actionsRow({
    required AppLocalizations t,
    required ColorScheme cs,
    required double screenWidth,
    required double btnHeight,
    required bool ownerView,
    required String status,
  }) {
    // NORMAL pending & no edit
    if (!ownerView &&
        status == 'pending' &&
        widget.onActive &&
        (widget.rental.updateRequest == null)) {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //edit button
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: _isEditing ? "..." : t.edit,
              onTap: _isEditing
                  ? () {}
                  : () async {
                      final range = await showEditBookingDatesDialog(
                        context,
                        initialFrom: widget.rental.start,
                        initialTo: widget.rental.end,
                        firstDate: DateTime(
                          2020,
                          1,
                          1,
                        ), //calendar start and end
                        lastDate: DateTime(2060, 1, 1),
                      );

                      print("CLosed..................");

                      if (range != null) {
                        setState(() => _isEditing = true);
                        // print (_formatDate(range.start));
                        // print (_formatDate(range.end));

                        try {
                          await ref.read(UpdateRentalProvider)(
                            widget.rental.id,
                            FormData.fromMap({
                              '_method': 'PUT',
                              'rental_start_date': _formatDate(range.start),
                              'rental_end_date': _formatDate(range.end),
                            }),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Edit request submitted successfully!",
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString().replaceFirst('Exception: ', ''),
                              ),
                            ),
                          );
                        } finally {
                          setState(() => _isEditing = false);
                        }
                      }
                    },

              child: _isEditing
                  ? SizedBox(
                height: btnHeight - 15,
                width: btnHeight - 15,
                    child: CircularProgressIndicator(
                        color: cs.onPrimary,
                        strokeWidth: 2,
                      ),
                  )
                  : null,
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
              text: _isCanceling ? '...' : t.cancel,
              onTap: _isCanceling
                  ? () {}
                  : () async {
                      setState(() => _isCanceling = true);

                      try {
                        print("CANCELING");
                        final cancelRental = ref.read(cancelRentalProvider);
                        await cancelRental(widget.rental.id);
                        print("DONE CANCELING");

                        setState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      } finally {
                        setState(() => _isCanceling = false);
                      }
                    },

              child: _isEditing
                  ? SizedBox(
                height: btnHeight - 15,
                width: btnHeight - 15,
                child: CircularProgressIndicator(
                  color: cs.onPrimary,
                  strokeWidth: 2,
                ),
              )
                  : null,
            ),
          ),
        ],
      );
    }

    // NORMAL approved & no edit
    if (!ownerView &&
        status == 'approved' &&
        widget.onActive &&
        (widget.rental.updateRequest == null)) {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //edit button
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: _isEditing ? "..." : t.edit,
              onTap: _isEditing ? () {}
              : () async {

                final range = await showEditBookingDatesDialog(
                  context,
                  initialFrom: widget.rental.start,
                  initialTo: widget.rental.end,
                  firstDate: DateTime(2020, 1, 1), //calendar start and end
                  lastDate: DateTime(2060, 1, 1),
                );

                if (range != null) {
                  setState(() => _isEditing = true);
                  // print (_formatDate(range.start));
                  // print (_formatDate(range.end));

                  try {
                    await ref.read(UpdateRentalProvider)(
                      widget.rental.id,
                      FormData.fromMap({
                        '_method': 'PUT',
                        'rental_start_date': _formatDate(range.start),
                        'rental_end_date': _formatDate(range.end),
                      }),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Edit request submitted successfully!"),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceFirst('Exception: ', ''),
                        ),
                      ),
                    );
                  }finally {
                    setState(() => _isEditing = false);
                  }
                }
              },
              child: _isEditing
                  ? SizedBox(
                height: btnHeight - 15,
                width: btnHeight - 15,
                child: CircularProgressIndicator(
                  color: cs.onPrimary,
                  strokeWidth: 2,
                ),
              )
                  : null,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
        ],
      );
    }

    // UPDATE approved & update request
    if (!ownerView &&
        status == 'approved' &&
        widget.onActive &&
        (widget.rental.updateRequest != null)) {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //cancel button
              cs: cs,
              screenWidth: screenWidth,
              height: btnHeight,
              radius: screenWidth * 0.035,
              text: _isCanceling ? '...' : t.cancel,
              onTap: _isCanceling ? (){}
              : () async {
                setState(() => _isCanceling = true);

                try {
                  print(
                    "CANCELING --------------------- ${widget.rental.updateRequest!.id!}",
                  );
                  await ref.read(cancelUpdateProvider)(
                    widget.rental.updateRequest!.id!,
                  );
                  print("DONE CANCELING");

                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }finally {
                  setState(() => _isCanceling = false);
                }
              },
              child: _isEditing
                  ? SizedBox(
                height: btnHeight - 15,
                width: btnHeight - 15,
                child: CircularProgressIndicator(
                  color: cs.onPrimary,
                  strokeWidth: 2,
                ),
              )
                  : null,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
        ],
      );
    }

    // OWNER with buttons
    if (ownerView && (status == 'pending' || (status == 'approved') && widget.rental.updateRequest != null)) {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              //accept button
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
              //reject button
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
    this.child,
  });

  final ColorScheme cs;
  final double screenWidth;
  final double height;
  final double radius;
  final String text;
  final VoidCallback onTap;
  final Widget? child;

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
            child:
                child ??
                Text(
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
