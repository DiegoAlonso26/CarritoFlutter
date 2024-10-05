import 'package:carrito/pages/CarritoPage.dart';
import 'package:carrito/widgets/product_cart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  List productos = [];
  List carrito = [];
  Map<int, int> cantidades = {};

  @override
  void initState() {
    super.initState();
    fetchProductos();
    cargarCarrito();
  }

  fetchProductos() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.102:5000/repuestos'));
    if (response.statusCode == 200) {
      setState(() {
        productos = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  void guardarCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> carritoStr =
        carrito.map((producto) => jsonEncode(producto)).toList();
    await prefs.setStringList('carrito', carritoStr);
  }

  void cargarCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? carritoStr = prefs.getStringList('carrito');
    if (carritoStr != null) {
      setState(() {
        carrito =
            carritoStr.map((productoStr) => jsonDecode(productoStr)).toList();
      });
    }
  }

  void agregarAlCarrito(producto) {
    setState(() {
      int productId = producto['id_repuestos'];
      if (cantidades.containsKey(productId)) {
        cantidades[productId] = cantidades[productId]! + 1;
      } else {
        carrito.add(producto);
        cantidades[productId] = 1;
      }
      guardarCarrito();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${producto['nombre']} agregado al carrito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CarritoPage(carrito: carrito, cantidades: cantidades),
                    ),
                  );
                },
              ),
              if (carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${carrito.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ProductCard(
                  producto: producto,
                  onAddToCart: () => agregarAlCarrito(producto),
                );
              },
            ),
    );
  }
}
