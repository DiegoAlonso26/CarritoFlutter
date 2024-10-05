import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final Map producto;
  final int cantidad;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    required this.producto,
    required this.cantidad,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
            SizedBox(width: 15),
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
                  SizedBox(height: 5),
                  Text('Descripción: ${producto['descripcion']}'),
                  Text('Precio unitario: \$${producto['precio']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: onDecrement,
                          ),
                          Text('Cantidad: $cantidad',
                              style: TextStyle(fontSize: 18)),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: onIncrement,
                          ),
                        ],
                      ),
                      Text(
                        'Total: \$${(producto['precio'] * cantidad).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
