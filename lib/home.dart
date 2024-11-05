import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/model.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();

  getRecipe(String query) async{
    String url = "https://api.edamam.com/api/recipes/v2?type=public&q=${query}&app_id=6b97c14e&app_key=c8840473bb3e537498f050dc9bab00c1";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
    data["hits"].forEach((element){
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Ladoo");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff213A50),
                    Color(0xff071938)
                  ]
                )
              ),
            ),
          ),
          Column(
            children: [
              // Search Bar
              SafeArea(
                child: Container(
                  // Search Container
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if((searchController.text).replaceAll(" ", "") == ""){
                            print("Blank Search");
                          }else{
                            getRecipe(searchController.text);
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Let's cook something"),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("What do you want to cook today?", style: TextStyle(fontSize: 33, color: Colors.white),),
                    SizedBox(height: 10,),
                    Text("Let's cook something new", style: TextStyle(fontSize: 20, color: Colors.white),)
                  ],
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}
