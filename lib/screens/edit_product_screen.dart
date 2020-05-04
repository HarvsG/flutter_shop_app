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

  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }

    _isInit = false;
    super.didChangeDependencies();
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

  Future<void> _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (_) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Error occured'),
                  content: Text(
                      'An error ocurred whilst trying to send the product details to the server'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('ok'))
                  ],
                );
              });
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      }
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
      String imageUrl,
      String isFavourite}) {
    Map<String, dynamic> temp = {
      'id': productToEdit.id,
      'title': productToEdit.title,
      'description': productToEdit.description,
      'price': productToEdit.price,
      'imageUrl': productToEdit.imageUrl,
      'isFavourite': productToEdit.isFavourite,
    };
    ({
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavourite': productToEdit.isFavourite,
    }).forEach((k, v) {
      if (v != null) {
        temp[k] = v;
      }
    });
    return Product(
        id: temp['id'],
        title: temp['title'],
        description: temp['description'],
        price: temp['price'],
        imageUrl: temp['imageUrl'],
        isFavourite: temp['isFavourite']);
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initValues['title'],
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
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
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
                          initialValue: _initValues['price'],
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
                          initialValue: _initValues['description'],
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
                            _editedProduct = _editProduct(_editedProduct,
                                description: value);
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
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
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
                                  //initialValue: _initValues['imageUrl'],
                                  decoration: InputDecoration(
                                    labelText: 'Image URL',
                                    hintText:
                                        'https://i.imgur.com/uNiQuEiD.jpg',
                                  ),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _imageFocusNode,
                                  validator: (value) {
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
                                    _editedProduct = _editProduct(
                                        _editedProduct,
                                        imageUrl: value);
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
