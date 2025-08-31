import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersPage extends StatelessWidget {
  void showOfferItemsDialog(
      BuildContext context, {
        required List offerItems,
        required int offerId,
        required String offerName,
        required num offerPrice,
      }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تفاصيل العرض: $offerName'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: offerItems.length,
              itemBuilder: (context, index) {
                final item = offerItems[index].item;
                final imageUrl = item.itemImages.isNotEmpty
                    ? (item.itemImages.first.image.startsWith('http')
                    ? item.itemImages.first.image
                    : 'http://${item.itemImages.first.image}')
                    : null;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("${item.name}"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
            ElevatedButton(
              onPressed: () {
                AppCubit.get(context).addOfferToOrder(
                  id: offerId,
                  name: offerName,
                  quantity: 1,
                  price: offerPrice,
                );

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت إضافة العرض إلى السلة')),
                );
              },
              child: const Text('إضافة العرض للسلة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    double responsiveFontSize(double baseFontSize) {
      return (screenWidth / 375) * baseFontSize;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض المتاحة'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: BlocBuilder<AppCubit, AppSates>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is offerSuccessState) {
            final offers = AppCubit.get(context).Offer_response?.data ?? [];

            if (offers.isEmpty) {
              return const Center(child: Text('لا توجد عروض متاحة حالياً.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                final rawImageUrl = offer.offerItems.isNotEmpty &&
                    offer.offerItems.first.item.itemImages.isNotEmpty
                    ? offer.offerItems.first.item.itemImages.first.image
                    : null;

                final imageUrl = (rawImageUrl != null)
                    ? (rawImageUrl.startsWith('http')
                    ? rawImageUrl
                    : 'http://$rawImageUrl')
                    : null;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final imageSize = (constraints.maxWidth * 0.3).clamp(80.0, 120.0);

                    return InkWell(
                      onTap: () => showOfferItemsDialog(
                        context,
                        offerItems: offer.offerItems,
                        offerId: offer.id,
                        offerName: offer.name,
                        offerPrice: offer.price,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: imageSize,
                                width: imageSize,
                                child: imageUrl != null
                                    ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 60),
                                )
                                    : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.fastfood, size: 60),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offer.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsiveFontSize(18),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    offer.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: responsiveFontSize(14),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // السعر والتاريخ تحت بعض
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'السعر: ${offer.price} ل.س',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsiveFontSize(16),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'من ${offer.fromDate} - ${offer.toDate}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: responsiveFontSize(12),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is offerErrorState) {
            return const Center(child: Text('فشل في تحميل العروض.'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
