import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map producto;
  final VoidCallback onAddToCart;

  const ProductCard({
    required this.producto,
    required this.onAddToCart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho de la pantalla para hacer el diseño responsivo
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: producto['imagen'] != null
                  ? Image.network(
                      producto['imagen'],
                      width: screenWidth * 0.2, // Ajuste dinámico
                      height: screenWidth * 0.2, // Ajuste dinámico
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image, size: screenWidth * 0.2),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto['nombre'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Ajuste dinámico
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Precio: S/${producto['precio']}',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  Text(
                    'Disponibilidad: ${producto['disponibilidad']}',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              color: Colors.blue,
              onPressed: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}
