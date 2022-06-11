// packeges
import 'package:flutter/material.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  ProductProvider _product = ProductProvider(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  bool autoAlways = false;
  bool isCheck = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_chnageFocusForImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isCheck) {
      isCheck = true;
      final ProductProvider? product =
          ModalRoute.of(context)!.settings.arguments as ProductProvider?;
      if (product != null) {
        _product = product;
        _imageUrlController.text = product.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_chnageFocusForImageUrl);

    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _imageUrlController.dispose();
    super.dispose();
  }

  void _chnageFocusForImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    setState(() {
      autoAlways = true;
    });
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    if (_product.id == '') {
      Provider.of<ProductsProvider>(context, listen: false).add(_product);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .update(_product.id, _product);
    }
    Navigator.of(context).pop();
  }

  void _addFeild(name, value) {
    _replaceData(isReplace, newValue, oldValue) {
      return isReplace ? newValue : oldValue;
    }

    final id = _replaceData(name == 'id', value, _product.id);
    final title = _replaceData(name == 'title', value, _product.title);
    final description =
        _replaceData(name == 'description', value, _product.description);
    final price = _replaceData(name == 'price', value, _product.price);
    final imageUrl = _replaceData(name == 'imageUrl', value, _product.imageUrl);
    final isFavorite =
        _replaceData(name == 'isFavorite', value, _product.isFavorite);
    _product = ProductProvider(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.id == '' ? 'Add product' : 'Edit product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: autoAlways ? AutovalidateMode.always : null,
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _product.title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title is must!';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                autofocus: true,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _addFeild('title', value),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _product.price.toString(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Amount is must!';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Amount is not Valid!';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount does not bigger 0.';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _addFeild('price', double.parse(value as String)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _product.description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _addFeild('description', value),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description is must!';
                  }
                  if (value.length < 10) {
                    return 'Description is smaller 10';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Ender a image Url')
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Image URL',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onSaved: (value) => _addFeild('imageUrl', value),
                      onFieldSubmitted: (_) => _saveForm(),
                      // onEditingComplete: () {
                      //   _imageUrlFocusNode.unfocus();
                      // },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Image URL is must!';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Image URL is not valid';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Image URL is not valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
