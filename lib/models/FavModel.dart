import 'package:equatable/equatable.dart';

class FavModel  extends Equatable{
  String name;
  int count;
  String image;
  bool isFav;
  FavModel({required this.count,required this.image,required this.isFav,required this.name});


toMap(){
  return {
    "name":name,
    "count":count,
    "isFav":isFav,
    "image":image
  };
}


static fromMap(Map<String,dynamic> map){
  return FavModel(count: map['count'], image:map['image'], isFav: map['isFav'], name: map['name']);
}

  @override
  List<Object?> get props => [name,count,image,isFav];
  
}