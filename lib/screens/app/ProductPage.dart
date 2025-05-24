
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/models/FavModel.dart';
import 'package:almoktar/screens/app/FavPage.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
   ProductPage({super.key});
Set<FavModel>  products={FavModel(count: 20, image:"http://", name: "Banana",isFav: false),FavModel(isFav: false,count: 20, image:"http://", name: "Kiwiw"),FavModel(count: 20,isFav: false, image:"http://", name: "Apple"),FavModel(count: 20,isFav: false, image:"http://", name: "Apple")};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ListTile(title: Text(products.elementAt(index).name),
        
        trailing: IconButton(onPressed: (){
          // FavModel favModel = FavModel(count: products[index].count, image: products[index].image, isFav: true, name: products[index].name);
          if (!products.elementAt(index).isFav) {
          // fav.add(products.elementAt(index)
          //   );
  
  
  // addToFavortite(products.elementAt(index));
          products.elementAt(index).isFav = true;
            
          }
        }, icon: Icon(Icons.favorite,
        // ! write in-line if conitaion to make it colored when it fav 
        // ! and make it with statful builder to real time ui update
        ),),
        ),),

        floatingActionButton: FloatingActionButton(onPressed: () {
          // Navigator.push(context,MaterialPageRoute(builder:  (context) => FavPage(),));
        },),
    );
  }
}