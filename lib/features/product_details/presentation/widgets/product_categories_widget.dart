import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products_view/services/products_services.dart';

class ProductCategoriesWidget extends StatelessWidget {
  final ProductEntity product;
  final Function(int) onRemove;
  const ProductCategoriesWidget({Key key, this.product, this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ListView.builder(
        itemCount: product.categories.length,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: GestureDetector(
              onLongPress: () {
                if (Services.hasRole(context, productsControllerRole)) {
                  List<DialogButton> dialogButtons = [
                    DialogButton(
                      text: yes,
                      onTap: () async {
                        Navigator.of(context).pop();
                        //todo change
                        bool result = await ProductsServices.removeProductFromCategoryService(
                            productId: product.id.toString(), categoryId: product.categories[index].id.toString());
                        if (result) {
                          snackBar(success: result, message: 'تم إزالة المنتج من الصنف بنجاح', context: context);
                        } else {
                          snackBar(
                              success: result,
                              message: 'فشلت عملية إزالة المنتج من الصنف يرجى المحاولة مجدداً',
                              context: context);
                        }
                        if (result) onRemove(index);
                      },
                    ),
                    DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
                  ];
                  showMyDialog(
                      context: context,
                      title: '',
                      text: 'هل تريد إزالة ${product.name} من ${product.categories[index].name} ؟',
                      dialogButtons: dialogButtons);
                }
              },
              child: ShopByCategory(
                  img: product.categories[index].imageFileName,
                  categoryName: product.categories[index].name,
                  index: index,
                  fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
