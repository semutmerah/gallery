// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/letter_spacing.dart';
import 'package:gallery/studies/shrine/colors.dart';
import 'package:gallery/studies/shrine/expanding_bottom_sheet.dart';
import 'package:gallery/studies/shrine/model/app_state_model.dart';
import 'package:gallery/studies/shrine/model/product.dart';
import 'package:gallery/studies/shrine/theme.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

const _startColumnWidth = 60.0;
const _ordinalSortKeyName = 'shopping_cart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key key}) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
            product: model.getProductById(id),
            quantity: model.productsInCart[id],
            onPressed: () {
              model.removeItemFromCart(id);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: shrinePink50,
      body: SafeArea(
        child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(0, name: _ordinalSortKeyName),
                      child: Row(
                        children: [
                          SizedBox(
                            width: _startColumnWidth,
                            child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () =>
                                  ExpandingBottomSheet.of(context).close(),
                              tooltip: GalleryLocalizations.of(context)
                                  .shrineTooltipCloseCart,
                            ),
                          ),
                          Text(
                            GalleryLocalizations.of(context)
                                .shrineCartPageCaption,
                            style: localTheme.textTheme.subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            GalleryLocalizations.of(context)
                                .shrineCartItemCount(
                              model.totalCartQuantity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(1, name: _ordinalSortKeyName),
                      child: Column(
                        children: _createShoppingCartRows(model),
                      ),
                    ),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(2, name: _ordinalSortKeyName),
                      child: ShoppingCartSummary(model: model),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
                PositionedDirectional(
                  bottom: 16,
                  start: 16,
                  end: 16,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(3, name: _ordinalSortKeyName),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        primary: shrinePink100,
                      ),
                      onPressed: () {
                        model.clearCart();
                        ExpandingBottomSheet.of(context).close();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          GalleryLocalizations.of(context)
                              .shrineCartClearButtonCaption,
                          style: TextStyle(
                              letterSpacing:
                                  letterSpacingOrNone(largeLetterSpacing)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({Key key, this.model}) : super(key: key);

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(color: shrineBrown600);
    final largeAmountStyle = Theme.of(context)
        .textTheme
        .headline4
        .copyWith(letterSpacing: letterSpacingOrNone(mediumLetterSpacing));
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );

    return Row(
      children: [
        const SizedBox(width: _startColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Column(
              children: [
                MergeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectableText(
                        GalleryLocalizations.of(context).shrineCartTotalCaption,
                      ),
                      Expanded(
                        child: SelectableText(
                          formatter.format(model.totalCost),
                          key: const Key('ShrinePage_Total'),
                          style: largeAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                MergeSemantics(
                  child: Row(
                    children: [
                      SelectableText(
                        GalleryLocalizations.of(context)
                            .shrineCartSubtotalCaption,
                      ),
                      Expanded(
                        child: SelectableText(
                          formatter.format(model.subtotalCost),
                          key: const Key('ShrinePage_Subtotal'),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                MergeSemantics(
                  child: Row(
                    children: [
                      SelectableText(
                        GalleryLocalizations.of(context)
                            .shrineCartShippingCaption,
                      ),
                      Expanded(
                        child: SelectableText(
                          formatter.format(model.shippingCost),
                          key: const Key('ShrinePage_Shipping'),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                MergeSemantics(
                  child: Row(
                    children: [
                      SelectableText(
                        GalleryLocalizations.of(context).shrineCartTaxCaption,
                      ),
                      Expanded(
                        child: SelectableText(
                          formatter.format(model.tax),
                          key: const Key('ShrinePage_Tax'),
                          style: smallAmountStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    Key key,
    @required this.product,
    @required this.quantity,
    this.onPressed,
  }) : super(key: key);

  final Product product;
  final int quantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        key: ValueKey<int>(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: GalleryLocalizations.of(context)
                .shrineScreenReaderRemoveProductButton(product.name(context)),
            button: true,
            enabled: true,
            child: ExcludeSemantics(
              child: SizedBox(
                width: _startColumnWidth,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onPressed,
                  tooltip:
                      GalleryLocalizations.of(context).shrineTooltipRemoveItem,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        product.assetName,
                        package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75,
                        height: 75,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MergeSemantics(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        GalleryLocalizations.of(context)
                                            .shrineProductQuantity(quantity),
                                      ),
                                    ),
                                    SelectableText(
                                      GalleryLocalizations.of(context)
                                          .shrineProductPrice(
                                        formatter.format(product.price),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SelectableText(
                                product.name(context),
                                style: localTheme.textTheme.subtitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: shrineBrown900,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
