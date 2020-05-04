import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';
//import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  //EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null, title: null, description: null, price: null, imageUrl: null);
  //String _imageUrl;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    } else {
      return;
    }
    ;
  }

  Product _editProduct(Product productToEdit,
      {String id,
      String title,
      String description,
      double price,
      String imageUrl}) {
    Map<String, dynamic> temp = {
      'id': productToEdit.id,
      'title': productToEdit.title,
      'description': productToEdit.description,
      'price': productToEdit.price,
      'imageUrl': productToEdit.imageUrl,
    };
    print(temp);
    ({
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl
    }).forEach((k, v) {
      if (v != null) {
        temp[k] = v;
        print(v);
      }
    });
    print(temp);

    return Product(
        id: temp['id'],
        title: temp['title'],
        description: temp['description'],
        price: temp['price'],
        imageUrl: temp['imageUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g Flared Trousers',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct =
                          _editProduct(_editedProduct, title: value);
                    },
                    // onSaved: (value) {
                    //   _editedProduct = Product(
                    //       id: _editedProduct.id,
                    //       title: value,
                    //       description: _editedProduct.description,
                    //       price: _editedProduct.price,
                    //       imageUrl: _editedProduct.imageUrl);
                    // },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Price (£)',
                      hintText: '10.99',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value) <= 0.0) {
                        return 'Please enter a positive number';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = _editProduct(_editedProduct,
                          price: double.parse(value));
                    },
                    // onSaved: (value) {
                    //   _editedProduct = Product(
                    //       id: _editedProduct.id,
                    //       title: _editedProduct.title,
                    //       description: _editedProduct.description,
                    //       price: double.parse(value),
                    //       imageUrl: _editedProduct.imageUrl);
                    // },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                      hintText: 'An inspiring pair of 80s memorabelia',
                    ),
                    maxLines: 3,
                    //textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct =
                          _editProduct(_editedProduct, description: value);
                    },
                    // onSaved: (value) {
                    //   _editedProduct = Product(
                    //       id: _editedProduct.id,
                    //       title: _editedProduct.title,
                    //       description: value,
                    //       price: _editedProduct.price,
                    //       imageUrl: _editedProduct.imageUrl);
                    // },
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text(
                                  'Please enter a URL',
                                  style: TextStyle(color: Colors.grey),
                                ))
                              : FittedBox(
                                  child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                              hintText: 'https://i.imgur.com/uNiQuEiD.jpg',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            validator: (value) {
                              print(Uri.parse(value).isAbsolute);
                              if (value.isEmpty |
                                  !Uri.parse(value).isAbsolute) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct =
                                  _editProduct(_editedProduct, imageUrl: value);
                            },
                            // onSaved: (value) {
                            //   _editedProduct = Product(
                            //       id: _editedProduct.id,
                            //       title: _editedProduct.title,
                            //       description: _editedProduct.description,
                            //       price: _editedProduct.price,
                            //       imageUrl: value);
                            // },
                          ),
                        ),
                      ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
