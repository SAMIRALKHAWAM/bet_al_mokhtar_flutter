import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersPage extends StatelessWidget {
  // دالة لإظهار Dialog تفاصيل عناصر العرض مع إمكانية إضافة العرض للسلة
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
                return
                  // ListTile(
                  // leading: imageUrl != null
                  //     ? ClipRRect(
                  //   borderRadius: BorderRadius.circular(6),
                  //   child: Image.network(
                  //     imageUrl,
                  //     width: 50,
                  //     height: 50,
                  //     fit: BoxFit.cover,
                  //   ),
                  // )
                  //     : const Icon(Icons.image_not_supported),
                  // title:
                  Text("${item.name}   ");
                // );
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
                  quantity: 1,  // الكمية هنا ثابتة 1، ممكن تعدل حسب احتياجك
                  price: offerPrice,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تمت إضافة العرض إلى السلة')),
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
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 60), // ← الصورة المكسورة بتظهر هون
                          )
                              : Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood, size: 60),
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
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                offer.description,
                                style: theme.textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'السعر: ${offer.price} \$',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'من ${offer.fromDate} - ${offer.toDate}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
