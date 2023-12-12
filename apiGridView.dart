import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Romeo Bryan T. Salcedo IV - BSIT 3R7 
// Mobile programming
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyImageList(),
    );
  }
}

class MyImageList extends StatelessWidget {
  final String apiUrl = 'https://api.unsplash.com/collections/1111575/photos?client_id=oz5XiVMLnizAwBSkOVcwUmld_gXFmKW6fhy_u2BuFo0';
  //url of the API, collection, access key

  Future<List<String>> fetchImages() async {
    final response = await http.get(Uri.parse(apiUrl));
    //GET request to the provided API url to fetch data
    //makes use of the http.dart package
    if (response.statusCode == 200) {
      //if the request is successful / statuscode:200
      List<dynamic> data = json.decode(response.body);
       //decode the response body and take the number of items
      List<String> imageUrls = List<String>.from(data.map((item) => item['urls']['regular']));
       //extract the url field from the items and store the image URLs in a list
      return imageUrls;
       //list where the extracted URLs of the images is stored that is returned to fetchImages()
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<String>>(
        future: fetchImages(),
        //uses the list to populate the body with images
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
               //loading indicator
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No images found.'),
            );
          } else {
            return GridView.builder(
               // displays the images in gridview
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                // grid with a fixed number of tiles in the cross axis
                //crossaxiscount = 3 in a row as instructed
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    //onTap event when image is tapped
                    _showImageDialog(context, snapshot.data![index]);
                  },
                  child: Image.network(snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                //properties of the onTap event
              ),
            ),
          ),
        );
      },
    );
  }
}
