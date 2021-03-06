import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hk4_sallah/model/cart_model.dart';
import 'package:hk4_sallah/modules/item_details/item_details.dart';
import 'package:hk4_sallah/modules/product/cubit.dart';
import 'package:hk4_sallah/shared/components/components.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';


class Cart extends StatelessWidget {
  static const String CART_SCREEN = 'cart_layout';

  @override
  Widget build(BuildContext context) {
    CartModel? cartModel;
    return BlocConsumer<ProductCubit, SallaStates>(
      listener: (BuildContext context, state) {
/*        if (state is ChangeFavoriteState) {
          favoriteStateModel = ProductCubit.get(context).favoriteStateModel;
          if (favoriteStateModel != null) {
            Flushbar(
              title: 'Alert!',
              message: favoriteStateModel.message,
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }*/
      },
      builder: (BuildContext context, state) {
        cartModel = ProductCubit.get(context).cartModel;
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
          ),
          body: ProductCubit.get(context).cartModel != null
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return customGridItem(
                      context: context,
                      image: cartModel!
                          .data!.productsCart[index].productCartInfo!.image!,
                      nameProduct: cartModel!
                          .data!.productsCart[index].productCartInfo!.name!,
                      price: cartModel!
                          .data!.productsCart[index].productCartInfo!.price,
                      oldPrice: cartModel!
                          .data!.productsCart[index].productCartInfo!.oldPrice,
                      discount: cartModel!
                          .data!.productsCart[index].productCartInfo!.discount,
                      favoriteIcon:
                          ProductCubit.get(context).favoriteCartScreen[
                                  cartModel!.data!.productsCart[index]
                                      .productCartInfo!.id]!
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                ),
                      addCart: () {
                        ProductCubit.get(context).addOrRemoveCart(
                            ProductCubit.get(context).cartScreenProduct,
                            cartModel
                            !.data!.productsCart[index].productCartInfo!.id!);
                      },
                      addFavorite: () {
                        ProductCubit.get(context).addOrRemoveFavorite(
                            ProductCubit.get(context).favoriteHomeProduct,
                            cartModel
                            !.data!.productsCart[index].productCartInfo!.id!);
                      },
                      isCart: ProductCubit.get(context).cartScreenProduct[
                          cartModel
                          !.data!.productsCart[index].productCartInfo!.id],
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return ItemDetails(
                              id: cartModel
                              !.data!.productsCart[index].productCartInfo!.id,
                            );
                          }),
                        );
                      },
                      showAddCart: true,
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3.10,
                  ),
                  itemCount: cartModel!.data!.productsCart.length,
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
